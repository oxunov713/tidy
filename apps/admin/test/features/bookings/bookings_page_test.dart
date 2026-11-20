import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_page.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(setUpFonts);

  late FakeBookingsRepository repo;

  setUp(() {
    repo = FakeBookingsRepository([
      adminBooking(1, status: BookingStatus.pending),
      adminBooking(
        2,
        status: BookingStatus.assigned,
        client: 'Oliver Price',
        cleaner: 'Sarah Jones',
      ),
      adminBooking(3, status: BookingStatus.pending, client: 'Aisha Rahman'),
      adminBooking(4, status: BookingStatus.completed, client: 'Tom Hughes'),
      adminBooking(5, status: BookingStatus.pending, client: 'Priya Shah'),
    ]);
  });

  Future<void> pumpPage(WidgetTester tester, {Size? size}) async {
    await pumpApp(
      tester,
      const BookingsPage(),
      overrides: fakeRepositories(bookings: repo),
      size: size ?? const Size(1100, 1400),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the KPI tiles and the first page of rows', (tester) async {
    await pumpPage(tester);

    expect(find.text('Bookings today'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('£408.00'), findsOneWidget);
    expect(find.text('TD-1001'), findsOneWidget);
    expect(find.text('Oliver Price'), findsOneWidget);
    expect(find.text('Sarah Jones'), findsOneWidget);
    expect(find.text('Assigned'), findsWidgets);
    // Page size is two, so the third booking waits behind "Load more".
    expect(find.text('TD-1003'), findsNothing);
  });

  testWidgets('a status chip filters on the server', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(TidyChip, 'Completed'));
    await tester.pumpAndSettle();

    expect(repo.calls.last.status, BookingStatus.completed);
    expect(find.text('TD-1004'), findsOneWidget);
    expect(find.text('TD-1001'), findsNothing);

    // Tapping the active chip clears the filter again.
    await tester.tap(find.widgetWithText(TidyChip, 'Completed'));
    await tester.pumpAndSettle();
    expect(repo.calls.last.status, isNull);
    expect(find.text('TD-1001'), findsOneWidget);
  });

  testWidgets('search waits for a pause in typing before asking the API', (
    tester,
  ) async {
    await pumpPage(tester);
    final before = repo.calls.length;

    await tester.enterText(find.byKey(const Key('booking-search')), 'pr');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.enterText(find.byKey(const Key('booking-search')), 'priya');
    await tester.pump(const Duration(milliseconds: 200));
    expect(repo.calls.length, before, reason: 'still inside the debounce');

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(repo.calls.length, before + 1);
    expect(repo.calls.last.query, 'priya');
    expect(find.text('Priya Shah'), findsOneWidget);
    expect(find.text('Emma Wilson'), findsNothing);
  });

  testWidgets('"Load more" fetches the next page with the cursor', (
    tester,
  ) async {
    await pumpPage(tester);
    expect(find.text('Load more'), findsOneWidget);

    await tester.tap(find.text('Load more'));
    await tester.pumpAndSettle();
    expect(repo.calls.last.cursor, '2');
    expect(find.text('TD-1003'), findsOneWidget);
    expect(find.text('TD-1004'), findsOneWidget);

    await tester.tap(find.text('Load more'));
    await tester.pumpAndSettle();
    expect(find.text('TD-1005'), findsOneWidget);
    expect(find.text('Load more'), findsNothing);
  });

  testWidgets('a failed page shows the error and a retry button', (
    tester,
  ) async {
    await pumpPage(tester);
    repo.failNextList = const NetworkException();

    await tester.tap(find.text('Load more'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Cannot reach the server'), findsOneWidget);
    expect(find.text('TD-1001'), findsOneWidget, reason: 'rows are kept');

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('TD-1003'), findsOneWidget);
    expect(find.textContaining('Cannot reach the server'), findsNothing);
  });

  testWidgets('shows an empty state when nothing exists', (tester) async {
    repo = FakeBookingsRepository([]);
    await pumpPage(tester);

    expect(find.text('No bookings found'), findsOneWidget);
    expect(
      find.text('Bookings will show up here as customers place them.'),
      findsOneWidget,
    );
    expect(find.text('Clear filters'), findsNothing);
  });

  testWidgets('an empty filtered list offers to clear the filters', (
    tester,
  ) async {
    repo = FakeBookingsRepository([adminBooking(1)]);
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(TidyChip, 'Cancelled'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing matches these filters.'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('TD-1001'), findsOneWidget);
    expect(repo.calls.last.status, isNull);
  });

  testWidgets('a failed first load shows an error that can be retried', (
    tester,
  ) async {
    repo.failNextList = const ServerException(message: 'boom');
    await pumpPage(tester);

    expect(find.text('Something went wrong'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('TD-1001'), findsOneWidget);
  });

  testWidgets('rows turn into cards on a narrow screen', (tester) async {
    await pumpPage(tester, size: const Size(390, 900));
    expect(find.text('Customer'), findsNothing, reason: 'no table header');
    expect(find.textContaining('Emma Wilson'), findsOneWidget);

    await pumpPage(tester);
    expect(find.text('Customer'), findsOneWidget);
  });
}
