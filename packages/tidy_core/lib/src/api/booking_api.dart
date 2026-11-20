import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/models/models.dart';

/// Client-side booking endpoints.
class BookingApi {
  BookingApi(this._http);

  final ApiTransport _http;

  /// `POST /quotes`. Prices always come from the server. Works without being
  /// signed in, so no token is sent.
  Future<Quote> quote(QuoteRequest request) async => Quote.fromJson(
    await _http.postObjectPublic('/quotes', body: request.toJson()),
  );

  /// `GET /slots`. [date] is only used for its year, month and day. Pass
  /// [cleanerId] to check one cleaner only ("book Sarah again").
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

  /// One page of the client's bookings, 20 by default (at most 50). Pass the
  /// previous page's `nextCursor` to get the next one.
  Future<BookingPage> list({
    BookingScope scope = BookingScope.upcoming,
    String? cursor,
    int? limit,
  }) async {
    final json = await _http.getObject(
      '/bookings',
      query: {
        'scope': scope.name,
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        'limit': ?limit,
      },
    );
    return BookingPage.fromJson(json);
  }

  /// Includes the address, the cleaner, the last location, the history and
  /// the review.
  Future<BookingDetails> get(String id) async =>
      BookingDetails.fromJson(await _http.getObject('/bookings/$id'));

  /// Free until 24 hours before the start; later the full price is charged
  /// (`refunded` is false).
  Future<Cancellation> cancel(String id) async =>
      Cancellation.fromJson(await _http.postObject('/bookings/$id/cancel'));

  /// Only after the booking is `completed`.
  Future<Review> review(String id, ReviewRequest review) async =>
      Review.fromJson(
        await _http.postObject('/bookings/$id/review', body: review.toJson()),
      );

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
