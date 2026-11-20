import 'package:tidy_core/tidy_core.dart';

abstract interface class JobsRepository {
  /// The schedule; without a range the server shows yesterday to two weeks
  /// ahead.
  Future<List<Job>> jobs({DateTime? from, DateTime? to});

  /// Throws `InvalidTransitionException` for steps the booking cannot take.
  Future<Booking> setStatus(String bookingId, BookingStatus status);
}

abstract interface class PresenceRepository {
  Future<void> setOnline({required bool online, GeoPoint? at});
}
