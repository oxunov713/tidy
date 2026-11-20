import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_core/src/providers/providers.dart';
import 'package:tidy_core/src/realtime/realtime_event.dart';

part 'room_access.g.dart';

/// True once the server told us we lost access to [room] (the booking was
/// reassigned or cancelled, the cleaner was suspended). Watch it from a screen
/// that shows a booking to say so and close the conversation.
@riverpod
class RoomAccessRevoked extends _$RoomAccessRevoked {
  @override
  bool build(String room) {
    final subscription = ref.watch(realtimeClientProvider).events.listen((
      event,
    ) {
      if (event is RoomUnsubscribed &&
          event.accessRevoked &&
          event.room == room) {
        state = true;
      }
    });
    ref.onDispose(() => unawaited(subscription.cancel()));
    return false;
  }
}
