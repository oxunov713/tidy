import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tidy_core/src/models/address.dart';
import 'package:tidy_core/src/models/catalog.dart';
import 'package:tidy_core/src/models/enums.dart';
import 'package:tidy_core/src/models/user.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
abstract class BookingEvent with _$BookingEvent {
  const factory BookingEvent({
    required BookingStatus status,
    required DateTime at,
  }) = _BookingEvent;

  factory BookingEvent.fromJson(Map<String, dynamic> json) =>
      _$BookingEventFromJson(json);
}

/// Last known cleaner position for a booking.
@freezed
abstract class CleanerLocation with _$CleanerLocation {
  const factory CleanerLocation({
    required double lat,
    required double lng,
    int? etaMinutes,
    DateTime? at,
  }) = _CleanerLocation;

  factory CleanerLocation.fromJson(Map<String, dynamic> json) =>
      _$CleanerLocationFromJson(json);
}

@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required String id,
    required BookingStatus status,
    required DateTime start,

    /// Human friendly reference, e.g. `TD-1042`.
    @Default('') String code,
    @Default('') String serviceId,
    @Default('') String serviceTitle,
    @Default(1) int bedrooms,
    @Default(1) int bathrooms,
    @Default(Frequency.once) Frequency frequency,
    DateTime? end,
    @Default(0) int minutes,
    @Default(0) int subtotal,
    @Default(0) int discount,
    @Default(0) int total,
    @Default(<Extra>[]) List<Extra> extras,
    Address? address,
    Cleaner? cleaner,
    ClientSummary? client,
    CleanerLocation? cleanerLocation,
    @Default(<BookingEvent>[]) List<BookingEvent> events,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

/// Cursor-paginated list used by `GET /bookings` and `GET /admin/bookings`.
@freezed
abstract class BookingPage with _$BookingPage {
  const factory BookingPage({
    @Default(<Booking>[]) List<Booking> items,

    /// Null on the last page.
    String? nextCursor,
  }) = _BookingPage;

  factory BookingPage.fromJson(Map<String, dynamic> json) =>
      _$BookingPageFromJson(json);
}

/// Body of `POST /bookings`: the quote fields plus where and when.
@freezed
abstract class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    required String serviceId,
    required int bedrooms,
    required int bathrooms,
    required String addressId,
    required DateTime start,
    @Default(<String>[]) List<String> extraIds,
    @Default(Frequency.once) Frequency frequency,
    String? cleanerId,
  }) = _CreateBookingRequest;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);
}

@freezed
abstract class PaymentIntentInfo with _$PaymentIntentInfo {
  const factory PaymentIntentInfo({
    /// Stripe client secret; the mock provider returns a placeholder.
    required String clientSecret,
  }) = _PaymentIntentInfo;

  factory PaymentIntentInfo.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentInfoFromJson(json);
}

/// Response of `POST /bookings`.
@freezed
abstract class BookingCreated with _$BookingCreated {
  const factory BookingCreated({
    required Booking booking,
    required PaymentIntentInfo payment,
  }) = _BookingCreated;

  factory BookingCreated.fromJson(Map<String, dynamic> json) =>
      _$BookingCreatedFromJson(json);
}

/// Body of `POST /bookings/{id}/review`.
@freezed
abstract class ReviewRequest with _$ReviewRequest {
  const factory ReviewRequest({
    /// 1 to 5.
    required int rating,
    @Default(<String>[]) List<String> tags,
    @Default('') String comment,

    /// Tip in pence.
    @Default(0) int tip,
  }) = _ReviewRequest;

  factory ReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewRequestFromJson(json);
}

/// Body of `PATCH /admin/bookings/{id}`: reassign, or cancel with
/// `status: cancelled`.
@freezed
abstract class AdminBookingPatch with _$AdminBookingPatch {
  const factory AdminBookingPatch({
    String? cleanerId,
    BookingStatus? status,
  }) = _AdminBookingPatch;

  factory AdminBookingPatch.fromJson(Map<String, dynamic> json) =>
      _$AdminBookingPatchFromJson(json);
}
