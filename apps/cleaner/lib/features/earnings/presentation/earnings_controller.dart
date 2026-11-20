import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/earnings/data/api_earnings_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'earnings_controller.g.dart';

/// Earnings for one period. Kept alive so the Jobs header and the Earnings
/// tab share one request; `ref.invalidate` it to reload.
@Riverpod(keepAlive: true)
Future<Earnings> earnings(Ref ref, EarningsPeriod period) {
  ref.watch(currentUserIdProvider);
  return ref.read(earningsRepositoryProvider).earnings(period);
}

/// Week or month, chosen with the toggle on the Earnings screen.
@riverpod
class SelectedPeriod extends _$SelectedPeriod {
  @override
  EarningsPeriod build() => EarningsPeriod.week;

  // A setter cannot be called through `.notifier`.
  // ignore: use_setters_to_change_properties
  void select(EarningsPeriod period) => state = period;
}
