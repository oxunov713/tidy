import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_client/core/realtime/live_channel.dart';
import 'package:tidy_client/features/tracking/presentation/tracking_controller.dart';
import 'package:tidy_client/features/tracking/presentation/tracking_geometry.dart';
import 'package:tidy_client/features/tracking/presentation/widgets/progress_steps.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';
import '../helpers/fixtures.dart' as fx;

class _FakeLiveChannel implements LiveChannel {
  final events = StreamController<RealtimeEvent>.broadcast();

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Stream<RealtimeEvent> bookingEvents(String bookingId) => events.stream;
}

void main() {
  test('applies live status and location events to the state', () async {
    final channel = _FakeLiveChannel();
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
    final live = await makeContainer(
      Fakes(bookings: repo),
      extra: [liveChannelProvider.overrideWithValue(channel)],
    );

    final sub = live.listen(trackingProvider(booking.id), (_, _) {});
    addTearDown(sub.close);
    final initial = await live.read(trackingProvider(booking.id).future);
    expect(initial.status, BookingStatus.assigned);
    expect(initial.cleanerPosition, isNull);

    channel.events
      ..add(
        BookingStatusChanged(
          bookingId: booking.id,
          status: BookingStatus.onTheWay,
          at: DateTime.utc(2026, 12, 3, 9),
        ),
      )
      ..add(
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
