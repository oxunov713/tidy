import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/models/models.dart';

/// Endpoints for the cleaner app.
class CleanerApi {
  CleanerApi(this._http);

  final ApiTransport _http;

  /// Go online or offline. Going online needs the current position, and an
  /// approved profile (`403` otherwise).
  Future<void> setOnline({required bool online, double? lat, double? lng}) =>
      _http.postVoid(
        '/cleaner/online',
        body: {
          'online': online,
          'lat': ?lat,
          'lng': ?lng,
        },
      );

  /// Offers that are still open for this cleaner.
  Future<List<Offer>> offers() async {
    final list = await _http.getList('/cleaner/offers');
    return list.map(Offer.fromJson).toList();
  }

  /// Throws `SlotTakenException` if the cleaner is busy at that time and
  /// `OfferGoneException` if the offer expired or someone else took the job.
  Future<Booking> acceptOffer(String bookingId) async => Booking.fromJson(
    await _http.postObject('/cleaner/offers/$bookingId/accept'),
  );

  Future<void> declineOffer(String bookingId) =>
      _http.postVoid('/cleaner/offers/$bookingId/decline');

  /// The schedule. Without a range the server shows yesterday to two weeks
  /// ahead; a range can be at most 93 days.
  Future<List<Job>> jobs({DateTime? from, DateTime? to}) async {
    final list = await _http.getList(
      '/cleaner/jobs',
      query: {
        if (from != null) 'from': from.toUtc().toIso8601String(),
        if (to != null) 'to': to.toUtc().toIso8601String(),
      },
    );
    return list.map(Job.fromJson).toList();
  }

  /// [status] must be one of `BookingStatus.cleanerTransitions`. Throws
  /// `InvalidTransitionException` for a step the booking cannot take, which
  /// includes `on_the_way` earlier than 3 hours before the start.
  Future<Booking> setJobStatus(String bookingId, BookingStatus status) async {
    assert(
      BookingStatus.cleanerTransitions.contains(status),
      'Cleaners can only set on_the_way, in_progress or completed',
    );
    return Booking.fromJson(
      await _http.postObject(
        '/cleaner/jobs/$bookingId/status',
        body: {'status': status.wireName},
      ),
    );
  }

  Future<List<AvailabilityWindow>> availability() async {
    final list = await _http.getList('/cleaner/availability');
    return list.map(AvailabilityWindow.fromJson).toList();
  }

  /// Replaces the weekly hours; one window per weekday. Returns what was
  /// saved.
  Future<List<AvailabilityWindow>> setAvailability(
    List<AvailabilityWindow> windows,
  ) async {
    final list = await _http.putList(
      '/cleaner/availability',
      body: windows.map((w) => w.toJson()).toList(),
    );
    return list.map(AvailabilityWindow.fromJson).toList();
  }

  Future<Earnings> earnings({
    EarningsPeriod period = EarningsPeriod.week,
  }) async {
    final json = await _http.getObject(
      '/cleaner/earnings',
      query: {'period': period.name},
    );
    return Earnings.fromJson(json);
  }
}
