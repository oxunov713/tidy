import 'package:tidy_client/features/bookings/domain/booking_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({required this._api});

  final BookingApi _api;

  @override
  Future<Quote> quote(QuoteRequest request) => _api.quote(request);

  @override
  Future<SlotsResponse> slots({
    required String serviceId,
    required int bedrooms,
    required int bathrooms,
    required DateTime date,
    required String addressId,
    List<String> extraIds = const [],
    String? cleanerId,
  }) => _api.slots(
    serviceId: serviceId,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    date: date,
    addressId: addressId,
    extraIds: extraIds,
    cleanerId: cleanerId,
  );

  @override
  Future<BookingCreated> create(CreateBookingRequest request) =>
      _api.create(request);

  @override
  Future<BookingPage> list({
    required BookingScope scope,
    String? cursor,
    int? limit,
  }) => _api.list(scope: scope, cursor: cursor, limit: limit);

  @override
  Future<BookingDetails> details(String id) => _api.get(id);

  @override
  Future<Cancellation> cancel(
    String id, {
    CancelScope scope = CancelScope.visit,
  }) => _api.cancel(id, scope: scope);

  @override
  Future<PaymentIntentInfo> pay(String id) => _api.pay(id);

  @override
  Future<List<Plan>> plans() => _api.plans();

  @override
  Future<void> endPlan(String id) => _api.endPlan(id);

  @override
  Future<Review> review(String id, ReviewRequest request) =>
      _api.review(id, request);
}
