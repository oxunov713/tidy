import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/core/realtime/realtime_gateway.dart';
import 'package:tidy_cleaner/features/chat/data/api_chat_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'chat_controller.g.dart';

/// Messages of one booking: history from the API, new ones from
/// `message.new` over the WebSocket.
@riverpod
class ChatController extends _$ChatController {
  @override
  Future<List<Message>> build(String bookingId) async {
    final gateway = ref.watch(realtimeGatewayProvider);
    final room = Rooms.booking(bookingId);
    gateway.subscribe(room);
    final events = gateway.events.listen((event) {
      if (event is MessageReceived && event.bookingId == bookingId) {
        _add(event.message);
      }
    });
    ref.onDispose(() {
      unawaited(events.cancel());
      gateway.unsubscribe(room);
    });
    return _sorted(await ref.read(chatRepositoryProvider).history(bookingId));
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
