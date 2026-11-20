import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tidy_core/src/models/booking.dart';

part 'cleaner_work.freezed.dart';
part 'cleaner_work.g.dart';

/// A job offered to a cleaner. Valid until [expiresAt] (60 seconds).
@freezed
abstract class Offer with _$Offer {
  const factory Offer({
    required Booking booking,
    required DateTime expiresAt,
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
    /// `yyyy-MM-dd`.
    required String date,

    /// Pence.
    required int amount,
  }) = _EarningsDay;

  factory EarningsDay.fromJson(Map<String, dynamic> json) =>
      _$EarningsDayFromJson(json);
}

@freezed
abstract class EarningsJob with _$EarningsJob {
  const factory EarningsJob({
    required String bookingId,
    required int amount,
    @Default('') String code,
    @Default('') String serviceTitle,
    DateTime? completedAt,
  }) = _EarningsJob;

  factory EarningsJob.fromJson(Map<String, dynamic> json) =>
      _$EarningsJobFromJson(json);
}

/// Response of `GET /cleaner/earnings`. Amounts in pence.
@freezed
abstract class Earnings with _$Earnings {
  const factory Earnings({
    required int total,
    @Default(0) int jobs,
    @Default(0) int tips,
    @Default(<EarningsDay>[]) List<EarningsDay> days,
    @Default(<EarningsJob>[]) List<EarningsJob> recent,
  }) = _Earnings;

  factory Earnings.fromJson(Map<String, dynamic> json) =>
      _$EarningsFromJson(json);
}
