import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/features/bookings/presentation/booking_detail_view.dart';
import 'package:tidy_core/tidy_core.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(setUpFonts);

  Future<FakeBookingsRepository> open(
    WidgetTester tester,
    BookingStatus status, {
    bool withCleaner = false,
  }) async {
    final repo = FakeBookingsRepository([
      adminBooking(
        1,
        status: status,
        cleaner: withCleaner ? 'Sarah Jones' : '',
      ),
    ]);
    await pumpApp(
      tester,
      BookingDetailView(id: 'b1', onClose: () {}),
      overrides: fakeRepositories(bookings: repo),
    );
    await tester.pumpAndSettle();
    return repo;
  }

  final reassign = find.text('Reassign cleaner', skipOffstage: false);
  final assign = find.text('Assign cleaner', skipOffstage: false);
  final cancel = find.text('Cancel booking', skipOffstage: false);

  for (final (status, canReassign, canCancel) in [
    (BookingStatus.pending, false, true),
    (BookingStatus.confirmed, true, true),
    (BookingStatus.assigned, true, true),
    (BookingStatus.onTheWay, false, false),
    (BookingStatus.inProgress, false, false),
    (BookingStatus.completed, false, false),
    (BookingStatus.cancelled, false, false),
  ]) {
    testWidgets('${status.wireName}: reassign=$canReassign cancel=$canCancel', (
      tester,
    ) async {
      await open(tester, status, withCleaner: true);
      expect(
        reassign.evaluate().isNotEmpty || assign.evaluate().isNotEmpty,
        canReassign,
      );
      expect(cancel.evaluate().isNotEmpty, canCancel);
    });
  }

  testWidgets('a refused cancel shows the server message, not a generic one', (
    tester,
  ) async {
    final repo = await open(tester, BookingStatus.confirmed);
    repo.cancelError = const InvalidTransitionException(
      message: "A completed booking can't be cancelled.",
    );

    await tester.tap(cancel.first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(InkWell, 'Cancel booking').last);
    await tester.pumpAndSettle();

    expect(
      find.text("A completed booking can't be cancelled."),
      findsOneWidget,
    );
    expect(find.textContaining('not possible any more'), findsNothing);
  });

  testWidgets('the rules match the shared enum', (tester) async {
    // The widget uses BookingStatus.canReassign / canCancel; a new status
    // must be decided there once, for the admin and the client app.
    expect(BookingStatus.pending.canReassign, isFalse);
    expect(BookingStatus.pending.canCancel, isTrue);
  });
}
