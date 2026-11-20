import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_core/tidy_core.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  late FakeBookingsRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = FakeBookingsRepository([
      adminBooking(1, status: BookingStatus.pending),
      adminBooking(2, status: BookingStatus.assigned, client: 'Oliver Price'),
      adminBooking(3, status: BookingStatus.pending, client: 'Aisha Rahman'),
      adminBooking(4, status: BookingStatus.completed, client: 'Tom Hughes'),
      adminBooking(5, status: BookingStatus.pending, client: 'Priya Shah'),
    ]);
    container = makeContainer(fakeRepositories(bookings: repo));
  });

  Future<BookingsState> load() =>
      container.read(bookingsControllerProvider.future);

  test('loads the first page with its cursor', () async {
    final state = await load();
    expect(state.items.map((r) => r.booking.code), ['TD-1001', 'TD-1002']);
    expect(state.hasMore, isTrue);
    expect(repo.calls.single.cursor, isNull);
  });

  test('loadMore appends the next page until the cursor is empty', () async {
    await load();
    final notifier = container.read(bookingsControllerProvider.notifier);

    await notifier.loadMore();
    await notifier.loadMore();
    final state = container.read(bookingsControllerProvider).requireValue;

    expect(state.items, hasLength(5));
    expect(state.hasMore, isFalse);

    // The last page had an empty cursor, so there is nothing left to ask.
    await notifier.loadMore();
    expect(repo.calls, hasLength(3));
  });

  test('a failed loadMore keeps the rows and can be retried', () async {
    await load();
    final notifier = container.read(bookingsControllerProvider.notifier);

    repo.failNextList = const NetworkException();
    await notifier.loadMore();
    var state = container.read(bookingsControllerProvider).requireValue;
    expect(state.items, hasLength(2));
    expect(state.loadMoreError, isA<NetworkException>());
    expect(state.loadingMore, isFalse);

    await notifier.loadMore();
    state = container.read(bookingsControllerProvider).requireValue;
    expect(state.items, hasLength(4));
    expect(state.loadMoreError, isNull);
  });

  test('changing the status filter starts over with that status', () async {
    await load();
    container
        .read(bookingFilterControllerProvider.notifier)
        .setStatus(BookingStatus.pending);
    final state = await load();

    expect(repo.calls.last.status, BookingStatus.pending);
    expect(repo.calls.last.cursor, isNull);
    expect(state.items.map((r) => r.booking.code), ['TD-1001', 'TD-1003']);
  });

  test('the search text is trimmed and sent as q', () async {
    await load();
    container
        .read(bookingFilterControllerProvider.notifier)
        .setQuery('  priya ');
    final state = await load();

    expect(repo.calls.last.query, 'priya');
    expect(state.items.single.clientName, 'Priya Shah');
  });

  test('a page that arrives after the filter changed is dropped', () async {
    await load();
    final notifier = container.read(bookingsControllerProvider.notifier);

    final inFlight = notifier.loadMore();
    container
        .read(bookingFilterControllerProvider.notifier)
        .setStatus(BookingStatus.completed);
    await inFlight;
    final state = await load();

    expect(state.items.single.booking.status, BookingStatus.completed);
  });

  test('applyUpdate patches one row in place', () async {
    await load();
    container
        .read(bookingsControllerProvider.notifier)
        .applyUpdate(
          booking(
            id: 'b2',
            code: 'TD-1002',
            status: BookingStatus.assigned,
            cleanerId: 'c9',
          ),
          cleanerName: 'Sarah Jones',
        );
    final rows = container.read(bookingsControllerProvider).requireValue.items;
    expect(rows[1].cleanerName, 'Sarah Jones');
    expect(rows[1].clientName, 'Oliver Price');
    expect(rows[0].cleanerName, isEmpty);
  });

  group('booking details actions', () {
    test('reassign patches the list row and refreshes the stats', () async {
      await load();
      await container.read(statsControllerProvider.future);
      final detail = bookingDetailControllerProvider('b1');
      await container.read(detail.future);

      await container
          .read(detail.notifier)
          .reassign(cleanerId: 'c7', cleanerName: 'Tom Clarke');

      expect(repo.reassigned, [('b1', 'c7')]);
      final rows = container
          .read(bookingsControllerProvider)
          .requireValue
          .items;
      expect(rows.first.cleanerName, 'Tom Clarke');
      expect(rows.first.booking.status, BookingStatus.assigned);
      await container.read(statsControllerProvider.future);
      expect(repo.statsCalls.length, greaterThan(1));
    });

    test('an API error such as slot_taken reaches the caller', () async {
      await load();
      final detail = bookingDetailControllerProvider('b1');
      await container.read(detail.future);
      repo.reassignError = const SlotTakenException(message: 'busy');

      await expectLater(
        container
            .read(detail.notifier)
            .reassign(cleanerId: 'c7', cleanerName: 'Tom Clarke'),
        throwsA(isA<SlotTakenException>()),
      );
      final rows = container
          .read(bookingsControllerProvider)
          .requireValue
          .items;
      expect(rows.first.cleanerName, isEmpty);
    });

    test('cancel marks the row cancelled', () async {
      await load();
      final detail = bookingDetailControllerProvider('b1');
      await container.read(detail.future);

      await container.read(detail.notifier).cancel();

      expect(repo.cancelled, ['b1']);
      final rows = container
          .read(bookingsControllerProvider)
          .requireValue
          .items;
      expect(rows.first.booking.status, BookingStatus.cancelled);
    });
  });

  testWidgets('stats refresh on their own interval', (tester) async {
    final fast = makeContainer(
      fakeRepositories(
        bookings: repo,
        statsInterval: const Duration(seconds: 30),
      ),
    );
    final sub = fast.listen(statsControllerProvider, (_, _) {});
    addTearDown(sub.close);

    await tester.pump();
    expect(repo.statsCalls, hasLength(1));

    await tester.pump(const Duration(seconds: 31));
    await tester.pump();
    expect(repo.statsCalls, hasLength(2));
    expect(sub.read().requireValue.bookings, 7);
  });
}
