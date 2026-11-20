import 'package:tidy_core/tidy_core.dart';

abstract interface class ChatRepository {
  Future<List<Message>> messages(String bookingId);
  Future<Message> send(String bookingId, String body);
}
