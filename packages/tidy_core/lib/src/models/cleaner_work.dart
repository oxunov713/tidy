import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tidy_core/src/models/booking.dart';

part 'cleaner_work.freezed.dart';
part 'cleaner_work.g.dart';

/// An open offer from `GET /cleaner/offers`. Valid until [expiresAt] (60
/// seconds after it was sent). The street address is only shared once the job
/// is accepted, so the offer has just the area.
@freezed
abstract class Offer with _$Offer {
  const factory Offer({
    required Booking booking,
    required DateTime expiresAt,

    /// From the cleaner's last known position to the address.
    required double distanceKm,
    required String postcode,
    required String city,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}

/// One working window, e.g. Monday 08:00 to 17:00.
@freezed
abstract class AvailabilityWindow with _$AvailabilityWindow {
  const factory AvailabilityWindow({
    /// 0 = Monday.
    required int weekday,

    /// `HH:mm`.
    required String startTime,
    required String endTime,
  }) = _AvailabilityWindow;

  factory AvailabilityWindow.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityWindowFromJson(json);
}

@freezed
abstract class EarningsDay with _$EarningsDay {
  const factory EarningsDay({
    /// `yyyy-MM-dd`, local day of the service.
    required String date,

    /// Pence, tips included.
    required int amount,
  }) = _EarningsDay;

  factory EarningsDay.fromJson(Map<String, dynamic> json) =>
      _$EarningsDayFromJson(json);
}

/// A completed job in the earnings list.
@freezed
abstract class EarningsJob with _$EarningsJob {
  const factory EarningsJob({
    required String bookingId,
    required String code,
    required String serviceTitle,
    required DateTime start,
    required int minutes,

    /// Pence, without the tip.
    required int amount,

    /// Pence.
    required int tip,
  }) = _EarningsJob;

  factory EarningsJob.fromJson(Map<String, dynamic> json) =>
      _$EarningsJobFromJson(json);
}

/// Response of `GET /cleaner/earnings`. Amounts in pence.
@freezed
abstract class Earnings with _$Earnings {
  const factory Earnings({
    /// `week` or `month`.
    required String period,

    /// First and last day of the period, `yyyy-MM-dd`.
    required String from,
    required String to,

    /// Sum of the job payouts, tips not included.
    required int total,

    /// Tips from the same jobs.
    required int tips,
    required int jobs,

    /// Time spent on the completed jobs.
    required int minutes,

    /// One entry per day of the period.
    @Default(<EarningsDay>[]) List<EarningsDay> days,

    /// The latest completed jobs, newest first.
    @Default(<EarningsJob>[]) List<EarningsJob> recent,
  }) = _Earnings;

  factory Earnings.fromJson(Map<String, dynamic> json) =>
      _$EarningsFromJson(json);
}
