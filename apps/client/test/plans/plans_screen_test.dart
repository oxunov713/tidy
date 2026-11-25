import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/plans/presentation/plans_screen.dart';
import 'package:tidy_client/features/profile/presentation/profile_screen.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';
import '../helpers/viewport.dart';

Plan _plan(String id, {Frequency frequency = Frequency.weekly}) => Plan(
  id: id,
  frequency: frequency,
  nextRunOn: DateTime(2026, 12, 10),
  serviceTitle: 'Standard clean',
  startTime: '10:00',
  addressId: 'addr-1',
);

void main() {
  setUpAll(initializeDateFormatting);

  testWidgets('lists the recurring cleans with their next visit', (
    tester,
  ) async {
    usePhoneScreen(tester);
    final repo = FakeBookingRepository()
      ..planList = [_plan('p1'), _plan('p2', frequency: Frequency.fortnightly)];
    await pumpScreen(tester, const PlansScreen(), Fakes(bookings: repo));
    await tester.pumpAndSettle();

    expect(find.text('Manage recurring cleans'), findsOneWidget);
    expect(find.text('Standard clean'), findsNWidgets(2));
    expect(find.text('Next visit Thu 10 Dec at 10:00'), findsNWidgets(2));
    expect(find.text('Stop series'), findsNWidgets(2));
  });

  testWidgets('stopping a series asks first, then ends it and refreshes', (
    tester,
  ) async {
    usePhoneScreen(tester);
    final repo = FakeBookingRepository()..planList = [_plan('p1'), _plan('p2')];
    await pumpScreen(tester, const PlansScreen(), Fakes(bookings: repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('stopSeries-p1')));
    await tester.pumpAndSettle();
    expect(find.text('Stop this series?'), findsOneWidget);
    expect(repo.endedPlans, isEmpty);

    await tester.tap(find.byKey(const Key('confirmStopSeries')));
    await tester.pumpAndSettle();

    expect(repo.endedPlans, ['p1']);
    expect(find.byKey(const Key('stopSeries-p1')), findsNothing);
    expect(find.byKey(const Key('stopSeries-p2')), findsOneWidget);
    expect(find.text('The series has ended.'), findsOneWidget);
  });

  testWidgets('declining the confirmation keeps the series', (tester) async {
    usePhoneScreen(tester);
    final repo = FakeBookingRepository()..planList = [_plan('p1')];
    await pumpScreen(tester, const PlansScreen(), Fakes(bookings: repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('stopSeries-p1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(repo.endedPlans, isEmpty);
    expect(find.byKey(const Key('stopSeries-p1')), findsOneWidget);
  });

  testWidgets('no plans shows the empty state', (tester) async {
    usePhoneScreen(tester);
    await pumpScreen(tester, const PlansScreen(), Fakes());
    await tester.pumpAndSettle();
    expect(find.text('No recurring cleans'), findsOneWidget);
  });

  testWidgets('Profile links to the screen', (tester) async {
    usePhoneScreen(tester);
    await pumpScreen(
      tester,
      const ProfileScreen(),
      Fakes(),
      extraRoutes: ['/plans'],
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manage recurring cleans'));
    await tester.pumpAndSettle();
    expect(find.text('page:/plans'), findsOneWidget);
  });
}
