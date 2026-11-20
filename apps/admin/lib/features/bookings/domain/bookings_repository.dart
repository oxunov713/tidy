import 'package:tidy_core/tidy_core.dart';

abstract interface class BookingsRepository {
  Future<AdminStats> stats();

  Future<AdminBookingPage> list({
    BookingStatus? status,
    String? query,
    String? cursor,
  });

  /// Booking with address, cleaner and the events timeline.
  Future<BookingDetails> details(String id);

  Future<Booking> reassign(String id, String cleanerId);

  Future<Booking> cancel(String id);
}
