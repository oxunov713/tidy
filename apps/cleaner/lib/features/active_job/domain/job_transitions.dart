import 'package:tidy_core/tidy_core.dart';

/// How early before the start a cleaner may set `on_the_way` (the server
/// enforces it, the UI explains it).
const earliestDeparture = Duration(hours: 3);

/// The one step a cleaner can take from [status], or null when there is none.
BookingStatus? nextStatus(BookingStatus status) => switch (status) {
  BookingStatus.assigned => BookingStatus.onTheWay,
  BookingStatus.onTheWay => BookingStatus.inProgress,
  BookingStatus.inProgress => BookingStatus.completed,
  _ => null,
};

/// When the "I am on my way" button starts to work for a job.
DateTime earliestDepartureTime(Booking booking) =>
    booking.start.subtract(earliestDeparture);

/// Position of [status] on the four-step progress list. A finished job has
/// passed every step.
int progressStep(BookingStatus status) => switch (status) {
  BookingStatus.assigned => 0,
  BookingStatus.onTheWay => 1,
  BookingStatus.inProgress => 2,
  BookingStatus.completed => 4,
  _ => 0,
};
