import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/core/realtime/live_channel.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_core/tidy_core.dart';

part 'tracking_controller.freezed.dart';
part 'tracking_controller.g.dart';

@freezed
abstract class TrackingState with _$TrackingState {
  const factory TrackingState({
    required BookingDetails details,

    /// Latest status, which may be newer than [details].
    required BookingStatus status,
    GeoPoint? cleanerPosition,
    int? etaMinutes,
  }) = _TrackingState;

  const TrackingState._();

  GeoPoint get home =>
      GeoPoint(lat: details.address.lat, lng: details.address.lng);
}

/// A booking's details kept live: `booking.status` and `cleaner.location`
/// events from the `booking:<id>` room update the state as they arrive.
@riverpod
class Tracking extends _$Tracking {
  @override
  Future<TrackingState> build(String bookingId) async {
    final details = await ref
        .watch(bookingRepositoryProvider)
        .details(bookingId);
    final last = details.lastLocation;

    final subscription = ref
        .read(liveChannelProvider)
        .bookingEvents(bookingId)
        .listen(_onEvent);
    ref.onDispose(() => unawaited(subscription.cancel()));

    return TrackingState(
      details: details,
      status: details.booking.status,
      cleanerPosition: last == null
          ? null
          : GeoPoint(lat: last.lat, lng: last.lng),
    );
  }

  void _onEvent(RealtimeEvent event) {
    final current = state.value;
    if (current == null) return;
    switch (event) {
      case BookingStatusChanged(:final status):
        state = AsyncData(current.copyWith(status: status));
        // A cleaner may have just been assigned, and finished or cancelled
        // bookings move between the lists.
        unawaited(_reloadDetails());
        ref
          ..invalidate(bookingsListProvider(BookingScope.upcoming))
          ..invalidate(bookingsListProvider(BookingScope.past));
      case CleanerLocationUpdated(:final lat, :final lng, :final etaMinutes):
        state = AsyncData(
          current.copyWith(
            cleanerPosition: GeoPoint(lat: lat, lng: lng),
            etaMinutes: etaMinutes ?? current.etaMinutes,
          ),
        );
      case _:
        break;
    }
  }

  Future<void> _reloadDetails() async {
    try {
      final details = await ref
          .read(bookingRepositoryProvider)
          .details(bookingId);
      final current = state.value;
      if (current == null) return;
      state = AsyncData(current.copyWith(details: details));
    } on Object {
      // The live status is already applied; a failed refresh is not worth an
      // error screen.
    }
  }
}
