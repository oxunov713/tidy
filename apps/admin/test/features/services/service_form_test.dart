import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_admin/features/services/presentation/service_form.dart';
import 'package:tidy_core/tidy_core.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(setUpFonts);

  ServiceUpdate? submitted;

  Future<void> pumpForm(WidgetTester tester, AdminService s) async {
    submitted = null;
    await pumpApp(
      tester,
      SingleChildScrollView(
        child: ServiceForm(service: s, onSubmit: (u) => submitted = u),
      ),
    );
  }

  Future<void> type(WidgetTester tester, String key, String text) async {
    await tester.enterText(find.byKey(Key(key)), text);
  }

  Future<void> save(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(const Key('service-save')));
    await tester.tap(find.byKey(const Key('service-save')));
    await tester.pumpAndSettle();
  }

  testWidgets('fills the fields in pounds from the pence the API sends', (
    tester,
  ) async {
    await pumpForm(tester, service('s1', 'Standard clean'));
    expect(find.text('45.00'), findsOneWidget);
    expect(find.text('15.00'), findsOneWidget);
    expect(find.text('10.00'), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
  });

  testWidgets('converts pounds to whole pence when saving', (tester) async {
    await pumpForm(tester, service('s1', 'Standard clean'));

    await type(tester, 'service-base-price', '68.50');
    await type(tester, 'service-per-bedroom', '19.99');
    await type(tester, 'service-per-bathroom', '£12');
    await type(tester, 'service-base-minutes', '150');
    await type(tester, 'service-room-minutes', '40');
    await save(tester);

    final update = submitted!;
    expect(update.basePrice, 6850);
    expect(update.perBedroom, 1999);
    expect(update.perBathroom, 1200);
    expect(update.baseMinutes, 150);
    expect(update.minutesPerRoom, 40);
    expect(update.title, 'Standard clean');
  });

  testWidgets('always sends is_active, keeping the current value', (
    tester,
  ) async {
    await pumpForm(tester, service('s2', 'Office', isActive: false));
    await save(tester);
    expect(submitted!.isActive, isFalse);
    expect(submitted!.toJson()['is_active'], isFalse);

    await tester.tap(find.byKey(const Key('service-active')));
    await save(tester);
    expect(submitted!.isActive, isTrue);
    expect(submitted!.toJson()['is_active'], isTrue);
  });

  testWidgets('rejects prices that are not valid pounds', (tester) async {
    await pumpForm(tester, service('s1', 'Standard clean'));

    await type(tester, 'service-base-price', '12.345');
    await type(tester, 'service-per-bedroom', 'abc');
    await save(tester);

    expect(submitted, isNull);
    expect(find.textContaining('Enter an amount in pounds'), findsNWidgets(2));
  });

  testWidgets('the base price must be above zero and below the cap', (
    tester,
  ) async {
    await pumpForm(tester, service('s1', 'Standard clean'));

    await type(tester, 'service-base-price', '0');
    await save(tester);
    expect(find.text('The price must be more than £0.'), findsOneWidget);

    await type(tester, 'service-base-price', '10000.01');
    await save(tester);
    expect(find.text('The most you can enter is £10,000.'), findsOneWidget);
    expect(submitted, isNull);

    // A per-room price may be zero.
    await type(tester, 'service-base-price', '60');
    await type(tester, 'service-per-bedroom', '0');
    await save(tester);
    expect(submitted!.perBedroom, 0);
  });

  testWidgets('validates the name and the minutes', (tester) async {
    await pumpForm(tester, service('s1', 'Standard clean'));

    await type(tester, 'service-title', '   ');
    await type(tester, 'service-base-minutes', '0');
    await type(tester, 'service-room-minutes', '481');
    await save(tester);

    expect(submitted, isNull);
    expect(find.text('Enter a name of up to 80 characters.'), findsOneWidget);
    expect(find.text('Enter whole minutes from 1 to 1440.'), findsOneWidget);
    expect(find.text('Enter whole minutes from 0 to 480.'), findsOneWidget);
  });

  testWidgets('shows server field errors next to the fields', (tester) async {
    await pumpApp(
      tester,
      SingleChildScrollView(
        child: ServiceForm(
          service: service('s1', 'Standard clean'),
          fieldErrors: const {'base_price': 'must be positive'},
          onSubmit: (_) {},
        ),
      ),
    );
    expect(find.text('must be positive'), findsOneWidget);
  });
}
