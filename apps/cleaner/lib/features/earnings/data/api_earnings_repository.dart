import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/earnings/domain/earnings_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'api_earnings_repository.g.dart';

class ApiEarningsRepository implements EarningsRepository {
  const ApiEarningsRepository(this._api);

  final CleanerApi _api;

  @override
  Future<Earnings> earnings(EarningsPeriod period) =>
      _api.earnings(period: period);
}

@Riverpod(keepAlive: true)
EarningsRepository earningsRepository(Ref ref) =>
    ApiEarningsRepository(ref.watch(cleanerApiProvider));
