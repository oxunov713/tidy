import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/models/models.dart';

/// Admin panel endpoints.
class AdminApi {
  AdminApi(this._http);

  final ApiTransport _http;

  Future<AdminStats> statsToday() async =>
      AdminStats.fromJson(await _http.getObject('/admin/stats/today'));

  /// [query] searches the booking table (`q`). Pass the previous page's
  /// `nextCursor` as [cursor]; [limit] is 20 by default, 50 at most.
  Future<AdminBookingPage> bookings({
    BookingStatus? status,
    String? query,
    String? cursor,
    int? limit,
  }) async {
    final json = await _http.getObject(
      '/admin/bookings',
      query: {
        if (status != null) 'status': status.wireName,
        if (query != null && query.isNotEmpty) 'q': query,
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        'limit': ?limit,
      },
    );
    return AdminBookingPage.fromJson(json);
  }

  /// Reassigns the cleaner or cancels (`status: cancelled`); returns the
  /// updated booking.
  Future<Booking> patchBooking(String id, AdminBookingPatch patch) async =>
      Booking.fromJson(
        await _http.patchObject('/admin/bookings/$id', body: patch.toJson()),
      );

  /// Every cleaner as a [User] with its `cleaner` profile filled in.
  Future<List<User>> cleaners({CleanerStatus? status}) async {
    final list = await _http.getList(
      '/admin/cleaners',
      query: {if (status != null) 'status': status.name},
    );
    return list.map(User.fromJson).toList();
  }

  Future<void> approveCleaner(String id) =>
      _http.postVoid('/admin/cleaners/$id/approve');

  Future<void> suspendCleaner(String id) =>
      _http.postVoid('/admin/cleaners/$id/suspend');

  /// Every service with all price fields, inactive ones too.
  Future<List<AdminService>> services() async {
    final list = await _http.getList('/admin/services');
    return list.map(AdminService.fromJson).toList();
  }

  Future<AdminService> updateService(String id, ServiceUpdate update) async =>
      AdminService.fromJson(
        await _http.putObject('/admin/services/$id', body: update.toJson()),
      );
}
