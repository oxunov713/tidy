import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_core/tidy_core.dart';

part 'realtime_gateway.g.dart';

/// What the app needs from the WebSocket. Controllers depend on this instead
/// of [RealtimeClient] so tests can drive them with a fake.
abstract interface class RealtimeGateway {
  Stream<RealtimeEvent> get events;

  Future<void> connect();
  Future<void> disconnect();

  /// Joins [room]. Calls are counted: the room is left once every caller has
  /// called [unsubscribe], so the chat and the job screen can share one.
  void subscribe(String room);
  void unsubscribe(String room);

  /// Returns false while the socket is down; the next tick makes up for it.
  bool sendLocation({
    required String bookingId,
    required double lat,
    required double lng,
  });
}

class ClientRealtimeGateway implements RealtimeGateway {
  ClientRealtimeGateway(this._client);

  final RealtimeClient _client;
  final _refCounts = <String, int>{};

  @override
  Stream<RealtimeEvent> get events => _client.events;

  @override
  Future<void> connect() => _client.connect();

  @override
  Future<void> disconnect() {
    _refCounts.clear();
    return _client.disconnect();
  }

  @override
  void subscribe(String room) {
    _refCounts.update(room, (n) => n + 1, ifAbsent: () => 1);
    _client.subscribe(room);
  }

  @override
  void unsubscribe(String room) {
    final left = (_refCounts[room] ?? 1) - 1;
    if (left > 0) {
      _refCounts[room] = left;
      return;
    }
    _refCounts.remove(room);
    _client.unsubscribe(room);
  }

  @override
  bool sendLocation({
    required String bookingId,
    required double lat,
    required double lng,
  }) => _client.sendLocation(bookingId: bookingId, lat: lat, lng: lng);
}

@Riverpod(keepAlive: true)
RealtimeGateway realtimeGateway(Ref ref) =>
    ClientRealtimeGateway(ref.watch(realtimeClientProvider));
