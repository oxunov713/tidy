import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_cleaner/features/earnings/presentation/earnings_page.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fixtures.dart' as fx;
import 'support/harness.dart';
import 'support/pump_app.dart';

void main() {
  testWidgets('shows total, tiles, chart and recent jobs', (tester) async {
    final h = Harness();
    await pumpApp(tester, h, const EarningsPage());

    expect(find.text('This week'), findsOneWidget);
    expect(find.text('£486.00'), findsOneWidget);
    expect(find.text('8 jobs · 21.5 h'), findsOneWidget);
    expect(find.text('£32.00'), findsOneWidget);
    // 48600 pence over 21.5 hours.
    expect(find.text('£22.60'), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);

    expect(find.text('Deep clean · TD-1040'), findsOneWidget);
    // The list shows payout plus tip.
    expect(find.text('£63.00'), findsOneWidget);
    expect(find.text('Tue 1 Dec · tip £5'), findsOneWidget);
  });

  testWidgets('month toggle loads the month', (tester) async {
    final h = Harness();
    await pumpApp(tester, h, const EarningsPage());
    h.earningsRepo.result = fx.earnings(period: 'month', total: 190000);

    await tester.tap(find.byKey(const Key('periodMonth')));
    await settle(tester);

    expect(h.earningsRepo.requested, contains(EarningsPeriod.month));
    expect(find.text('This month'), findsOneWidget);
    expect(find.text('£1,900.00'), findsOneWidget);
  });

  testWidgets('empty period has a friendly message and no average', (
    tester,
  ) async {
    final h = Harness();
    h.earningsRepo.result = fx.earnings(
      total: 0,
      tips: 0,
      jobs: 0,
      minutes: 0,
      recent: const [],
    );
    await pumpApp(tester, h, const EarningsPage());

    expect(find.text('No finished jobs yet'), findsOneWidget);
    expect(find.text('–'), findsOneWidget);
  });
}
