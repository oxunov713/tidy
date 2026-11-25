import 'package:tidy_core/tidy_core.dart';

/// Why the scheduler cancelled a booking on its own.
enum StuckCancellation {
  /// Pending for 30 minutes without payment.
  unpaid,

  /// Confirmed, but nobody took it by 2 hours before the start.
  noCleaner,
}

/// Tells a cancellation by the system apart from one by a person, using the
/// booking's history: events the system wrote have no `actorId`.
///
/// Returns null for bookings that are not cancelled and for cancellations a
/// client or an admin made. A booking that was never confirmed was cancelled
/// for lack of payment; one that was confirmed and has no cleaner was cancelled
/// for lack of a cleaner.
StuckCancellation? stuckCancellationOf(BookingDetails details) {
  final booking = details.booking;
  if (booking.status != BookingStatus.cancelled) return null;
  final cancelled = details.events
      .where((e) => e.status == BookingStatus.cancelled)
      .lastOrNull;
  if (cancelled == null || cancelled.actorId != null) return null;
  final wasConfirmed = details.events.any(
    (e) => e.status == BookingStatus.confirmed,
  );
  if (!wasConfirmed) return StuckCancellation.unpaid;
  return booking.cleanerId == null ? StuckCancellation.noCleaner : null;
}
