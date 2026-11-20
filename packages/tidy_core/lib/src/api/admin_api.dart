import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/models/models.dart';

/// Admin panel endpoints.
class AdminApi {
  AdminApi(this._http);

  final ApiTransport _http;

  Future<AdminStats> statsToday() async =>
      AdminStats.fromJson(await _http.getObject('/admin/stats/today'));

  Future<BookingPage> bookings({
    BookingStatus? status,
    String? query,
    String? cursor,
  }) async {
    final json = await _http.getObject(
      '/admin/bookings',
      query: {
        if (status != null) 'status': status.wireName,
        if (query != null && query.isNotEmpty) 'q': query,
        'cursor': ?cursor,
      },
    );
    return BookingPage.fromJson(json);
  }

  /// Reassign a cleaner or cancel (`status: cancelled`).
  Future<void> patchBooking(String id, AdminBookingPatch patch) =>
      _http.patchVoid('/admin/bookings/$id', body: patch.toJson());

  Future<List<Cleaner>> cleaners({CleanerStatus? status}) async {
    final list = await _http.getList(
      '/admin/cleaners',
      query: {if (status != null) 'status': status.name},
    );
    return list.map(Cleaner.fromJson).toList();
  }

  Future<void> approveCleaner(String id) =>
      _http.postVoid('/admin/cleaners/$id/approve');

  Future<void> suspendCleaner(String id) =>
      _http.postVoid('/admin/cleaners/$id/suspend');

  Future<void> updateService(String id, ServiceUpdate update) =>
      _http.putVoid('/admin/services/$id', body: update.toJson());
}
