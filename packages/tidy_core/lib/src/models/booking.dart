// `includeIfNull` has to sit on the factory; freezed forwards it.
// ignore_for_file: invalid_annotation_target
// The wire format puts a booking and its extras on one level, so these
// cannot be plain freezed factories.
// ignore_for_file: prefer_constructors_over_static_methods
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tidy_core/src/models/address.dart';
import 'package:tidy_core/src/models/enums.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

/// UTC, RFC 3339. The API rejects times without a zone, and `toIso8601String`
/// leaves it out for local [DateTime]s.
String _utc(DateTime value) => value.toUtc().toIso8601String();

/// One step in a booking's history.
@freezed
abstract class BookingEvent with _$BookingEvent {
  const factory BookingEvent({
    required BookingStatus status,
    required DateTime at,

    /// Who did it; null when the system did (for example payment confirmed).
    String? actorId,
  }) = _BookingEvent;

  factory BookingEvent.fromJson(Map<String, dynamic> json) =>
      _$BookingEventFromJson(json);
}

/// Last position the cleaner shared for a booking.
@freezed
abstract class CleanerLocation with _$CleanerLocation {
  const factory CleanerLocation({
    required double lat,
    required double lng,
    required DateTime at,
  }) = _CleanerLocation;

  factory CleanerLocation.fromJson(Map<String, dynamic> json) =>
      _$CleanerLocationFromJson(json);
}

/// An extra on a booking, with the price it was booked at.
@freezed
abstract class BookingExtra with _$BookingExtra {
  const factory BookingExtra({
    /// The id of the extra in the catalogue.
    required String id,
    required String title,

    /// Pence.
    required int price,
  }) = _BookingExtra;

  factory BookingExtra.fromJson(Map<String, dynamic> json) =>
      _$BookingExtraFromJson(json);
}

/// A booking. Amounts are in pence. Anything a screen needs beyond this (the
/// address, the cleaner, history) is in [BookingDetails] or [Job].
@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required String id,

    /// Human friendly reference, e.g. `TD-1042`.
    required String code,
    required String clientId,
    required String serviceId,
    required String serviceTitle,
    required String addressId,
    required int bedrooms,
    required int bathrooms,
    required Frequency frequency,
    required DateTime start,
    required DateTime end,
    required BookingStatus status,
    required int subtotal,
    required int discount,
    required int total,

    /// What the cleaner earns, before tips.
    required int cleanerPayout,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Null until a cleaner accepts.
    String? cleanerId,

    /// Set when the client picked a cleaner by name.
    String? requestedCleanerId,

    /// Set for recurring bookings.
    String? planId,
    @Default(<BookingExtra>[]) List<BookingExtra> extras,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

/// The cleaner as a client sees them.
@freezed
abstract class CleanerCard with _$CleanerCard {
  const factory CleanerCard({
    required String id,
    required String fullName,
    required double rating,
    required int ratingCount,
    String? avatarUrl,
  }) = _CleanerCard;

  factory CleanerCard.fromJson(Map<String, dynamic> json) =>
      _$CleanerCardFromJson(json);
}

