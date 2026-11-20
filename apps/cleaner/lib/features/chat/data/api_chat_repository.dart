import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/chat/domain/chat_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'api_chat_repository.g.dart';

class ApiChatRepository implements ChatRepository {
  const ApiChatRepository(this._api);

  final BookingApi _api;

  @override
  Future<List<Message>> history(String bookingId) => _api.messages(bookingId);

  @override
  Future<Message> send(String bookingId, String body) =>
      _api.sendMessage(bookingId, body);
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) =>
    ApiChatRepository(ref.watch(bookingApiProvider));
