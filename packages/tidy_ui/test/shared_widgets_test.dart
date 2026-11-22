import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

Widget _host(Widget child, {double? width}) => MaterialApp(
  theme: TidyTheme.light(),
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, child: child),
    ),
  ),
);

void main() {
  test('the bundled fonts are declared in the package', () async {
    final manifest = await rootBundle.loadString('FontManifest.json');
    expect(manifest, contains('"family":"Inter"'));
    expect(manifest, contains('"family":"SpaceGrotesk"'));
  });

  group('TidyChip', () {
    testWidgets('a long label in a narrow row does not overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Row(
            children: [
              Flexible(
                child: TidyChip(
                  label: 'A very long filter name that cannot possibly fit',
                  selected: true,
                  icon: Icons.check,
                  onSelected: (_) {},
                ),
              ),
            ],
          ),
          width: 120,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('TidyButton danger', () {
    testWidgets('is red and stays red while loading', (tester) async {
      await tester.pumpWidget(
        _host(
          TidyButton(
            label: 'Cancel booking',
            variant: TidyButtonVariant.danger,
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      final bg = button.style!.backgroundColor!.resolve({});
      expect(bg, TidyColors.danger);
      final disabled = button.style!.backgroundColor!.resolve({
        WidgetState.disabled,
      });
      expect(disabled, TidyColors.danger);
    });
  });

  group('TidyStepper', () {
    testWidgets('uses the given labels for the buttons', (tester) async {
      await tester.pumpWidget(
        _host(
          TidyStepper(
            value: 2,
            min: 1,
            max: 6,
            onChanged: (_) {},
            decreaseLabel: 'Fewer',
            increaseLabel: 'More',
          ),
        ),
      );
      expect(find.bySemanticsLabel('Fewer'), findsOneWidget);
      expect(find.bySemanticsLabel('More'), findsOneWidget);
    });
  });

  group('Skeleton and ErrorState', () {
    testWidgets('skeleton list builds and announces loading', (tester) async {
      await tester.pumpWidget(
        _host(const SkeletonList(count: 2, semanticLabel: 'Loading list')),
      );
      expect(find.byType(SkeletonBox), findsNWidgets(2));
      expect(find.bySemanticsLabel('Loading list'), findsOneWidget);
    });

    testWidgets('ErrorState shows retry only with a handler', (tester) async {
      var retried = 0;
      await tester.pumpWidget(
        _host(
          ErrorState(
            title: 'Oops',
            message: 'No connection',
            retryLabel: 'Try again',
            onRetry: () => retried++,
          ),
        ),
      );
      await tester.tap(find.text('Try again'));
      expect(retried, 1);

      await tester.pumpWidget(
        _host(const ErrorState(title: 'Oops', message: 'No connection')),
      );
      expect(find.text('Try again'), findsNothing);
    });

    testWidgets('ErrorBanner shows the message', (tester) async {
      await tester.pumpWidget(_host(const ErrorBanner(message: 'Nope')));
      expect(find.text('Nope'), findsOneWidget);
    });
  });

  group('Countdown', () {
    testWidgets('counts from the injected clock and never below zero', (
      tester,
    ) async {
      var now = DateTime.utc(2026, 12, 3, 10);
      final until = DateTime.utc(2026, 12, 3, 10, 1);
      await tester.pumpWidget(
        _host(
          Countdown(
            until: until,
            now: () => now,
            builder: (_, left) => Text(TidyFormat.countdown(left)),
          ),
        ),
      );
      expect(find.text('1:00'), findsOneWidget);
      now = now.add(const Duration(seconds: 70));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('0:00'), findsOneWidget);
    });
  });

  group('TidyFormat', () {
    test('money', () {
      expect(TidyFormat.pounds(6800), '£68.00');
      expect(TidyFormat.poundsShort(9650), '£96');
      expect(TidyFormat.payout(8400), '£84');
      expect(TidyFormat.payout(8450), '£84.50');
    });

    test('hours', () {
      expect(TidyFormat.hoursValue(120), '2');
      expect(TidyFormat.hoursValue(150), '2.5');
      expect(TidyFormat.hours(1290), '21.5');
      expect(TidyFormat.hoursRange(120), '2–3');
      expect(TidyFormat.hoursRange(240), '4–6');
      expect(TidyFormat.hoursRange(300), '5–8');
      expect(TidyFormat.perHour(48600, 1290), 2260);
      expect(TidyFormat.perHour(100, 0), 0);
      expect(TidyFormat.countdown(const Duration(seconds: 125)), '2:05');
    });

    test('countdown never goes below zero', () {
      expect(TidyFormat.countdown(const Duration(seconds: -3)), '0:00');
      expect(TidyFormat.countdown(const Duration(seconds: 42)), '0:42');
    });

    test('pounds to pence works on digits', () {
      expect(TidyFormat.poundsToPence('19.99'), 1999);
      expect(TidyFormat.poundsToPence('£1,250.00'), 125000);
      expect(TidyFormat.poundsToPence('68.5'), 6850);
      expect(TidyFormat.poundsToPence('-1'), isNull);
      expect(TidyFormat.poundsToPence('1.234'), isNull);
      expect(TidyFormat.penceToPounds(6800), '68.00');
      expect(TidyFormat.penceToPounds(5), '0.05');
    });
  });

  test('the cleaner tones are design tokens now', () {
    expect(TidyColors.mint, const Color(0xFF8FD9B6));
  });
}
