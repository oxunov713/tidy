import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/offers_controller.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fixtures.dart' as fx;
import 'support/harness.dart';

void main() {
  late Harness h;

  /// Runs [body] with a fake clock that follows the fake timers, so offers
  /// expire when the test advances time.
  void withOffers(
    void Function(ProviderContainer container, FakeAsync async, Harness h) body,
  ) {
    fakeAsync((async) {
      final clock = async.getClock(fx.now);
      final harness = Harness(clock: clock.now);
      late ProviderContainer container;
      unawaited(
        harness.container().then((c) {
          container = c;
        }),
      );
      async.flushMicrotasks();
      body(container, async, harness);
      async.flushMicrotasks();
      container.dispose();
    });
  }

  OffersState read(ProviderContainer c) => c.read(offersControllerProvider);

  test('loads open offers on start', () {
    h = Harness()..offersRepo.open_ = [fx.offer()];
    fakeAsync((async) {
      late ProviderContainer c;
      unawaited(h.container().then((value) => c = value));
      async.flushMicrotasks();
      c.read(offersControllerProvider);
      expect(read(c).loading, isTrue);
      async.flushMicrotasks();
      expect(read(c).loading, isFalse);
      expect(read(c).offers.single.id, 'o1');
      expect(h.gateway.subscribeCalls, contains(Rooms.cleanerOffers));
      c.dispose();
    });
  });

  test(
    'a new offer over the socket is added, alerts once and gets details',
    () {
      withOffers((c, async, h) {
        c.read(offersControllerProvider);
        async.flushMicrotasks();
        h.offersRepo.open_ = [fx.offer()];

        h.gateway.emit(
          OfferReceived(
            booking: fx.offer(withDetails: false).booking,
            expiresAt: fx.now.add(const Duration(seconds: 60)),
          ),
        );
        async.flushMicrotasks();

        final state = read(c);
        expect(state.offers, hasLength(1));
        expect(state.alertId, 'o1');
        expect(h.alerts.count, 1);
        // The follow-up GET /cleaner/offers filled in distance and area.
        expect(state.offers.single.distanceKm, 2.4);
        expect(state.offers.single.city, 'Camden');

        // The same offer again must not alert twice.
        h.gateway.emit(
          OfferReceived(
            booking: fx.offer().booking,
            expiresAt: fx.now.add(const Duration(seconds: 60)),
          ),
        );
        async.flushMicrotasks();
        expect(h.alerts.count, 1);
        expect(read(c).offers, hasLength(1));
      });
    },
  );

  test('an offer that is already expired is ignored', () {
    withOffers((c, async, h) {
      c.read(offersControllerProvider);
      async.flushMicrotasks();
      h.gateway.emit(
        OfferReceived(
          booking: fx.offer().booking,
          expiresAt: fx.now.subtract(const Duration(seconds: 1)),
        ),
      );
      async.flushMicrotasks();
      expect(read(c).offers, isEmpty);
      expect(h.alerts.count, 0);
    });
  });

  test('an offer expires after its countdown and a notice is raised', () {
    withOffers((c, async, h) {
      h.offersRepo.open_ = [fx.offer(expiresIn: const Duration(seconds: 42))];
      c.read(offersControllerProvider);
      async.flushMicrotasks();
      expect(read(c).offers, hasLength(1));

      async.elapse(const Duration(seconds: 41));
      expect(read(c).offers, hasLength(1));

      async.elapse(const Duration(seconds: 2));
      expect(read(c).offers, isEmpty);
      expect(read(c).notice, isA<OfferExpired>());
    });
  });

  test('offer.gone removes the offer and tells the cleaner', () {
    withOffers((c, async, h) {
      h.offersRepo.open_ = [fx.offer()];
      c.read(offersControllerProvider);
      async.flushMicrotasks();

      h.gateway.emit(const OfferWithdrawn('o1'));
      async.flushMicrotasks();

      expect(read(c).offers, isEmpty);
      expect(read(c).notice, isA<OfferTaken>());
    });
  });

  test('offer.gone for an offer we never saw is ignored', () {
    withOffers((c, async, h) {
      c.read(offersControllerProvider);
      async.flushMicrotasks();
      h.gateway.emit(const OfferWithdrawn('nope'));
      async.flushMicrotasks();
      expect(read(c).notice, isNull);
    });
  });

  test('accepting reports the booking, drops the offer and reloads jobs', () {
    withOffers((c, async, h) {
      h.offersRepo
        ..open_ = [fx.offer()]
        ..acceptResult = fx.booking(id: 'o1');
      h.jobsRepo.jobs_ = [];
      c
        ..read(offersControllerProvider)
        ..read(jobsControllerProvider);
      async.flushMicrotasks();
      final loadsBefore = h.jobsRepo.loads;

      unawaited(c.read(offersControllerProvider.notifier).accept('o1'));
      async.flushMicrotasks();

      expect(h.offersRepo.accepted, ['o1']);
      expect(read(c).offers, isEmpty);
      expect(read(c).busyId, isNull);
      final notice = read(c).notice;
      expect(notice, isA<OfferAccepted>());
      expect((notice! as OfferAccepted).booking.id, 'o1');

      // The accepted job comes with its address from the schedule request.
      c.read(jobsControllerProvider);
      async.flushMicrotasks();
      expect(h.jobsRepo.loads, greaterThan(loadsBefore));
    });
  });

  test('slot_taken drops the offer, releases it and says why', () {
    withOffers((c, async, h) {
      h.offersRepo
        ..open_ = [fx.offer()]
        ..acceptError = const SlotTakenException(message: 'busy');
      c.read(offersControllerProvider);
      async.flushMicrotasks();

      unawaited(c.read(offersControllerProvider.notifier).accept('o1'));
      async.flushMicrotasks();

      expect(read(c).offers, isEmpty);
      expect(read(c).notice, isA<OfferSlotTaken>());
      // The offer is declined in the background so the dispatcher moves on.
      expect(h.offersRepo.declined, ['o1']);
    });
  });

  test('offer_gone on accept means someone else was faster', () {
    withOffers((c, async, h) {
      h.offersRepo
        ..open_ = [fx.offer()]
        ..acceptError = const OfferGoneException(message: 'gone');
      c.read(offersControllerProvider);
      async.flushMicrotasks();

      unawaited(c.read(offersControllerProvider.notifier).accept('o1'));
      async.flushMicrotasks();

      expect(read(c).offers, isEmpty);
      expect(read(c).notice, isA<OfferTaken>());
      expect(h.offersRepo.declined, isEmpty);
    });
  });

  test('a network error on accept keeps the offer so it can be retried', () {
    withOffers((c, async, h) {
      h.offersRepo
        ..open_ = [fx.offer()]
        ..acceptError = const NetworkException();
      c.read(offersControllerProvider);
      async.flushMicrotasks();

      unawaited(c.read(offersControllerProvider.notifier).accept('o1'));
      async.flushMicrotasks();

      expect(read(c).offers, hasLength(1));
      expect(read(c).busyId, isNull);
      expect(read(c).notice, isA<OfferFailed>());
    });
  });

  test('declining removes the offer silently', () {
    withOffers((c, async, h) {
      h.offersRepo.open_ = [fx.offer()];
      c.read(offersControllerProvider);
      async.flushMicrotasks();

      unawaited(c.read(offersControllerProvider.notifier).decline('o1'));
      async.flushMicrotasks();

      expect(h.offersRepo.declined, ['o1']);
      expect(read(c).offers, isEmpty);
      expect(read(c).notice, isNull);
    });
  });

  test('the earliest expiring offer is listed first', () {
    withOffers((c, async, h) {
      h.offersRepo.open_ = [
        fx.offer(id: 'late', expiresIn: const Duration(seconds: 50)),
        fx.offer(id: 'soon', expiresIn: const Duration(seconds: 10)),
      ];
      c.read(offersControllerProvider);
      async.flushMicrotasks();
      expect(read(c).offers.map((o) => o.id), ['soon', 'late']);
    });
  });
}
