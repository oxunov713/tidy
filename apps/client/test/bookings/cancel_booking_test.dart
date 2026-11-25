import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/bookings/presentation/cancel_booking.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';
import '../helpers/fixtures.dart' as fx;
import '../helpers/viewport.dart';

Future<FakeBookingRepository> _open(
  WidgetTester tester,
  Booking booking,
) async {
  usePhoneScreen(tester);
  final repo = FakeBookingRepository();
  await pumpScreen(
    tester,
    Consumer(
      builder: (context, ref, _) => TextButton(
        onPressed: () => cancelBooking(context, ref, booking),
        child: const Text('open'),
      ),
    ),
    Fakes(bookings: repo),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('a one-off booking has no scope choice', (tester) async {
    final repo = await _open(tester, fx.booking());
    expect(find.byKey(const Key('cancelScopeSeries')), findsNothing);

    await tester.tap(find.byKey(const Key('confirmCancel')));
    await tester.pumpAndSettle();
    expect(repo.cancelCalls, [('bk-1', CancelScope.visit)]);
  });

  testWidgets('a recurring booking cancels only this visit by default', (
    tester,
  ) async {
    final repo = await _open(
      tester,
      fx.booking(frequency: Frequency.weekly, planId: 'plan-1'),
    );
    expect(find.text('This visit only'), findsOneWidget);
    expect(find.text('The whole series'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirmCancel')));
    await tester.pumpAndSettle();
    expect(repo.cancelCalls, [('bk-1', CancelScope.visit)]);
  });

  testWidgets('choosing the whole series sends scope series and says so', (
    tester,
  ) async {
    final repo = await _open(
      tester,
      fx.booking(frequency: Frequency.weekly, planId: 'plan-1'),
    );
    await tester.tap(find.byKey(const Key('cancelScopeSeries')));
    await tester.pumpAndSettle();
    expect(find.textContaining('no new visits are booked'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirmCancel')));
    await tester.pumpAndSettle();

    expect(repo.cancelCalls, [('bk-1', CancelScope.series)]);
    expect(
      find.textContaining('Your recurring clean has ended'),
      findsOneWidget,
    );
  });

  testWidgets('keeping the booking cancels nothing', (tester) async {
    final repo = await _open(tester, fx.booking(planId: 'plan-1'));
    await tester.tap(find.text('Keep booking'));
    await tester.pumpAndSettle();
    expect(repo.cancelCalls, isEmpty);
  });
}
