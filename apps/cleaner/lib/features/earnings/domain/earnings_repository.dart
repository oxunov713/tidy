import 'package:tidy_core/tidy_core.dart';

abstract interface class EarningsRepository {
  Future<Earnings> earnings(EarningsPeriod period);
}
