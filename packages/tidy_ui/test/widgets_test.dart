import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('TidyButton', () {
    testWidgets('calls onPressed when tapped', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(TidyButton(label: 'Book', onPressed: () => taps++)),
      );
      await tester.tap(find.text('Book'));
      expect(taps, 1);
    });

    testWidgets('ignores taps and shows a spinner while loading', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          TidyButton(label: 'Book', isLoading: true, onPressed: () => taps++),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(FilledButton), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('is disabled without a callback', (tester) async {
      await tester.pumpWidget(
        _host(const TidyButton(label: 'Book', onPressed: null)),
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
    });
  });

  group('TidyChip', () {
    testWidgets('reports the toggled value', (tester) async {
      bool? received;
      await tester.pumpWidget(
        _host(
          TidyChip(
            label: 'Oven',
            selected: false,
            onSelected: (v) => received = v,
          ),
        ),
      );
      await tester.tap(find.text('Oven'));
      expect(received, isTrue);
    });

    testWidgets('selected chip reports false when tapped', (tester) async {
      bool? received;
      await tester.pumpWidget(
        _host(
          TidyChip(
            label: 'Oven',
            selected: true,
            onSelected: (v) => received = v,
          ),
        ),
      );
      await tester.tap(find.text('Oven'));
      expect(received, isFalse);
    });
  });

  group('TidyStepper', () {
    testWidgets('increments and decrements within bounds', (tester) async {
      var value = 1;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _host(
            TidyStepper(
              value: value,
              min: 1,
              max: 2,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      );

      // At the minimum the decrease button is disabled.
      await tester.tap(find.byIcon(Icons.remove), warnIfMissed: false);
      await tester.pump();
      expect(value, 1);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(value, 2);
      expect(find.text('2'), findsOneWidget);

      // At the maximum the increase button is disabled.
      await tester.tap(find.byIcon(Icons.add), warnIfMissed: false);
      await tester.pump();
      expect(value, 2);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(value, 1);
    });
  });

  group('PriceText', () {
    test('formats pence as pounds', () {
      expect(PriceText.format(6800), '£68.00');
      expect(PriceText.format(5), '£0.05');
      expect(PriceText.format(0), '£0.00');
      expect(PriceText.format(123456), '£1,234.56');
      expect(PriceText.format(-1200), '-£12.00');
      expect(PriceText.format(500, signed: true), '+£5.00');
    });

    testWidgets('renders the formatted amount', (tester) async {
      await tester.pumpWidget(_host(const PriceText(6800)));
      expect(find.text('£68.00'), findsOneWidget);
    });
  });

  group('Avatar', () {
    test('builds initials', () {
      expect(Avatar.initialsOf('Sarah Jones'), 'SJ');
      expect(Avatar.initialsOf('sarah'), 'S');
      expect(Avatar.initialsOf('  mary  ann   lee '), 'ML');
      expect(Avatar.initialsOf(''), '?');
    });

    testWidgets('shows initials without an image', (tester) async {
      await tester.pumpWidget(_host(const Avatar(name: 'Sarah Jones')));
      expect(find.text('SJ'), findsOneWidget);
    });
  });

  group('StatusBadge', () {
    test('maps wire names and falls back for unknown values', () {
      expect(TidyStatus.fromWire('on_the_way'), TidyStatus.onTheWay);
      expect(TidyStatus.fromWire('something_new'), TidyStatus.pending);
    });

    testWidgets('renders a label for every status', (tester) async {
      for (final status in TidyStatus.values) {
        await tester.pumpWidget(_host(StatusBadge(status: status)));
        expect(find.text(status.label), findsOneWidget);
      }
    });
  });

  testWidgets('BottomNavBar reports the tapped index', (tester) async {
    int? tapped;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
            onTap: (i) => tapped = i,
            items: const [
              TidyNavItem(label: 'Home', icon: Icons.home_outlined),
              TidyNavItem(label: 'Jobs', icon: Icons.list),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Jobs'));
    expect(tapped, 1);
  });

  testWidgets('EmptyState shows its action', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      _host(
        EmptyState(
          title: 'No bookings',
          message: 'Book your first clean.',
          actionLabel: 'Book now',
          onAction: () => pressed = true,
        ),
      ),
    );
    await tester.tap(find.text('Book now'));
    expect(pressed, isTrue);
  });
}
