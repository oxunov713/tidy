import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/schedule/domain/availability.dart';
import 'package:tidy_core/tidy_core.dart';

part 'api_availability_repository.g.dart';

class ApiAvailabilityRepository implements AvailabilityRepository {
  const ApiAvailabilityRepository(this._api);

  final CleanerApi _api;

  @override
  Future<List<AvailabilityWindow>> load() => _api.availability();

  @override
  Future<List<AvailabilityWindow>> save(List<AvailabilityWindow> windows) =>
      _api.setAvailability(windows);
}

@Riverpod(keepAlive: true)
AvailabilityRepository availabilityRepository(Ref ref) =>
    ApiAvailabilityRepository(ref.watch(cleanerApiProvider));
