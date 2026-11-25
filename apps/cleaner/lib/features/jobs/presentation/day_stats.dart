import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/earnings/presentation/earnings_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_core/tidy_core.dart';

part 'day_stats.g.dart';

/// The three numbers on the Jobs header. Null means "not loaded yet".
class DayStats {
  const DayStats({this.earned, this.done, this.total});

  /// Pence earned today, tips included.
  final int? earned;
  final int? done;
  final int? total;
}

/// Today's earnings come from the week's `days`, the job counts from the
/// schedule.
@riverpod
DayStats dayStats(Ref ref) {
  final today = BusinessTime.today(ref.watch(clockProvider)());
  final earnings = ref.watch(earningsProvider(EarningsPeriod.week)).value;
  final jobs = ref.watch(jobsControllerProvider).value;

  int? earned;
  if (earnings != null) {
    final iso = TidyDates.isoDay(today);
    earned = earnings.days
        .where((d) => d.date == iso)
        .fold<int>(0, (sum, d) => sum + d.amount);
  }

  int? done;
  int? total;
  if (jobs != null) {
    final todays = jobs.where(
      (j) =>
          j.booking.status != BookingStatus.cancelled &&
          BusinessTime.isOnDay(j.booking.start, today),
    );
    total = todays.length;
    done = todays
        .where((j) => j.booking.status == BookingStatus.completed)
        .length;
  }
  return DayStats(earned: earned, done: done, total: total);
}
