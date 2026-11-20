import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/jobs/domain/incoming_offer.dart';
import 'package:tidy_cleaner/features/jobs/domain/jobs_repository.dart';
import 'package:tidy_cleaner/features/jobs/domain/offers_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'cleaner_repositories.g.dart';

/// All three repositories sit on `CleanerApi`; they are separate interfaces
/// so each controller depends only on what it uses.
class ApiCleanerRepository
    implements OffersRepository, JobsRepository, PresenceRepository {
  const ApiCleanerRepository(this._api);

  final CleanerApi _api;

  @override
  Future<List<IncomingOffer>> open() async =>
      (await _api.offers()).map(IncomingOffer.fromApi).toList();

  @override
  Future<Booking> accept(String bookingId) => _api.acceptOffer(bookingId);

  @override
  Future<void> decline(String bookingId) => _api.declineOffer(bookingId);

  @override
  Future<List<Job>> jobs({DateTime? from, DateTime? to}) =>
      _api.jobs(from: from, to: to);

  @override
  Future<Booking> setStatus(String bookingId, BookingStatus status) =>
      _api.setJobStatus(bookingId, status);

  @override
  Future<void> setOnline({required bool online, GeoPoint? at}) =>
      _api.setOnline(online: online, lat: at?.lat, lng: at?.lng);
}

@Riverpod(keepAlive: true)
OffersRepository offersRepository(Ref ref) =>
    ApiCleanerRepository(ref.watch(cleanerApiProvider));

@Riverpod(keepAlive: true)
JobsRepository jobsRepository(Ref ref) =>
    ApiCleanerRepository(ref.watch(cleanerApiProvider));

@Riverpod(keepAlive: true)
PresenceRepository presenceRepository(Ref ref) =>
    ApiCleanerRepository(ref.watch(cleanerApiProvider));
