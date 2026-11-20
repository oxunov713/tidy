import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_core/tidy_core.dart';

part 'live_channel.g.dart';

/// What the screens need from the WebSocket: a stream of events for one
/// booking. Kept apart from [RealtimeClient] so screens and tests do not deal
/// with room names or connection handling.
abstract interface class LiveChannel {
  Future<void> connect();
  Future<void> disconnect();

  /// Events of the `booking:<id>` room. The room is joined when the first
  /// listener arrives and left when the last one cancels.
  Stream<RealtimeEvent> bookingEvents(String bookingId);
}

class RealtimeLiveChannel implements LiveChannel {
  RealtimeLiveChannel(this._client);

  final RealtimeClient _client;

  @override
  Future<void> connect() => _client.connect();

  @override
  Future<void> disconnect() => _client.disconnect();

  @override
  Stream<RealtimeEvent> bookingEvents(String bookingId) {
    late StreamController<RealtimeEvent> controller;
    StreamSubscription<RealtimeEvent>? subscription;
    final room = Rooms.booking(bookingId);

    controller = StreamController<RealtimeEvent>(
      onListen: () {
        subscription = _client.events
            .where((e) => _belongs(e, bookingId))
            .listen(
              controller.add,
            );
        _client.subscribe(room);
      },
      onCancel: () async {
        _client.unsubscribe(room);
        await subscription?.cancel();
      },
    );
    return controller.stream;
  }

  static bool _belongs(RealtimeEvent event, String bookingId) =>
      switch (event) {
        BookingStatusChanged(bookingId: final id) => id == bookingId,
        CleanerLocationUpdated(bookingId: final id) => id == bookingId,
        MessageReceived(bookingId: final id) => id == bookingId,
        _ => false,
      };
}

@Riverpod(keepAlive: true)
LiveChannel liveChannel(Ref ref) =>
    RealtimeLiveChannel(ref.watch(realtimeClientProvider));
