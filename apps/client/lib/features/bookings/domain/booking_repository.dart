import 'package:tidy_core/tidy_core.dart';

/// Everything a client does with bookings except chatting.
abstract interface class BookingRepository {
  Future<Quote> quote(QuoteRequest request);

  Future<SlotsResponse> slots({
    required String serviceId,
    required int bedrooms,
    required int bathrooms,
    required DateTime date,
    required String addressId,
    List<String> extraIds = const [],
    String? cleanerId,
  });

  /// Throws [SlotTakenException] when someone else got the time first.
  Future<BookingCreated> create(CreateBookingRequest request);

  Future<BookingPage> list({
    required BookingScope scope,
    String? cursor,
    int? limit,
  });

  Future<BookingDetails> details(String id);

  Future<Cancellation> cancel(String id);

  Future<Review> review(String id, ReviewRequest request);
}
