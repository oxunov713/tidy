import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/core/alerts/offer_alerts.dart';
import 'package:tidy_cleaner/core/clock.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/jobs/data/cleaner_repositories.dart';
import 'package:tidy_cleaner/features/jobs/domain/incoming_offer.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_core/tidy_core.dart';

part 'offers_controller.g.dart';

/// One-off result of an offer action, shown once as a message or navigation.
sealed class OfferNotice {
  const OfferNotice();
}

final class OfferAccepted extends OfferNotice {
  const OfferAccepted(this.booking);

  final Booking booking;
}

/// Another cleaner got there first, or the server withdrew the offer.
final class OfferTaken extends OfferNotice {
  const OfferTaken();
}

final class OfferExpired extends OfferNotice {
  const OfferExpired();
}

/// The cleaner already has a job at that time.
final class OfferSlotTaken extends OfferNotice {
  const OfferSlotTaken();
}

final class OfferFailed extends OfferNotice {
  const OfferFailed(this.error);

  final Object error;
}

class OffersState {
  const OffersState({
    this.offers = const [],
    this.loading = false,
    this.busyId,
    this.alertId,
    this.notice,
  });

  /// Open offers, the one that expires first at the top.
  final List<IncomingOffer> offers;
  final bool loading;

  /// Offer with an accept or decline request in flight.
  final String? busyId;

  /// Offer that just arrived and should get the full-screen card.
  final String? alertId;
  final OfferNotice? notice;

  IncomingOffer? byId(String? id) {
    for (final o in offers) {
      if (o.id == id) return o;
    }
    return null;
  }

  OffersState copyWith({
    List<IncomingOffer>? offers,
    bool? loading,
    String? busyId,
    String? alertId,
    OfferNotice? notice,
    bool clearBusy = false,
    bool clearAlert = false,
    bool clearNotice = false,
  }) => OffersState(
    offers: offers ?? this.offers,
    loading: loading ?? this.loading,
    busyId: clearBusy ? null : busyId ?? this.busyId,
    alertId: clearAlert ? null : alertId ?? this.alertId,
    notice: clearNotice ? null : notice ?? this.notice,
  );
}

/// Open job offers: loaded on start, kept up to date by `offer.new` and
/// `offer.gone` over the WebSocket, and dropped when they expire.
@Riverpod(keepAlive: true)
class OffersController extends _$OffersController {
  final _expiryTimers = <String, Timer>{};

  @override
  OffersState build() {
    ref.watch(currentUserIdProvider);
    final realtime = ref.watch(realtimeClientProvider)
      ..subscribe(Rooms.cleanerOffers);
    final events = realtime.events.listen(_onEvent);
    ref.onDispose(() {
      unawaited(events.cancel());
      realtime.unsubscribe(Rooms.cleanerOffers);
      for (final timer in _expiryTimers.values) {
        timer.cancel();
      }
      _expiryTimers.clear();
    });
    unawaited(Future.microtask(load));
    return const OffersState(loading: true);
  }

  /// Fetches the open offers. Used on start and to fill in the distance and
  /// area of an offer that arrived over the socket.
  ///
  /// With [replace] the server's list is the truth: offers it no longer
  /// returns (taken or expired while the socket was down) are dropped.
  Future<void> load({bool replace = false}) async {
    final List<IncomingOffer> fresh;
    try {
      fresh = await ref.read(offersRepositoryProvider).open();
    } on Object {
      if (ref.mounted) state = state.copyWith(loading: false);
      return;
    }
    if (!ref.mounted) return;
    final now = ref.read(clockProvider)();
    final merged = {
      for (final o in state.offers)
        if (!replace || fresh.any((f) => f.id == o.id) || o.id == state.busyId)
          o.id: o,
    };
    for (final offer in fresh) {
      if (offer.isExpired(now)) continue;
      merged[offer.id] = merged[offer.id]?.mergedWith(offer) ?? offer;
    }
    _setOffers(merged.values);
    state = state.copyWith(loading: false);
  }

