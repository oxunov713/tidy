import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:tidy_core/src/api/api_config.dart';
import 'package:tidy_core/src/auth/token_storage.dart';
import 'package:tidy_core/src/realtime/realtime_event.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum RealtimeConnectionState { disconnected, connecting, connected }

/// Room names understood by the server.
abstract final class Rooms {
  static String booking(String bookingId) => 'booking:$bookingId';

  /// Cleaners only: new job offers.
  static const cleanerOffers = 'cleaner:offers';
}

/// Exponential backoff with jitter: about 0.5 s, 1 s, 2 s ... capped at 30 s.
Duration defaultBackoff(int attempt, [Random? random]) {
  final base = min(30000, 500 * pow(2, min(attempt, 10)).toInt());
  final jitter = 0.8 + (random ?? Random()).nextDouble() * 0.4;
  return Duration(milliseconds: (base * jitter).round());
}

/// One WebSocket per app session.
///
/// After [connect] the client keeps the socket open: when it drops it waits
/// (backoff), reconnects with a fresh token and subscribes to every room that
/// was joined before, then emits [Reconnected]. Listen to [events] for server
/// messages.
///
/// Rooms are reference counted. Several screens can [subscribe] to the same
/// room (the chat and the tracking screen both follow `booking:<id>`); the
/// server hears about it once, and again only leaves the room when every
/// caller has called [unsubscribe].
class RealtimeClient {
  RealtimeClient({
    required this._config,
    required TokenStorage tokenStorage,
    this.onHandshakeFailed,
    WebSocketChannel Function(Uri uri)? connector,
    Duration Function(int attempt)? backoff,
  }) : _storage = tokenStorage,
       _connector = connector ?? WebSocketChannel.connect,
       _backoff = backoff ?? defaultBackoff;

  final ApiConfig _config;
  final TokenStorage _storage;
  final WebSocketChannel Function(Uri uri) _connector;
  final Duration Function(int attempt) _backoff;

  /// Called after the socket could not be opened (for example because the
  /// access token expired), before the next attempt. Wire it to a token
  /// refresh. Errors from the callback are ignored.
  final Future<void> Function()? onHandshakeFailed;

  final _events = StreamController<RealtimeEvent>.broadcast();
  final _states = StreamController<RealtimeConnectionState>.broadcast();
  final _rooms = <String, int>{};

  WebSocketChannel? _channel;
  // Cancelled in _teardown.
  // ignore: cancel_subscriptions
  StreamSubscription<dynamic>? _subscription;
  Timer? _retryTimer;
  var _wanted = false;
  var _attempt = 0;

  /// Bumped by [connect] and [disconnect]. A connection attempt that started
  /// in an earlier epoch (for example before the user signed out and another
  /// signed in) must not install its socket: it may carry the old token.
  var _epoch = 0;

  /// True after a socket was lost or an attempt failed; the next successful
  /// connection then reports [Reconnected].
  var _lost = false;
  RealtimeConnectionState _state = RealtimeConnectionState.disconnected;

  Stream<RealtimeEvent> get events => _events.stream;
  Stream<RealtimeConnectionState> get connectionState => _states.stream;
  RealtimeConnectionState get state => _state;

  /// Rooms that will be (re)joined on every connection.
  Set<String> get rooms => Set.unmodifiable(_rooms.keys.toSet());

  /// Opens the socket and keeps it open until [disconnect].
  Future<void> connect() async {
    if (_wanted) return;
    _wanted = true;
    _lost = false;
    await _open(++_epoch);
  }

  /// Closes the socket and stops reconnecting. Joined rooms are forgotten.
  Future<void> disconnect() async {
    _wanted = false;
    _epoch++;
    _lost = false;
    _rooms.clear();
    _retryTimer?.cancel();
    await _teardown();
    _setState(RealtimeConnectionState.disconnected);
  }

  /// Joins [room]. Safe to call while offline: it is sent once connected, and
  /// again after every reconnect. Every call must be paired with one
  /// [unsubscribe].
  void subscribe(String room) {
    final count = _rooms[room] ?? 0;
    _rooms[room] = count + 1;
    if (count == 0) _send({'type': 'subscribe', 'room': room});
  }

  /// Gives back one [subscribe]. The room is left when it was the last one.
  /// Unknown rooms are ignored, so a screen that outlives a revoked room or a
  /// sign-out can still clean up.
  void unsubscribe(String room) {
    final count = _rooms[room];
    if (count == null) return;
    if (count > 1) {
      _rooms[room] = count - 1;
      return;
    }
    _rooms.remove(room);
    _send({'type': 'unsubscribe', 'room': room});
  }

  /// Cleaner app: shares the current position for [bookingId]. Returns false
  /// (and drops the update) while offline; the next tick makes up for it.
  bool sendLocation({
    required String bookingId,
    required double lat,
    required double lng,
  }) => _send({
    'type': 'location',
    'booking_id': bookingId,
    'lat': lat,
    'lng': lng,
  });

