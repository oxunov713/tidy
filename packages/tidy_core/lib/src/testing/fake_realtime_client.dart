import 'dart:async';

import 'package:tidy_core/src/realtime/realtime_client.dart';
import 'package:tidy_core/src/realtime/realtime_event.dart';

/// A [RealtimeClient] for widget and controller tests: no socket, events are
/// pushed with [emit], and every call is recorded. Rooms are reference counted
/// like in the real client, and `access_revoked` drops a room the same way.
///
/// ```dart
/// final realtime = FakeRealtimeClient();
/// overrides: [realtimeClientProvider.overrideWithValue(realtime)]
/// ```
class FakeRealtimeClient implements RealtimeClient {
  final _events = StreamController<RealtimeEvent>.broadcast();
  final _states = StreamController<RealtimeConnectionState>.broadcast();
  final _counts = <String, int>{};

  /// Every room passed to [subscribe], in order (including repeats).
  final subscribeCalls = <String>[];

  /// Every room passed to [unsubscribe], in order.
  final unsubscribeCalls = <String>[];

  /// Locations the cleaner app sent while [state] was connected.
  final sentLocations = <({String bookingId, double lat, double lng})>[];

  int connectCalls = 0;
  int disconnectCalls = 0;
  var _state = RealtimeConnectionState.disconnected;

  /// Pretend the socket is down: [sendLocation] then returns false.
  bool offline = false;

  /// Delivers [event] to listeners.
  void emit(RealtimeEvent event) {
    if (event is RoomUnsubscribed && event.accessRevoked) {
      _counts.remove(event.room);
    }
    _events.add(event);
  }

  /// Rooms the server would still be sending us.
  @override
  Set<String> get rooms => _counts.keys.toSet();

  /// How many screens currently hold [room].
  int countOf(String room) => _counts[room] ?? 0;

  @override
  Stream<RealtimeEvent> get events => _events.stream;

  @override
  Stream<RealtimeConnectionState> get connectionState => _states.stream;

  @override
  RealtimeConnectionState get state => _state;

  @override
  Future<void> Function()? get onHandshakeFailed => null;

  @override
  Future<void> connect() async {
    connectCalls++;
    _state = RealtimeConnectionState.connected;
    _states.add(_state);
  }

  @override
  Future<void> disconnect() async {
    disconnectCalls++;
    _counts.clear();
    _state = RealtimeConnectionState.disconnected;
    _states.add(_state);
  }

  @override
  void subscribe(String room) {
    subscribeCalls.add(room);
    _counts.update(room, (n) => n + 1, ifAbsent: () => 1);
  }

  @override
  void unsubscribe(String room) {
    unsubscribeCalls.add(room);
    final count = _counts[room];
    if (count == null) return;
    if (count > 1) {
      _counts[room] = count - 1;
    } else {
      _counts.remove(room);
    }
  }

  @override
  bool sendLocation({
    required String bookingId,
    required double lat,
    required double lng,
  }) {
    if (offline) return false;
    sentLocations.add((bookingId: bookingId, lat: lat, lng: lng));
    return true;
  }

  @override
  Future<void> dispose() async {
    await _events.close();
    await _states.close();
  }
}
