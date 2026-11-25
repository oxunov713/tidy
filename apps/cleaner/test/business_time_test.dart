import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tidy_cleaner/features/earnings/presentation/earnings_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/day_stats.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fixtures.dart' as fx;
import 'support/harness.dart';

void main() {
  setUpAll(initializeDateFormatting);
  tearDown(BusinessTime.reset);

  Future<DayStats> statsAt(DateTime now) async {
    final h = Harness(clock: () => now);
    h.jobsRepo.jobs_ = [
      // 22:00 UTC on the 3rd: 03:00 on the 4th in Tashkent.
      fx.job(id: 'late', start: DateTime.utc(2026, 12, 3, 22)),
      // 10:00 UTC on the 3rd: the 3rd everywhere.
      fx.job(id: 'noon', start: DateTime.utc(2026, 12, 3, 10)),
    ];
    final container = await h.container();
    addTearDown(container.dispose);
    await container.read(jobsControllerProvider.future);
    await container.read(earningsProvider(EarningsPeriod.week).future);
    return container.read(dayStatsProvider);
  }

  test('"today" follows the business zone, not the phone zone', () async {
    // 20:30 UTC on 3 December: still the 3rd in London, the 4th in Tashkent.
    final now = DateTime.utc(2026, 12, 3, 20, 30);

    final london = await statsAt(now);
    expect(london.total, 2);
    // The earnings fixture has 9600 on the 3rd and nothing on the 4th.
    expect(london.earned, 9600);

    BusinessTime.useZone('Asia/Tashkent');
    final tashkent = await statsAt(now);
    expect(tashkent.total, 1);
    expect(tashkent.earned, 0);
  });

  test('a visit after local midnight belongs to the next business day', () {
    BusinessTime.useZone('Asia/Tashkent');
    final now = DateTime.utc(2026, 12, 3, 20, 30);
    expect(
      BusinessTime.isOnDay(
        DateTime.utc(2026, 12, 3, 22),
        BusinessTime.today(now),
      ),
      isTrue,
    );
    expect(
      BusinessTime.isOnDay(
        DateTime.utc(2026, 12, 4, 20),
        BusinessTime.today(now),
      ),
      isFalse,
    );
  });
}
