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

  /// [CancelScope.series] also ends the recurring plan of the booking.
  Future<Cancellation> cancel(
    String id, {
    CancelScope scope = CancelScope.visit,
  });

  /// A new payment to confirm for a booking that is still pending, for
  /// example after the saved card was declined. Always `kind: payment`.
  Future<PaymentIntentInfo> pay(String id);

  /// The client's active recurring cleans.
  Future<List<Plan>> plans();

  /// Ends a series; visits that have no cleaner yet are cancelled.
  Future<void> endPlan(String id);

  Future<Review> review(String id, ReviewRequest request);
}
