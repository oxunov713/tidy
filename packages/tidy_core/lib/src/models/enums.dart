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

/// Filter for `GET /bookings`.
enum BookingScope { upcoming, past }

/// Period for `GET /cleaner/earnings`.
enum EarningsPeriod { week, month }
