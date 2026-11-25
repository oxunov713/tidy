import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_cleaner/features/chat/presentation/chat_page.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/harness.dart';
import 'support/pump_app.dart';

void main() {
  testWidgets('sends a message and keeps the history', (tester) async {
    final h = Harness()
      ..chatRepo.messages = [
        Message(
          id: 1,
          bookingId: 'b1',
          senderId: 'client',
          body: 'The key is under the mat',
          createdAt: DateTime.utc(2026, 12, 3, 8),
        ),
      ];
    await pumpApp(tester, h, const ChatPage(bookingId: 'b1'));
    expect(find.text('The key is under the mat'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('chatInput')), 'On my way');
    await tester.tap(find.byKey(const Key('chatSend')));
    await settle(tester);
    expect(h.chatRepo.sent, ['On my way']);
    expect(find.text('On my way'), findsOneWidget);
  });

  testWidgets('access revoked: the conversation closes, history stays', (
    tester,
  ) async {
    final h = Harness()
      ..chatRepo.messages = [
        Message(
          id: 1,
          bookingId: 'b1',
          senderId: 'client',
          body: 'See you soon',
          createdAt: DateTime.utc(2026, 12, 3, 8),
        ),
      ];
    await pumpApp(tester, h, const ChatPage(bookingId: 'b1'));
    expect(find.byKey(const Key('chatInput')), findsOneWidget);

    h.gateway.emit(
      RoomUnsubscribed(Rooms.booking('b1'), reason: 'access_revoked'),
    );
    await settle(tester);

    expect(find.text('This conversation is closed.'), findsOneWidget);
    expect(find.byKey(const Key('chatInput')), findsNothing);
    expect(find.text('See you soon'), findsOneWidget);
  });
}
