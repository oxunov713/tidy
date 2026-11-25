import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/chat/data/chat_repository_impl.dart';
import 'package:tidy_client/features/chat/domain/chat_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'chat_providers.g.dart';

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) =>
    ChatRepositoryImpl(api: ref.watch(bookingApiProvider));

/// Messages of one booking: history plus `message.new` events as they come.
@riverpod
class Chat extends _$Chat {
  @override
  Future<List<Message>> build(String bookingId) async {
    final sub = ref
        .read(realtimeClientProvider)
        .bookingEvents(bookingId)
        .listen((
          event,
        ) {
          switch (event) {
            case MessageReceived(:final message):
              _add(message);
            case Reconnected():
              // Messages that arrived while the socket was down.
              unawaited(_refetch());
            case _:
              break;
          }
        });
    ref.onDispose(() => unawaited(sub.cancel()));
    return ref.watch(chatRepositoryProvider).messages(bookingId);
  }

  Future<void> _refetch() async {
    try {
      final messages = await ref
          .read(chatRepositoryProvider)
          .messages(bookingId);
      if (!ref.mounted) return;
      messages.forEach(_add);
    } on Object {
      // The next reconnect or send tries again.
    }
  }

  Future<void> send(String body) async {
    final message = await ref
        .read(chatRepositoryProvider)
        .send(bookingId, body.trim());
    _add(message);
  }

  /// The sender also receives their own message over the socket, so the id is
  /// checked to avoid showing it twice.
  void _add(Message message) {
    final current = state.value;
    if (current == null || current.any((m) => m.id == message.id)) return;
    state = AsyncData([...current, message]);
  }
}

/// A booking that has a cleaner to talk to, with the cleaner's name.
class ChatThread {
  const ChatThread({required this.booking, required this.cleaner});

  final Booking booking;
  final CleanerCard cleaner;
}

/// Bookings with a cleaner, newest first, for the Chat tab. Names come from
/// the booking details, so this is capped to the latest few.
@riverpod
Future<List<ChatThread>> chatThreads(Ref ref) async {
  final upcoming = await ref.watch(
    bookingsListProvider(BookingScope.upcoming).future,
  );
  final past = await ref.watch(bookingsListProvider(BookingScope.past).future);
  final bookings =
      [...upcoming.items, ...past.items]
          .where(
            (b) => b.cleanerId != null && b.status != BookingStatus.cancelled,
          )
          .toList()
        ..sort((a, b) => b.start.compareTo(a.start));

  final threads = await Future.wait([
    for (final b in bookings.take(15))
      ref
          .watch(bookingDetailsProvider(b.id).future)
          .then(
            (d) => d.cleaner == null
                ? null
                : ChatThread(booking: b, cleaner: d.cleaner!),
          ),
  ]);
  return threads.whereType<ChatThread>().toList();
}
