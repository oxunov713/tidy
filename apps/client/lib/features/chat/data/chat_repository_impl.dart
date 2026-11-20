import 'package:tidy_client/features/chat/domain/chat_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required this._api});

  final BookingApi _api;

  @override
  Future<List<Message>> messages(String bookingId) => _api.messages(bookingId);

  @override
  Future<Message> send(String bookingId, String body) =>
      _api.sendMessage(bookingId, body);
}