  Future<void> dispose() async {
    await disconnect();
    await _events.close();
    await _states.close();
  }

  Future<void> _open(int epoch) async {
    if (!_wanted || epoch != _epoch) return;
    _setState(RealtimeConnectionState.connecting);

    final channel = await _tryConnect(epoch);
    if (channel == null) return;
    if (!_wanted || epoch != _epoch) {
      unawaited(channel.sink.close());
      return;
    }

    _channel = channel;
    _attempt = 0;
    _setState(RealtimeConnectionState.connected);
    for (final room in _rooms.keys) {
      _send({'type': 'subscribe', 'room': room});
    }
    _subscription = channel.stream.listen(
      _onFrame,
      onError: (Object _) => _onClosed(epoch),
      onDone: () => _onClosed(epoch),
    );
    if (_lost) {
      _lost = false;
      _emit(const Reconnected());
    }
  }

  Future<WebSocketChannel?> _tryConnect(int epoch) async {
    try {
      final tokens = await _storage.read();
      // Signed out or signed in as someone else while the token was being
      // read: this attempt belongs to a session that no longer exists.
      if (epoch != _epoch) return null;
      if (tokens == null) {
        // Signed out: nothing to connect with, and retrying would not help.
        _wanted = false;
        _setState(RealtimeConnectionState.disconnected);
        return null;
      }
      final channel = _connector(_config.websocketUri(tokens.accessToken));
      await channel.ready;
      return channel;
    } on Object {
      if (epoch != _epoch) return null;
      _lost = true;
      await _runHandshakeHook();
      _scheduleReconnect(epoch);
      return null;
    }
  }

  Future<void> _runHandshakeHook() async {
    try {
      await onHandshakeFailed?.call();
    } on Object {
      // Best effort; the next attempt will report its own failure.
    }
  }

  void _onFrame(dynamic frame) {
    if (frame is! String) return;
    final event = RealtimeEvent.parse(frame);
    if (event == null) return;
    if (event is RoomUnsubscribed && event.accessRevoked) {
      // The server already removed us from the room. Forget it so a
      // reconnect does not ask for it again; screens that still hold it
      // see the event and let go.
      _rooms.remove(event.room);
    }
    _emit(event);
  }

  void _emit(RealtimeEvent event) {
    if (!_events.isClosed) _events.add(event);
  }

  void _onClosed(int epoch) {
    if (epoch != _epoch) return;
    unawaited(_teardown());
    if (!_wanted) return;
    _lost = true;
    _setState(RealtimeConnectionState.connecting);
    _scheduleReconnect(epoch);
  }

  void _scheduleReconnect(int epoch) {
    if (!_wanted || epoch != _epoch) return;
    _retryTimer?.cancel();
    final delay = _backoff(_attempt);
    _attempt++;
    _retryTimer = Timer(delay, () => unawaited(_open(epoch)));
  }

  bool _send(Map<String, Object?> message) {
    final channel = _channel;
    if (channel == null || _state != RealtimeConnectionState.connected) {
      return false;
    }
    channel.sink.add(jsonEncode(message));
    return true;
  }

  Future<void> _teardown() async {
    final subscription = _subscription;
    final channel = _channel;
    _subscription = null;
    _channel = null;
    await subscription?.cancel();
    try {
      await channel?.sink.close();
    } on Object {
      // Already closed.
    }
  }

  void _setState(RealtimeConnectionState value) {
    if (_state == value) return;
    _state = value;
    if (!_states.isClosed) _states.add(value);
  }
}

/// A screen's view of one booking.
extension BookingRoom on RealtimeClient {
  /// Events of the `booking:<id>` room: status changes, cleaner positions and
  /// messages for that booking, plus [Reconnected] (refetch what you show) and
  /// the room's own [RoomUnsubscribed] (for example `access_revoked`).
  ///
  /// The room is joined when the first listener arrives and left when it
  /// cancels. Because rooms are reference counted, a second screen watching
  /// the same booking keeps the room alive when the first one closes.
  Stream<RealtimeEvent> bookingEvents(String bookingId) {
    final room = Rooms.booking(bookingId);
    late StreamController<RealtimeEvent> controller;
    StreamSubscription<RealtimeEvent>? subscription;

    bool belongs(RealtimeEvent event) => switch (event) {
      BookingStatusChanged(bookingId: final id) => id == bookingId,
      CleanerLocationUpdated(bookingId: final id) => id == bookingId,
      MessageReceived(bookingId: final id) => id == bookingId,
      RoomUnsubscribed(room: final r) => r == room,
      Reconnected() => true,
      _ => false,
    };

    controller = StreamController<RealtimeEvent>(
      onListen: () {
        subscription = events.where(belongs).listen(controller.add);
        subscribe(room);
      },
      onCancel: () async {
        unsubscribe(room);
        await subscription?.cancel();
      },
    );
    return controller.stream;
  }
}