/// The client's review of a finished booking.
@freezed
abstract class Review with _$Review {
  const factory Review({
    required String bookingId,
    required String cleanerId,
    required int rating,
    required String comment,

    /// Pence.
    required int tip,
    required DateTime createdAt,
    @Default(<String>[]) List<String> tags,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

/// Response of `GET /bookings/{id}`: the booking fields with the extras the
/// detail screen needs. On the wire everything is on one level.
@freezed
abstract class BookingDetails with _$BookingDetails {
  const factory BookingDetails({
    required Booking booking,
    required Address address,
    CleanerCard? cleaner,
    CleanerLocation? lastLocation,
    @Default(<BookingEvent>[]) List<BookingEvent> events,
    Review? review,
  }) = _BookingDetails;

  const BookingDetails._();

  static BookingDetails fromJson(Map<String, dynamic> json) => BookingDetails(
    booking: Booking.fromJson(json),
    address: Address.fromJson(json['address']! as Map<String, dynamic>),
    cleaner: _object(json['cleaner'], CleanerCard.fromJson),
    lastLocation: _object(json['last_location'], CleanerLocation.fromJson),
    events: _list(json['events'], BookingEvent.fromJson),
    review: _object(json['review'], Review.fromJson),
  );
}

/// A booking in the cleaner's schedule (`GET /cleaner/jobs`), with the full
/// address and the client's name.
@freezed
abstract class Job with _$Job {
  const factory Job({
    required Booking booking,
    required Address address,
    required String clientName,
  }) = _Job;

  const Job._();

  static Job fromJson(Map<String, dynamic> json) => Job(
    booking: Booking.fromJson(json),
    address: Address.fromJson(json['address']! as Map<String, dynamic>),
    clientName: json['client_name']! as String,
  );
}

/// A row of the admin booking table: the booking with names filled in.
/// [cleanerName] is empty while nobody is assigned.
@freezed
abstract class AdminBooking with _$AdminBooking {
  const factory AdminBooking({
    required Booking booking,
    required String clientName,
    required String clientPhone,
    required String cleanerName,
  }) = _AdminBooking;

  const AdminBooking._();

  static AdminBooking fromJson(Map<String, dynamic> json) => AdminBooking(
    booking: Booking.fromJson(json),
    clientName: json['client_name']! as String,
    clientPhone: json['client_phone']! as String,
    cleanerName: json['cleaner_name']! as String,
  );
}

/// One page of `GET /bookings`. Ask for the next one with [nextCursor].
@freezed
abstract class BookingPage with _$BookingPage {
  const factory BookingPage({
    @Default(<Booking>[]) List<Booking> items,

    /// Empty on the last page.
    @Default('') String nextCursor,
  }) = _BookingPage;

  const BookingPage._();

  factory BookingPage.fromJson(Map<String, dynamic> json) =>
      _$BookingPageFromJson(json);

  bool get hasMore => nextCursor.isNotEmpty;
}

/// One page of `GET /admin/bookings`.
@freezed
abstract class AdminBookingPage with _$AdminBookingPage {
  const factory AdminBookingPage({
    @Default(<AdminBooking>[]) List<AdminBooking> items,

    /// Empty on the last page.
    @Default('') String nextCursor,
  }) = _AdminBookingPage;

  const AdminBookingPage._();

  static AdminBookingPage fromJson(Map<String, dynamic> json) =>
      AdminBookingPage(
        items: _list(json['items'], AdminBooking.fromJson),
        nextCursor: json['next_cursor'] as String? ?? '',
      );

  bool get hasMore => nextCursor.isNotEmpty;
}

/// Body of `POST /bookings`: the quote fields plus where and when.
@freezed
abstract class CreateBookingRequest with _$CreateBookingRequest {
  @JsonSerializable(includeIfNull: false)
  const factory CreateBookingRequest({
    required String serviceId,
    required int bedrooms,
    required int bathrooms,
    required String addressId,

    /// Sent as UTC.
    @JsonKey(toJson: _utc) required DateTime start,
    @Default(<String>[]) List<String> extraIds,
    @Default(Frequency.once) Frequency frequency,

    /// Ask for one cleaner ("book Sarah again").
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

/// Response of `POST /bookings/{id}/cancel`.
@freezed
abstract class Cancellation with _$Cancellation {
  const factory Cancellation({
    required Booking booking,

    /// False when the cancellation came too late and the price is charged.
    required bool refunded,
  }) = _Cancellation;

  factory Cancellation.fromJson(Map<String, dynamic> json) =>
      _$CancellationFromJson(json);
}

/// Body of `POST /bookings/{id}/review`.
@freezed
abstract class ReviewRequest with _$ReviewRequest {
  const factory ReviewRequest({
    /// 1 to 5.
    required int rating,
    @Default(<String>[]) List<String> tags,
    @Default('') String comment,

    /// Tip in pence, 0 to 10000.
    @Default(0) int tip,
  }) = _ReviewRequest;

  factory ReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewRequestFromJson(json);
}

/// Body of `PATCH /admin/bookings/{id}`: either reassign with [cleanerId] or
/// cancel with `status: cancelled`, not both.
@freezed
abstract class AdminBookingPatch with _$AdminBookingPatch {
  @JsonSerializable(includeIfNull: false)
  const factory AdminBookingPatch({
    String? cleanerId,
    BookingStatus? status,
  }) = _AdminBookingPatch;

  factory AdminBookingPatch.fromJson(Map<String, dynamic> json) =>
      _$AdminBookingPatchFromJson(json);
}

T? _object<T>(Object? json, T Function(Map<String, dynamic>) parse) =>
    json == null ? null : parse(json as Map<String, dynamic>);

List<T> _list<T>(Object? json, T Function(Map<String, dynamic>) parse) => [
  for (final item in (json as List<dynamic>?) ?? const <dynamic>[])
    parse(item as Map<String, dynamic>),
];
