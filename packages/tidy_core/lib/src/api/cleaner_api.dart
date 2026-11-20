import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/models/models.dart';

/// Endpoints for the cleaner app.
class CleanerApi {
  CleanerApi(this._http);

  final ApiTransport _http;

  /// Go online (with the current position) or offline.
  Future<void> setOnline({required bool online, double? lat, double? lng}) =>
      _http.postVoid(
        '/cleaner/online',
        body: {
          'online': online,
          'lat': ?lat,
          'lng': ?lng,
        },
      );

  Future<List<Offer>> offers() async {
    final list = await _http.getList('/cleaner/offers');
    return list.map(Offer.fromJson).toList();
  }

  /// Throws a `SlotTakenException` if the cleaner is busy at that time.
  Future<void> acceptOffer(String bookingId) =>
      _http.postVoid('/cleaner/offers/$bookingId/accept');

  Future<void> declineOffer(String bookingId) =>
      _http.postVoid('/cleaner/offers/$bookingId/decline');

  Future<List<Booking>> jobs({DateTime? from, DateTime? to}) async {
    final list = await _http.getList(
      '/cleaner/jobs',
      query: {
        if (from != null) 'from': from.toUtc().toIso8601String(),
        if (to != null) 'to': to.toUtc().toIso8601String(),
      },
    );
    return list.map(Booking.fromJson).toList();
  }

  /// [status] must be one of `BookingStatus.cleanerTransitions`.
  Future<void> setJobStatus(String bookingId, BookingStatus status) {
    assert(
      BookingStatus.cleanerTransitions.contains(status),
      'Cleaners can only set on_the_way, in_progress or completed',
    );
    return _http.postVoid(
      '/cleaner/jobs/$bookingId/status',
      body: {'status': status.wireName},
    );
  }

  Future<List<AvailabilityWindow>> availability() async {
    final list = await _http.getList('/cleaner/availability');
    return list.map(AvailabilityWindow.fromJson).toList();
  }

  Future<void> setAvailability(List<AvailabilityWindow> windows) =>
      _http.putVoid(
        '/cleaner/availability',
        body: windows.map((w) => w.toJson()).toList(),
      );

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
