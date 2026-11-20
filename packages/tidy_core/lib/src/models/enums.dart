import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  @JsonValue('client')
  client,
  @JsonValue('cleaner')
  cleaner,
  @JsonValue('admin')
  admin,
}

enum CleanerStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('suspended')
  suspended,
}

enum BookingStatus {
  @JsonValue('pending')
  pending('pending'),
  @JsonValue('confirmed')
  confirmed('confirmed'),
  @JsonValue('assigned')
  assigned('assigned'),
  @JsonValue('on_the_way')
  onTheWay('on_the_way'),
  @JsonValue('in_progress')
  inProgress('in_progress'),
  @JsonValue('completed')
  completed('completed'),
  @JsonValue('cancelled')
  cancelled('cancelled');

  const BookingStatus(this.wireName);

  /// Value used on the wire; also what `StatusBadge.fromWire` in `tidy_ui` takes.
  final String wireName;

  /// Statuses a cleaner may set through `POST /cleaner/jobs/{id}/status`.
  static const List<BookingStatus> cleanerTransitions = [
    onTheWay,
    inProgress,
    completed,
  ];

  bool get isActive => this != completed && this != cancelled;

  /// The server only lets an admin reassign a booking in these statuses
  /// (`409 invalid_transition` otherwise).
  bool get canReassign => this == confirmed || this == assigned;

  /// Statuses an admin or the client may cancel from. Once the cleaner is on
  /// the way the visit can no longer be cancelled.
  bool get canCancel => this == pending || canReassign;
}

enum Frequency {
  @JsonValue('once')
  once,
  @JsonValue('weekly')
  weekly,
  @JsonValue('fortnightly')
  fortnightly,
}

enum DevicePlatform {
  @JsonValue('android')
  android,
  @JsonValue('ios')
  ios,
  @JsonValue('web')
  web,
}

/// What `POST /bookings/{id}/cancel` ends: this visit or the whole recurring
/// series.
enum CancelScope { visit, series }

/// What the client has to do with the `client_secret` of a new booking.
enum PaymentKind {
  /// Authorise the price now (a manual-capture PaymentIntent).
  @JsonValue('payment')
  payment,

  /// Only save the card; it is charged 48 hours before the visit.
  @JsonValue('setup')
  setup,
}

/// Filter for `GET /bookings`.
enum BookingScope { upcoming, past }

/// Period for `GET /cleaner/earnings`.
enum EarningsPeriod { week, month }
