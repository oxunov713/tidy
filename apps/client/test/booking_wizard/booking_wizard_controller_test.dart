import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_client/features/addresses/presentation/address_providers.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_controller.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_state.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';
import '../helpers/fixtures.dart' as fx;

void main() {
  late Fakes fakes;
  late FakeBookingRepository repo;

  Future<ProviderContainerLike> setUpWizard() async {
    fakes = Fakes();
    repo = fakes.bookings;
    final container = await makeContainer(fakes);
    // Addresses must be loaded for the wizard to pick one up on start.
    await container.read(addressesProvider.future);
    return ProviderContainerLike(container);
  }

  final tenOclock = DateTime.utc(2026, 12, 3, 10);
  List<Slot> slots({bool tenTaken = false}) => [
    Slot(start: DateTime.utc(2026, 12, 3, 9), available: true),
    Slot(start: tenOclock, available: !tenTaken),
  ];

  group('quote', () {
    test('start asks for a quote with the defaults', () async {
      final w = await setUpWizard();

      w.notifier.start(fx.standard);
      await w.settle();

      expect(repo.quoteRequests, hasLength(1));
      expect(repo.quoteRequests.single.bedrooms, 2);
      expect(repo.quoteRequests.single.bathrooms, 1);
      expect(w.state.quote?.total, 6500);
      expect(w.state.quoteLoading, isFalse);
      expect(w.state.address?.id, fx.home.id);
    });

    test('quote is marked loading while a new price is on its way', () async {
      final w = await setUpWizard();
      w.notifier.start(fx.standard);
      await w.settle();

      final pending = Completer<Quote>();
      repo.onQuote = (_) => pending.future;
      w.notifier.setBedrooms(3);
      await w.settle();

      expect(w.state.quoteLoading, isTrue);
      // The old price stays until the new one arrives.
      expect(w.state.quote?.total, 6500);
      expect(w.state.canChooseTime, isFalse);

      pending.complete(fx.quoteFor(total: 7500));
      await w.settle();
      expect(w.state.quote?.total, 7500);
      expect(w.state.canChooseTime, isTrue);
    });

    test(
      'several quick changes send one request with the last values',
      () async {
        fakes = Fakes();
        repo = fakes.bookings;
        final container = await makeContainer(
          fakes,
          debounce: const Duration(milliseconds: 30),
        );
        await container.read(addressesProvider.future);
        final notifier = container.read(bookingWizardProvider.notifier)
          ..start(fx.standard);
        await Future<void>.delayed(const Duration(milliseconds: 5));
        repo.quoteRequests.clear();

        notifier
          ..setBedrooms(3)
          ..setBedrooms(4)
          ..toggleExtra(fx.oven.id)
          ..setFrequency(Frequency.weekly);
        await Future<void>.delayed(const Duration(milliseconds: 120));

        expect(repo.quoteRequests, hasLength(1));
        final request = repo.quoteRequests.single;
        expect(request.bedrooms, 4);
        expect(request.extraIds, [fx.oven.id]);
        expect(request.frequency, Frequency.weekly);
      },
    );

    test('a slow, outdated response never overwrites a newer one', () async {
      final w = await setUpWizard();
      final first = Completer<Quote>();
      final second = Completer<Quote>();
      final replies = [first, second];
      repo.onQuote = (_) => replies.removeAt(0).future;

      w.notifier.start(fx.standard); // request 1
      await w.settle();
      w.notifier.setBedrooms(3); // request 2
      await w.settle();

      second.complete(fx.quoteFor(total: 7500));
      await w.settle();
      first.complete(fx.quoteFor(total: 1));
      await w.settle();

      expect(w.state.quote?.total, 7500);
    });

    test('a failed quote is reported and can be retried', () async {
      final w = await setUpWizard();
      repo.onQuote = (_) => Future.error(const NetworkException());
      w.notifier.start(fx.standard);
      await w.settle();

      expect(w.state.quoteError, isA<NetworkException>());
      expect(w.state.quoteLoading, isFalse);

      repo.onQuote = (_) async => fx.quoteFor();
      w.notifier.retryQuote();
      await w.settle();
      expect(w.state.quoteError, isNull);
      expect(w.state.quote?.total, 6800);
    });

    test(
      'changing rooms drops the chosen time, changing frequency keeps it',
      () async {
        final w = await setUpWizard();
        repo.slotList = slots();
        w.notifier.start(fx.standard);
        await w.settle();
        await w.notifier.loadSlots();
        w.notifier.selectSlot(tenOclock);
        expect(w.state.slot, tenOclock);

        w.notifier.setFrequency(Frequency.weekly);
        expect(w.state.slot, tenOclock);

        w.notifier.setBathrooms(2);
        expect(w.state.slot, isNull);
        expect(w.state.slots, isEmpty);
      },
    );

    test('rooms stay between 1 and $maxRooms', () async {
      final w = await setUpWizard();
      w.notifier
        ..start(fx.standard)
        ..setBedrooms(0)
        ..setBathrooms(99);
      expect(w.state.bedrooms, 1);
      expect(w.state.bathrooms, maxRooms);
    });
  });

  group('slots', () {
    test('selecting a taken slot is ignored', () async {
      final w = await setUpWizard();
      repo.slotList = slots(tenTaken: true);
      w.notifier.start(fx.standard);
      await w.settle();
      await w.notifier.loadSlots();

      w.notifier.selectSlot(tenOclock);
      expect(w.state.slot, isNull);
    });

    test('picking another day loads that day and clears the slot', () async {
      final w = await setUpWizard();
      repo.slotList = slots();
      w.notifier.start(fx.standard);
      await w.settle();
      await w.notifier.loadSlots();
      w.notifier.selectSlot(tenOclock);

      await w.notifier.selectDate(DateTime(2026, 12, 4));
      expect(w.state.date, DateTime(2026, 12, 4));
      expect(w.state.slot, isNull);
      expect(repo.slotRequests.last, DateTime(2026, 12, 4));
    });

    test('a loaded slot that is no longer free is dropped', () async {
      final w = await setUpWizard();
      repo.slotList = slots();
      w.notifier.start(fx.standard);
      await w.settle();
      await w.notifier.loadSlots();
      w.notifier.selectSlot(tenOclock);

      repo.slotList = slots(tenTaken: true);
      await w.notifier.loadSlots();
      expect(w.state.slot, isNull);
    });
  });

  group('submit', () {
    Future<ProviderContainerLike> readyToBook() async {
      final w = await setUpWizard();
      repo.slotList = slots();
      w.notifier.start(fx.standard);
      await w.settle();
      await w.notifier.loadSlots();
      w.notifier.selectSlot(tenOclock);
      return w;
    }

    test('creates the booking with the chosen options', () async {
      final w = await readyToBook();
      w.notifier
        ..toggleExtra(fx.oven.id)
        ..setFrequency(Frequency.weekly);
      await w.settle();
      await w.notifier.loadSlots();
      w.notifier.selectSlot(tenOclock);

      final result = await w.notifier.submit();

      expect(result, isA<BookingSubmitted>());
      final request = repo.createRequests.single;
      expect(request.serviceId, fx.standard.id);
      expect(request.addressId, fx.home.id);
      expect(request.start, tenOclock);
      expect(request.extraIds, [fx.oven.id]);
      expect(request.frequency, Frequency.weekly);
      expect(w.state.submitting, isFalse);
    });

    test('slot_taken drops the slot and reloads the times', () async {
      final w = await readyToBook();
      repo
        ..createError = const SlotTakenException(message: 'taken')
        ..slotList = slots(tenTaken: true);
      final loadsBefore = repo.slotRequests.length;

      final result = await w.notifier.submit();

      expect(result, isA<BookingSlotTaken>());
      expect(w.state.slot, isNull);
      expect(w.state.submitting, isFalse);
      expect(repo.slotRequests.length, loadsBefore + 1);
      expect(w.state.slots.last.available, isFalse);
    });

    test('other errors come back as a failure and keep the slot', () async {
      final w = await readyToBook();
      repo.createError = const NetworkException();

      final result = await w.notifier.submit();

      expect(result, isA<BookingSubmitFailed>());
      expect((result as BookingSubmitFailed).error, isA<NetworkException>());
      expect(w.state.slot, tenOclock);
      expect(w.state.submitting, isFalse);
    });

    test('changed access notes are saved as a new address first', () async {
      final w = await readyToBook();
      w.notifier.setAccessNotes('Key under the mat');

      await w.notifier.submit();

      expect(fakes.addresses.added.single.accessNotes, 'Key under the mat');
      expect(repo.createRequests.single.addressId, isNot(fx.home.id));
    });

    test('unchanged notes reuse the saved address', () async {
      final w = await readyToBook();

      await w.notifier.submit();

      expect(fakes.addresses.added, isEmpty);
      expect(repo.createRequests.single.addressId, fx.home.id);
    });

    test('cannot submit without a slot', () async {
      final w = await setUpWizard();
      w.notifier.start(fx.standard);
      await w.settle();

      expect(await w.notifier.submit(), isA<BookingSubmitFailed>());
      expect(repo.createRequests, isEmpty);
    });
  });

  test('book again pre-fills rooms, extras, frequency and cleaner', () async {
    final w = await setUpWizard();
    final previous = fx
        .booking(cleanerId: 'cl-1', frequency: Frequency.fortnightly)
        .copyWith(
          bedrooms: 3,
          extras: [
            const BookingExtra(
              id: 'ex-oven',
              title: 'Inside oven',
              price: 2000,
            ),
          ],
        );

    w.notifier.start(fx.standard, from: previous);

    expect(w.state.bedrooms, 3);
    expect(w.state.extraIds, {'ex-oven'});
    expect(w.state.frequency, Frequency.fortnightly);
    expect(w.state.cleanerId, 'cl-1');
  });

  test('today comes from the injected clock', () async {
    fakes = Fakes();
    final container = await makeContainer(
      fakes,
      now: () => DateTime(2026, 12, 1, 15),
    );
    final w = ProviderContainerLike(container)..notifier.start(fx.standard);
    expect(w.state.date, DateTime(2026, 12));
  });
}