  Future<void> accept(String bookingId) async {
    if (state.busyId != null) return;
    state = state.copyWith(busyId: bookingId, clearNotice: true);
    try {
      final booking = await ref
          .read(offersRepositoryProvider)
          .accept(bookingId);
      if (!ref.mounted) return;
      ref.invalidate(jobsControllerProvider);
      _finish(bookingId, OfferAccepted(booking));
    } on SlotTakenException {
      // The offer stays open for us until it expires; release it so the
      // dispatcher can move on to the next cleaner.
      unawaited(_declineQuietly(bookingId));
      _finish(bookingId, const OfferSlotTaken());
    } on OfferGoneException {
      _finish(bookingId, const OfferTaken());
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(clearBusy: true, notice: OfferFailed(e));
    }
  }

  Future<void> decline(String bookingId) async {
    if (state.busyId != null) return;
    state = state.copyWith(busyId: bookingId, clearNotice: true);
    try {
      await ref.read(offersRepositoryProvider).decline(bookingId);
      _finish(bookingId, null);
    } on OfferGoneException {
      _finish(bookingId, null);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(clearBusy: true, notice: OfferFailed(e));
    }
  }

  void dismissAlert() => state = state.copyWith(clearAlert: true);

  void consumeNotice() => state = state.copyWith(clearNotice: true);

  void _onEvent(RealtimeEvent event) {
    switch (event) {
      case OfferReceived(:final booking, :final expiresAt):
        final offer = IncomingOffer(booking: booking, expiresAt: expiresAt);
        if (offer.isExpired(ref.read(clockProvider)())) return;
        final isNew = state.byId(offer.id) == null;
        final merged = state.byId(offer.id)?.mergedWith(offer) ?? offer;
        _setOffers([...state.offers.where((o) => o.id != offer.id), merged]);
        if (isNew) {
          state = state.copyWith(alertId: offer.id);
          unawaited(_alert());
          unawaited(load());
        }
      case Reconnected():
        // Offers sent or withdrawn while the socket was down.
        unawaited(load(replace: true));
      case OfferWithdrawn(:final bookingId):
        // Our own accept or decline is already handling this offer.
        if (state.byId(bookingId) == null || state.busyId == bookingId) return;
        _remove(bookingId);
        state = state.copyWith(notice: const OfferTaken());
      default:
        break;
    }
  }

  void _expire(String bookingId) {
    if (state.byId(bookingId) == null || state.busyId == bookingId) return;
    _remove(bookingId);
    state = state.copyWith(notice: const OfferExpired());
  }

  void _finish(String bookingId, OfferNotice? notice) {
    if (!ref.mounted) return;
    _remove(bookingId);
    state = state.copyWith(clearBusy: true, notice: notice);
  }

  void _remove(String bookingId) {
    _expiryTimers.remove(bookingId)?.cancel();
    state = OffersState(
      offers: state.offers.where((o) => o.id != bookingId).toList(),
      loading: state.loading,
      busyId: state.busyId,
      alertId: state.alertId == bookingId ? null : state.alertId,
      notice: state.notice,
    );
  }

  void _setOffers(Iterable<IncomingOffer> offers) {
    final sorted = offers.toList()
      ..sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
    final now = ref.read(clockProvider)();
    for (final offer in sorted) {
      _expiryTimers[offer.id]?.cancel();
      final left = offer.expiresAt.difference(now);
      _expiryTimers[offer.id] = Timer(
        left.isNegative ? Duration.zero : left,
        () => _expire(offer.id),
      );
    }
    state = state.copyWith(offers: sorted);
  }

  Future<void> _alert() async {
    try {
      await ref.read(offerAlertsProvider).newOffer();
    } on Object {
      // A missing sound must never lose the offer.
    }
  }

  Future<void> _declineQuietly(String bookingId) async {
    try {
      await ref.read(offersRepositoryProvider).decline(bookingId);
    } on Object {
      // Best effort.
    }
  }
}
