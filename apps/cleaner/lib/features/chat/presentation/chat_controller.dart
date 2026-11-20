import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/chat/data/api_chat_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'chat_controller.g.dart';

/// Messages of one booking: history from the API, new ones from
/// `message.new` over the WebSocket.
@riverpod
class ChatController extends _$ChatController {
  @override
  Future<List<Message>> build(String bookingId) async {
    final events = ref.watch(realtimeClientProvider).bookingEvents(bookingId);
    final subscription = events.listen((event) {
      switch (event) {
        case MessageReceived(:final message):
          _add(message);
        case Reconnected():
          // Messages sent while the socket was down.
          unawaited(_refetch());
        case _:
          break;
      }
    });
    ref.onDispose(() => unawaited(subscription.cancel()));
    return _sorted(await ref.read(chatRepositoryProvider).history(bookingId));
  }

  Future<void> _refetch() async {
    try {
      final history = await ref.read(chatRepositoryProvider).history(bookingId);
      if (!ref.mounted) return;
      history.forEach(_add);
    } on Object {
      // The next reconnect or send tries again.
    }
  }

  /// Throws when the message could not be sent.
  Future<void> send(String body) async {
    final text = body.trim();
    if (text.isEmpty) return;
    final message = await ref
        .read(chatRepositoryProvider)
        .send(bookingId, text);
    if (ref.mounted) _add(message);
  }

  // The same message can arrive twice: as the reply to send() and over the
  // socket.
  void _add(Message message) {
    final current = state.value;
    if (current == null || current.any((m) => m.id == message.id)) return;
    state = AsyncData(_sorted([...current, message]));
  }

  static List<Message> _sorted(List<Message> messages) =>
      [...messages]..sort((a, b) => a.id.compareTo(b.id));
}
