import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_client/features/chat/domain/chat_repository.dart';
import 'package:tidy_client/features/chat/presentation/chat_providers.dart';
import 'package:tidy_client/features/chat/presentation/chat_screen.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';
import '../helpers/fixtures.dart' as fx;
import '../helpers/viewport.dart';

class _FakeChatRepository implements ChatRepository {
  final sent = <String>[];

  @override
  Future<List<Message>> messages(String bookingId) async => [
    Message(
      id: 1,
      bookingId: bookingId,
      senderId: 'cleaner-1',
      body: 'Running 5 minutes late',
      createdAt: DateTime.utc(2026, 12, 3, 9, 30),
    ),
  ];

  @override
  Future<Message> send(String bookingId, String body) async {
    sent.add(body);
    return Message(
      id: 2,
      bookingId: bookingId,
      senderId: fx.user().id,
      body: body,
      createdAt: DateTime.utc(2026, 12, 3, 9, 31),
    );
  }
}

void main() {
  late _FakeChatRepository chat;
  late Fakes fakes;
  late Booking booking;

  Future<void> open(WidgetTester tester) async {
    usePhoneScreen(tester);
    chat = _FakeChatRepository();
    booking = fx.booking(status: BookingStatus.assigned, cleanerId: 'c');
    fakes = Fakes(
      bookings: FakeBookingRepository()
        ..detailsById = {
          booking.id: BookingDetails(booking: booking, address: fx.home),
        },
    );
    await pumpScreen(
      tester,
      ChatScreen(bookingId: booking.id),
      fakes,
      extraOverrides: [chatRepositoryProvider.overrideWithValue(chat)],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows history and sends a message', (tester) async {
    await open(tester);
    expect(find.text('Running 5 minutes late'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('chatInput')), 'Thanks!');
    await tester.tap(find.byKey(const Key('chatSend')));
    await tester.pumpAndSettle();

    expect(chat.sent, ['Thanks!']);
    expect(find.text('Thanks!'), findsOneWidget);
  });

  testWidgets('losing access closes the conversation', (tester) async {
    await open(tester);
    expect(find.byKey(const Key('chatInput')), findsOneWidget);

    fakes.realtime.emit(
      RoomUnsubscribed(Rooms.booking(booking.id), reason: 'access_revoked'),
    );
    await tester.pumpAndSettle();

    expect(find.text('This conversation is closed.'), findsOneWidget);
    expect(find.byKey(const Key('chatInput')), findsNothing);
    // The history stays readable.
    expect(find.text('Running 5 minutes late'), findsOneWidget);
  });

  testWidgets('another booking losing access does not close this one', (
    tester,
  ) async {
    await open(tester);
    fakes.realtime.emit(
      const RoomUnsubscribed('booking:other', reason: 'access_revoked'),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chatInput')), findsOneWidget);
  });
}
