import 'package:tidy_core/src/models/enums.dart';

/// Translated names of the booking statuses; each app fills it from its ARB
/// files.
class StatusLabels {
  const StatusLabels({
    required this.pending,
    required this.confirmed,
    required this.assigned,
    required this.onTheWay,
    required this.inProgress,
    required this.completed,
    required this.cancelled,
  });

  final String pending;
  final String confirmed;
  final String assigned;
  final String onTheWay;
  final String inProgress;
  final String completed;
  final String cancelled;

  String of(BookingStatus status) => switch (status) {
    BookingStatus.pending => pending,
    BookingStatus.confirmed => confirmed,
    BookingStatus.assigned => assigned,
    BookingStatus.onTheWay => onTheWay,
    BookingStatus.inProgress => inProgress,
    BookingStatus.completed => completed,
    BookingStatus.cancelled => cancelled,
  };
}
