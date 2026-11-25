import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tidy_client/features/addresses/domain/address_repository.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/bookings/domain/booking_repository.dart';
import 'package:tidy_client/features/catalog/domain/catalog_repository.dart';
import 'package:tidy_core/tidy_core.dart';

import 'fixtures.dart' as fx;

class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository({
    this.serviceList = const [fx.standard, fx.deep],
    this.extraList = const [fx.oven, fx.fridge],
    this.failServices = false,
  });

  final List<Service> serviceList;
  final List<Extra> extraList;
  bool failServices;
  int serviceCalls = 0;

  @override
  Future<List<Service>> services() async {
    serviceCalls++;
    if (failServices) throw const NetworkException();
    return serviceList;
  }

  @override
  Future<List<Extra>> extras() async => extraList;
}

class FakeAddressRepository implements AddressRepository {
  FakeAddressRepository([List<Address>? initial])
    : items = initial ?? [fx.home];

  final List<Address> items;
  final added = <AddressInput>[];

  @override
  Future<List<Address>> list() async => [...items];

  @override
  Future<Address> add(AddressInput input) async {
    added.add(input);
    final address = Address(
      id: 'addr-${items.length + 1}',
      line1: input.line1,
      city: input.city,
      postcode: input.postcode,
      lat: input.lat,
      lng: input.lng,
      line2: input.line2,
      accessNotes: input.accessNotes,
    );
    items.add(address);
    return address;
  }

  @override
  Future<void> delete(String id) async => items.removeWhere((a) => a.id == id);
}

class FakeBookingRepository implements BookingRepository {
  /// Computes the quote; can be swapped per test.
  Future<Quote> Function(QuoteRequest request) onQuote = (request) async =>
      fx.quoteFor(total: 4500 + request.bedrooms * 1000);

  final quoteRequests = <QuoteRequest>[];
  final slotRequests = <DateTime>[];
  final createRequests = <CreateBookingRequest>[];

  /// Slots returned by [slots]; tests change it between calls.
  List<Slot> slotList = [];
  ApiException? createError;

  /// Pages by scope; each call hands out the next one.
  final Map<BookingScope, List<BookingPage>> pages = {
    BookingScope.upcoming: [const BookingPage()],
    BookingScope.past: [const BookingPage()],
  };
  final listCursors = <String?>[];
  Map<String, BookingDetails> detailsById = {};

  @override
  Future<Quote> quote(QuoteRequest request) {
    quoteRequests.add(request);
    return onQuote(request);
  }

  @override
  Future<SlotsResponse> slots({
    required String serviceId,
    required int bedrooms,
    required int bathrooms,
    required DateTime date,
    required String addressId,
    List<String> extraIds = const [],
    String? cleanerId,
  }) async {
    slotRequests.add(date);
    return SlotsResponse(date: BookingApi.formatDate(date), slots: slotList);
  }

  @override
  Future<BookingCreated> create(CreateBookingRequest request) async {
    createRequests.add(request);
    final error = createError;
    if (error != null) throw error;
    return BookingCreated(
      booking: fx.booking(),
      payment: const PaymentIntentInfo(clientSecret: 'secret'),
    );
  }

  @override
  Future<BookingPage> list({
    required BookingScope scope,
    String? cursor,
    int? limit,
  }) async {
    listCursors.add(cursor);
    final queue = pages[scope]!;
    return queue.length > 1 ? queue.removeAt(0) : queue.first;
  }

  @override
  Future<BookingDetails> details(String id) async =>
      detailsById[id] ??
      BookingDetails(
        booking: fx.booking(id: id),
        address: fx.home,
      );

  @override
  Future<Cancellation> cancel(String id) async =>
      Cancellation(booking: fx.booking(id: id), refunded: true);

  @override
  Future<Review> review(String id, ReviewRequest request) =>
      Future.error(UnimplementedError());
}

/// A map that draws nothing, so tests never touch the native Yandex view.
class FakeMapProvider implements MapProvider {
  const FakeMapProvider();

  @override
  Widget buildMap({
    required GeoPoint center,
    List<MapMarker> markers = const [],
    List<GeoPoint>? route,
    void Function(GeoPoint)? onTap,
  }) => const SizedBox.expand(key: ValueKey('fake-map'));
}

/// Signed-in auth state without any network.
class FakeAuthController extends AuthController {
  @override
  Future<User?> build() async => fx.user();
}

class FakeSignedOutAuthController extends AuthController {
  @override
  Future<User?> build() async => null;
}
