import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

const _entries = [
  ChatEntry(id: '1', body: 'Hello', timeLabel: '10:00', mine: false),
  ChatEntry(id: '2', body: 'On my way', timeLabel: '10:05', mine: true),
];

Widget _host({
  List<ChatEntry> entries = _entries,
  Future<void> Function(String)? onSend,
  void Function(Object)? onError,
  String? closedNotice,
}) => MaterialApp(
  theme: TidyTheme.light(),
  home: Scaffold(
    body: ChatView(
      entries: entries,
      onSend: onSend ?? (_) async {},
      onSendError: onError,
      hintText: 'Message',
      sendLabel: 'Send',
      emptyTitle: 'No messages',
      emptyMessage: 'Say hello',
      closedNotice: closedNotice,
    ),
  ),
);

void main() {
  testWidgets('shows messages with their time, newest at the bottom', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('10:05'), findsOneWidget);
    final hello = tester.getBottomLeft(find.text('Hello')).dy;
    final reply = tester.getBottomLeft(find.text('On my way')).dy;
    expect(reply, greaterThan(hello));
  });

  testWidgets('empty conversation shows the empty state', (tester) async {
    await tester.pumpWidget(_host(entries: const []));
    expect(find.text('No messages'), findsOneWidget);
  });

  testWidgets('send trims the text, clears the box, ignores blanks', (
    tester,
  ) async {
    final sent = <String>[];
    await tester.pumpWidget(_host(onSend: (t) async => sent.add(t)));

    await tester.enterText(find.byKey(const Key('chatInput')), '   ');
    await tester.tap(find.byKey(const Key('chatSend')));
    await tester.pump();
    expect(sent, isEmpty);

    await tester.enterText(find.byKey(const Key('chatInput')), '  Hi there ');
    await tester.tap(find.byKey(const Key('chatSend')));
    await tester.pump();
    expect(sent, ['Hi there']);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('chatInput')))
          .controller!
          .text,
      isEmpty,
    );
  });

  testWidgets('a failed send keeps the text and reports the error', (
    tester,
  ) async {
    Object? reported;
    await tester.pumpWidget(
      _host(
        onSend: (_) async => throw StateError('offline'),
        onError: (e) => reported = e,
      ),
    );
    await tester.enterText(find.byKey(const Key('chatInput')), 'Hi');
    await tester.tap(find.byKey(const Key('chatSend')));
    await tester.pump();
    expect(reported, isA<StateError>());
    expect(find.text('Hi'), findsOneWidget);
  });

  testWidgets('a closed conversation has a notice and no composer', (
    tester,
  ) async {
    await tester.pumpWidget(_host(closedNotice: 'This chat is closed'));
    expect(find.byKey(const Key('chatClosedNotice')), findsOneWidget);
    expect(find.byKey(const Key('chatInput')), findsNothing);
    expect(find.byKey(const Key('chatSend')), findsNothing);
    expect(find.text('Hello'), findsOneWidget);
  });
}
