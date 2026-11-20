import 'package:tidy_admin/features/bookings/domain/bookings_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class ApiBookingsRepository implements BookingsRepository {
  ApiBookingsRepository({required this.admin, required this.bookings});

  final AdminApi admin;
  final BookingApi bookings;

  @override
  Future<AdminStats> stats() => admin.statsToday();

  @override
  Future<AdminBookingPage> list({
    BookingStatus? status,
    String? query,
    String? cursor,
  }) => admin.bookings(status: status, query: query, cursor: cursor);

  // The admin may read any booking through the shared endpoint.
  @override
  Future<BookingDetails> details(String id) => bookings.get(id);

  @override
  Future<Booking> reassign(String id, String cleanerId) =>
      admin.patchBooking(id, AdminBookingPatch(cleanerId: cleanerId));

  @override
  Future<Booking> cancel(String id) => admin.patchBooking(
    id,
    const AdminBookingPatch(status: BookingStatus.cancelled),
  );
}
