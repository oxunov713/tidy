import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/models/models.dart';

/// Client-side booking endpoints.
///
/// Calls that change state (`cancel`, `review`) return nothing; fetch the
/// booking again with [get] or wait for the `booking.status` WebSocket event.
class BookingApi {
  BookingApi(this._http);

  final ApiTransport _http;

  /// `POST /quotes`. Prices always come from the server.
  Future<Quote> quote(QuoteRequest request) async =>
      Quote.fromJson(await _http.postObject('/quotes', body: request.toJson()));

  /// `GET /slots`. [date] is only used for its year, month and day.
  ///
  /// `extra_ids` is sent comma-separated, e.g. `extra_ids=a,b`.
  Future<SlotsResponse> slots({
    required String serviceId,
    required int bedrooms,
    required int bathrooms,
    required DateTime date,
    required String addressId,
    List<String> extraIds = const [],
    String? cleanerId,
  }) async {
    final json = await _http.getObject(
      '/slots',
      query: {
        'service_id': serviceId,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        if (extraIds.isNotEmpty) 'extra_ids': extraIds.join(','),
        'date': formatDate(date),
        'address_id': addressId,
        'cleaner_id': ?cleanerId,
      },
    );
    return SlotsResponse.fromJson(json);
  }

  /// `POST /bookings`. Throws a `SlotTakenException` on a 409.
  Future<BookingCreated> create(CreateBookingRequest request) async {
    final json = await _http.postObject('/bookings', body: request.toJson());
    return BookingCreated.fromJson(json);
  }

  Future<BookingPage> list({
    BookingScope scope = BookingScope.upcoming,
    String? cursor,
  }) async {
    final json = await _http.getObject(
      '/bookings',
      query: {'scope': scope.name, 'cursor': ?cursor},
    );
    return BookingPage.fromJson(json);
  }

  Future<Booking> get(String id) async =>
      Booking.fromJson(await _http.getObject('/bookings/$id'));

  /// Free until 24 hours before the start.
  Future<void> cancel(String id) => _http.postVoid('/bookings/$id/cancel');

  Future<void> review(String id, ReviewRequest review) =>
      _http.postVoid('/bookings/$id/review', body: review.toJson());

  Future<List<Message>> messages(String id) async {
    final list = await _http.getList('/bookings/$id/messages');
    return list.map(Message.fromJson).toList();
  }

  Future<Message> sendMessage(String id, String body) async {
    final json = await _http.postObject(
      '/bookings/$id/messages',
      body: {'body': body},
    );
    return Message.fromJson(json);
  }

  /// `2026-12-03` for the given day.
  static String formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}-${two(date.month)}-${two(date.day)}';
  }
}
