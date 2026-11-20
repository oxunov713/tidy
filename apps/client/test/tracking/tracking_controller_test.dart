import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_client/features/tracking/presentation/tracking_controller.dart';
import 'package:tidy_client/features/tracking/presentation/tracking_geometry.dart';
import 'package:tidy_client/features/tracking/presentation/widgets/progress_steps.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';
import '../helpers/fixtures.dart' as fx;

void main() {
  test('applies live status and location events to the state', () async {
    final booking = fx.booking(status: BookingStatus.assigned, cleanerId: 'c');
    final repo = FakeBookingRepository()
      ..detailsById = {
        booking.id: BookingDetails(
          booking: booking,
          address: fx.home,
          cleaner: const CleanerCard(
            id: 'c',
            fullName: 'Sarah Jones',
            rating: 4.9,
            ratingCount: 1,
          ),
        ),
      };
    final fakes = Fakes(bookings: repo);
    final live = await makeContainer(fakes);

    final sub = live.listen(trackingProvider(booking.id), (_, _) {});
    addTearDown(sub.close);
    final initial = await live.read(trackingProvider(booking.id).future);
    expect(initial.status, BookingStatus.assigned);
    expect(initial.cleanerPosition, isNull);

    fakes.realtime
      ..emit(
        BookingStatusChanged(
          bookingId: booking.id,
          status: BookingStatus.onTheWay,
          at: DateTime.utc(2026, 12, 3, 9),
        ),
      )
      ..emit(
        CleanerLocationUpdated(
          bookingId: booking.id,
          lat: 51.51,
          lng: -0.12,
          etaMinutes: 12,
        ),
      );
    await Future<void>.delayed(const Duration(milliseconds: 20));

    final state = live.read(trackingProvider(booking.id)).value!;
    expect(state.status, BookingStatus.onTheWay);
    expect(state.cleanerPosition, const GeoPoint(lat: 51.51, lng: -0.12));
    expect(state.etaMinutes, 12);
  });

  group('live updates', () {
    late FakeBookingRepository repo;
    late Fakes fakes;
    late ProviderContainer live;
    late Booking booking;

    Future<void> open() async {
      booking = fx.booking(status: BookingStatus.onTheWay, cleanerId: 'c');
      repo = FakeBookingRepository()
        ..detailsById = {booking.id: _details(booking)};
      fakes = Fakes(bookings: repo);
      live = await makeContainer(fakes)
        ..listen(trackingProvider(booking.id), (_, _) {});
      await live.read(trackingProvider(booking.id).future);
    }

    Future<void> settle() =>
        Future<void>.delayed(const Duration(milliseconds: 20));

    test(
      'joins the booking room while open and leaves it on dispose',
      () async {
        await open();
        expect(fakes.realtime.rooms, {Rooms.booking(booking.id)});
        live.dispose();
        await settle();
        expect(fakes.realtime.rooms, isEmpty);
      },
    );

    test('closing the chat does not stop tracking', () async {
      await open();
      // The chat screen watches the same room.
      final chat = fakes.realtime.bookingEvents(booking.id).listen((_) {});
      expect(fakes.realtime.countOf(Rooms.booking(booking.id)), 2);

      await chat.cancel();

      expect(fakes.realtime.rooms, {Rooms.booking(booking.id)});
      fakes.realtime.emit(
        CleanerLocationUpdated(bookingId: booking.id, lat: 51.5, lng: -0.1),
      );
      await settle();
      expect(
        live.read(trackingProvider(booking.id)).value!.cleanerPosition,
        const GeoPoint(lat: 51.5, lng: -0.1),
      );
    });

    test('a reconnect refetches the booking and the last position', () async {
      await open();
      repo.detailsById = {
        booking.id: _details(
          booking.copyWith(status: BookingStatus.inProgress),
          lastLocation: CleanerLocation(
            lat: 51.52,
            lng: -0.16,
            at: DateTime.utc(2026, 12, 3, 9),
          ),
        ),
      };

      fakes.realtime.emit(const Reconnected());
      await settle();

      final state = live.read(trackingProvider(booking.id)).value!;
      expect(state.status, BookingStatus.inProgress);
      expect(state.cleanerPosition, const GeoPoint(lat: 51.52, lng: -0.16));
    });

    test('losing access marks the state and stops live updates', () async {
      await open();
      fakes.realtime.emit(
        RoomUnsubscribed(
          Rooms.booking(booking.id),
          reason: 'access_revoked',
        ),
      );
      await settle();
      expect(
        live.read(trackingProvider(booking.id)).value!.accessRevoked,
        isTrue,
      );
    });

    test('another booking losing access is ignored', () async {
      await open();
      fakes.realtime.emit(
        const RoomUnsubscribed('booking:other', reason: 'access_revoked'),
      );
      await settle();
      expect(
        live.read(trackingProvider(booking.id)).value!.accessRevoked,
        isFalse,
      );
    });
  });

  test('progress steps follow the status', () {
    expect(ProgressSteps.stepsReached(BookingStatus.confirmed), 1);
    expect(ProgressSteps.stepsReached(BookingStatus.onTheWay), 2);
    expect(ProgressSteps.stepsReached(BookingStatus.inProgress), 3);
    expect(ProgressSteps.stepsReached(BookingStatus.completed), 4);
    expect(ProgressSteps.stepsReached(BookingStatus.cancelled), 0);
  });

  test('zoom decreases as the cleaner is further away', () {
    const home = GeoPoint(lat: 51.5238, lng: -0.1586);
    const near = GeoPoint(lat: 51.5260, lng: -0.1586);
    const far = GeoPoint(lat: 51.60, lng: -0.1586);
    expect(distanceKm(home, home), 0);
    expect(distanceKm(home, near), closeTo(0.24, 0.02));
    expect(
      zoomForDistance(distanceKm(home, near)),
      greaterThan(
        zoomForDistance(distanceKm(home, far)),
      ),
    );
  });
}

BookingDetails _details(Booking booking, {CleanerLocation? lastLocation}) =>
    BookingDetails(
      booking: booking,
      address: fx.home,
      lastLocation: lastLocation,
      cleaner: const CleanerCard(
        id: 'c',
        fullName: 'Sarah Jones',
        rating: 4.9,
        ratingCount: 1,
      ),
    );
