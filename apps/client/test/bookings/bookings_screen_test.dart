import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_screen.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';
import '../helpers/fixtures.dart' as fx;
import '../helpers/viewport.dart';

void main() {
  Booking at(String id, BookingStatus status, {int day = 3, String? cleaner}) =>
      fx.booking(
        id: id,
        status: status,
        start: DateTime.utc(2026, 12, day, 10),
        cleanerId: cleaner,
      );

  Future<void> open(WidgetTester tester, FakeBookingRepository repo) async {
    usePhoneScreen(tester);
    await pumpScreen(
      tester,
      const BookingsScreen(),
      Fakes(bookings: repo),
      extraRoutes: ['/', '/booking/:id'],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists upcoming bookings with badges and the right actions', (
    tester,
  ) async {
    final repo = FakeBookingRepository()
      ..pages[BookingScope.upcoming] = [
        BookingPage(
          items: [
            at('a', BookingStatus.onTheWay, cleaner: 'cl-1'),
            at('b', BookingStatus.confirmed, day: 10),
          ],
        ),
      ];
    await open(tester, repo);

    expect(find.text('On the way'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('£68.00'), findsNWidgets(2));
    expect(find.text('Track'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    // Only the one that has not started travelling can be cancelled.
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('the Past tab shows Rate and Book again for finished cleans', (
    tester,
  ) async {
    final repo = FakeBookingRepository()
      ..pages[BookingScope.past] = [
        BookingPage(
          items: [
            at('p1', BookingStatus.completed, cleaner: 'cl-1'),
            at('p2', BookingStatus.cancelled),
          ],
        ),
      ];
    await open(tester, repo);

    await tester.tap(find.text('Past'));
    await tester.pumpAndSettle();

    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Rate'), findsOneWidget);
    expect(find.text('Book again'), findsNWidgets(2));
    expect(find.text('Cancel'), findsNothing);
  });

  testWidgets('shows the cleaner name once the details arrive', (tester) async {
    final booking = at('a', BookingStatus.assigned, cleaner: 'cl-1');
    final repo = FakeBookingRepository()
      ..pages[BookingScope.upcoming] = [
        BookingPage(items: [booking]),
      ]
      ..detailsById = {
        'a': BookingDetails(
          booking: booking,
          address: fx.home,
          cleaner: const CleanerCard(
            id: 'cl-1',
            fullName: 'Sarah Jones',
            rating: 4.9,
            ratingCount: 10,
          ),
        ),
      };
    await open(tester, repo);

    expect(find.text('Sarah Jones'), findsOneWidget);
  });

  testWidgets('loads the next page with the cursor when scrolling down', (
    tester,
  ) async {
    final first = [
      for (var i = 1; i <= 6; i++) at('b$i', BookingStatus.confirmed, day: i),
    ];
    final repo = FakeBookingRepository()
      ..pages[BookingScope.upcoming] = [
        BookingPage(items: first, nextCursor: 'cursor-2'),
        BookingPage(items: [at('last', BookingStatus.confirmed, day: 20)]),
      ];
    await open(tester, repo);
    expect(repo.listCursors, [null]);

    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();

    expect(repo.listCursors, [null, 'cursor-2']);
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('Thu 20 Dec'.replaceAll('Thu', 'Sun')), findsNothing);
    expect(find.textContaining('20 Dec'), findsOneWidget);
    // The last page has no cursor, so scrolling does not fetch again.
    expect(repo.listCursors, hasLength(2));
  });

  testWidgets('pull to refresh reloads the first page', (tester) async {
    final repo = FakeBookingRepository()
      ..pages[BookingScope.upcoming] = [
        BookingPage(items: [at('a', BookingStatus.confirmed)]),
      ];
    await open(tester, repo);
    expect(repo.listCursors, hasLength(1));

    await tester.drag(find.byType(ListView), const Offset(0, 400));
    await tester.pumpAndSettle();

    expect(repo.listCursors, hasLength(2));
    expect(find.text('Confirmed'), findsOneWidget);
  });

  testWidgets('shows an empty state with a way to book', (tester) async {
    await open(tester, FakeBookingRepository());

    expect(find.text('Nothing booked yet'), findsOneWidget);
    expect(find.text('Book a clean'), findsOneWidget);

    await tester.tap(find.text('Past'));
    await tester.pumpAndSettle();
    expect(find.text('No past cleans'), findsOneWidget);
  });

  testWidgets('shows an error and recovers on retry', (tester) async {
    final repo = _FailingOnce();
    await open(tester, repo);

    expect(find.text('Something went wrong'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsNothing);
    expect(find.text('Confirmed'), findsOneWidget);
  });

  testWidgets('cancelling asks first and explains the refund', (tester) async {
    final repo = FakeBookingRepository()
      ..pages[BookingScope.upcoming] = [
        BookingPage(items: [at('a', BookingStatus.confirmed, day: 20)]),
      ];
    await open(tester, repo);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel this booking?'), findsOneWidget);
    expect(find.textContaining('free'), findsOneWidget);

    await tester.tap(find.text('Cancel booking'));
    await tester.pumpAndSettle();
    expect(find.textContaining('will be refunded'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });
}

class _FailingOnce extends FakeBookingRepository {
  bool failed = false;

  @override
  Future<BookingPage> list({
    required BookingScope scope,
    String? cursor,
    int? limit,
  }) async {
    if (!failed) {
      failed = true;
      throw const NetworkException();
    }
    return BookingPage(items: [fx.booking()]);
  }
}
