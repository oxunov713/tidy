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
/// was joined before. Listen to [events] for server messages.
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
  final _rooms = <String>{};

  WebSocketChannel? _channel;
  // Cancelled in _teardown.
  // ignore: cancel_subscriptions
  StreamSubscription<dynamic>? _subscription;
  Timer? _retryTimer;
  var _wanted = false;
  var _attempt = 0;
  RealtimeConnectionState _state = RealtimeConnectionState.disconnected;

  Stream<RealtimeEvent> get events => _events.stream;
  Stream<RealtimeConnectionState> get connectionState => _states.stream;
  RealtimeConnectionState get state => _state;

  /// Rooms that will be (re)joined on every connection.
  Set<String> get rooms => Set.unmodifiable(_rooms);

  /// Opens the socket and keeps it open until [disconnect].
  Future<void> connect() async {
    if (_wanted) return;
    _wanted = true;
    await _open();
  }

  /// Closes the socket and stops reconnecting. Joined rooms are forgotten.
  Future<void> disconnect() async {
    _wanted = false;
    _rooms.clear();
    _retryTimer?.cancel();
    await _teardown();
    _setState(RealtimeConnectionState.disconnected);
  }

  /// Joins [room]. Safe to call while offline: it is sent once connected, and
  /// again after every reconnect.
  void subscribe(String room) {
    if (_rooms.add(room)) _send({'type': 'subscribe', 'room': room});
  }

  void unsubscribe(String room) {
    if (_rooms.remove(room)) _send({'type': 'unsubscribe', 'room': room});
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

  Future<void> _open() async {
    if (!_wanted) return;
    _setState(RealtimeConnectionState.connecting);

    final channel = await _tryConnect();
    if (channel == null) return;
    if (!_wanted) {
      unawaited(channel.sink.close());
      return;
    }

    _channel = channel;
    _attempt = 0;
    _setState(RealtimeConnectionState.connected);
    for (final room in _rooms) {
      _send({'type': 'subscribe', 'room': room});
    }
    _subscription = channel.stream.listen(
      _onFrame,
      onError: (Object _) => _onClosed(),
      onDone: _onClosed,
    );
  }

  Future<WebSocketChannel?> _tryConnect() async {
    try {
      final tokens = await _storage.read();
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
      await _runHandshakeHook();
      _scheduleReconnect();
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
    if (event != null && !_events.isClosed) _events.add(event);
  }

  void _onClosed() {
    unawaited(_teardown());
    if (!_wanted) return;
    _setState(RealtimeConnectionState.connecting);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (!_wanted) return;
    _retryTimer?.cancel();
    final delay = _backoff(_attempt);
    _attempt++;
    _retryTimer = Timer(delay, () => unawaited(_open()));
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
