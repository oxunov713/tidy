import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/bookings/presentation/booking_details_screen.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_screen.dart';
import 'package:tidy_client/features/bookings/presentation/stuck_cancellation.dart';
import 'package:tidy_client/features/payment/domain/payment_sheet.dart';
import 'package:tidy_client/features/payment/presentation/mock_payment_sheet.dart';
import 'package:tidy_client/features/payment/presentation/pay_booking.dart';
import 'package:tidy_client/features/payment/presentation/payment_providers.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';
import '../helpers/fixtures.dart' as fx;
import '../helpers/viewport.dart';

class _RecordingSheet implements PaymentSheet {
  _RecordingSheet([this.outcome = PaymentOutcome.paid]);

  final PaymentOutcome outcome;
  final requests = <PaymentRequest>[];
  Exception? failure;

  @override
  bool get isMock => true;

  @override
  Future<PaymentOutcome> present(
    BuildContext context,
    PaymentRequest request,
  ) async {
    requests.add(request);
    if (failure != null) throw failure!;
    return outcome;
  }
}

BookingEvent _event(BookingStatus status, {String? actor}) => BookingEvent(
  status: status,
  at: DateTime.utc(2026, 12, 2, 9),
  actorId: actor,
);

void main() {
  group('mock payment sheet', () {
    Future<PaymentOutcome?> open(
      WidgetTester tester,
      PaymentKind kind, {
      String card = '4242 4242 4242 4242',
    }) async {
      usePhoneScreen(tester);
      PaymentOutcome? result;
      await pumpScreen(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result =
                  await const MockPaymentSheet(
                    processingTime: Duration(milliseconds: 10),
                  ).present(
                    context,
                    PaymentRequest(
                      clientSecret: 's',
                      amountPence: 6800,
                      bookingCode: 'TD-1',
                      kind: kind,
                    ),
                  );
            },
            child: const Text('open'),
          ),
        ),
        Fakes(),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      if (card != '4242 4242 4242 4242') {
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Card number'),
          card,
        );
      }
      return result;
    }

    testWidgets('a payment asks for the amount', (tester) async {
      await open(tester, PaymentKind.payment);
      expect(find.text('Pay £68.00'), findsNWidgets(2));
      expect(find.text('Save card'), findsNothing);
    });

    testWidgets('a setup only saves the card and says when it is charged', (
      tester,
    ) async {
      await open(tester, PaymentKind.setup);
      expect(find.text('Save your card'), findsOneWidget);
      expect(find.text('Save card'), findsOneWidget);
      expect(
        find.text("You'll be charged 48 h before the visit."),
        findsOneWidget,
      );
      expect(find.text('Pay £68.00'), findsNothing);
    });

    testWidgets('a declined card shows the error and the sheet stays open', (
      tester,
    ) async {
      await open(tester, PaymentKind.payment, card: '4000 0000 0000 0002');
      await tester.tap(find.byKey(const Key('paymentSubmit')));
      await tester.pumpAndSettle();

      expect(find.textContaining('card was declined'), findsOneWidget);
      expect(find.byKey(const Key('paymentSubmit')), findsOneWidget);

      // Another card in the same sheet goes through.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Card number'),
        '4242 4242 4242 4242',
      );
      await tester.tap(find.byKey(const Key('paymentSubmit')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('paymentSubmit')), findsNothing);
    });
  });

  group('Pay now', () {
    late FakeBookingRepository repo;
    late _RecordingSheet sheet;

    Booking pending({DateTime? createdAt, DateTime? start}) => fx
        .booking(id: 'p1', status: BookingStatus.pending, start: start)
        .copyWith(createdAt: createdAt ?? DateTime.utc(2026, 12, 3, 8, 50));

    Future<void> openList(
      WidgetTester tester,
      Booking booking, {
      PaymentOutcome outcome = PaymentOutcome.paid,
    }) async {
      usePhoneScreen(tester);
      repo = FakeBookingRepository()
        ..pages[BookingScope.upcoming] = [
          BookingPage(items: [booking]),
        ];
      sheet = _RecordingSheet(outcome);
      await pumpScreen(
        tester,
        const BookingsScreen(),
        Fakes(bookings: repo),
        extraRoutes: ['/booking/:id'],
        extraOverrides: [paymentSheetProvider.overrideWithValue(sheet)],
      );
      await tester.pumpAndSettle();
    }

    testWidgets('a pending booking offers Pay now in the list', (tester) async {
      await openList(tester, pending());
      expect(find.text('Pay now'), findsOneWidget);

      await tester.tap(find.byKey(const Key('payNow')));
      await tester.pumpAndSettle();

      expect(repo.payCalls, ['p1']);
      expect(sheet.requests.single.clientSecret, 'pay-secret');
      expect(sheet.requests.single.kind, PaymentKind.payment);
      expect(sheet.requests.single.amountPence, 6800);
    });

    testWidgets('a rejected request (not pending any more) shows the message', (
      tester,
    ) async {
      await openList(tester, pending());
      repo.payError = const InvalidTransitionException(
        message: 'This booking is already paid.',
      );
      await tester.tap(find.byKey(const Key('payNow')));
      await tester.pumpAndSettle();

      expect(sheet.requests, isEmpty);
      expect(find.text('This booking is already paid.'), findsOneWidget);
    });

    testWidgets('a failed payment keeps the booking and says so', (
      tester,
    ) async {
      await openList(tester, pending());
      sheet.failure = const PaymentFailure('Your bank said no.');
      await tester.tap(find.byKey(const Key('payNow')));
      await tester.pumpAndSettle();

      expect(find.text('Your bank said no.'), findsOneWidget);
      expect(repo.cancelCalls, isEmpty);
    });

    testWidgets('closing the sheet leaves the booking pending', (tester) async {
      await openList(tester, pending(), outcome: PaymentOutcome.cancelled);
      await tester.tap(find.byKey(const Key('payNow')));
      await tester.pumpAndSettle();

      expect(sheet.requests, hasLength(1));
      expect(repo.cancelCalls, isEmpty);
      expect(find.byKey(const Key('payNow')), findsOneWidget);
    });

    testWidgets('the details screen shows Pay now with the 30 minute hint', (
      tester,
    ) async {
      usePhoneScreen(tester);
      final booking = pending();
      repo = FakeBookingRepository()
        ..detailsById = {
          booking.id: BookingDetails(booking: booking, address: fx.home),
        };
      sheet = _RecordingSheet();
      await pumpScreen(
        tester,
        BookingDetailsScreen(bookingId: booking.id),
        Fakes(bookings: repo),
        extraOverrides: [paymentSheetProvider.overrideWithValue(sheet)],
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('payNow')), findsOneWidget);
      expect(
        find.text('Pay within 30 minutes or the booking is cancelled.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.byKey(const Key('payNow')));
      await tester.tap(find.byKey(const Key('payNow')));
      await tester.pumpAndSettle();
      expect(repo.payCalls, ['p1']);
    });

    test('the warning is only right when the booking can really expire', () {
      final now = DateTime.utc(2026, 12, 3, 9);
      bool expires({required Duration created, required Duration startIn}) =>
          unpaidBookingExpires(
            fx
                .booking(
                  status: BookingStatus.pending,
                  start: now.add(startIn),
                )
                .copyWith(createdAt: now.subtract(created)),
            now,
          );

      // Just booked, payment asked for now.
      expect(
        expires(
          created: const Duration(minutes: 5),
          startIn: const Duration(days: 9),
        ),
        isTrue,
      );
      // Card saved a week ago and waiting for the 48 h charge: no timeout.
      expect(
        expires(
          created: const Duration(days: 7),
          startIn: const Duration(days: 9),
        ),
        isFalse,
      );
      // The charge window has begun and the booking is still pending.
      expect(
        expires(
          created: const Duration(days: 7),
          startIn: const Duration(hours: 30),
        ),
        isTrue,
      );
      expect(
        unpaidBookingExpires(
          fx.booking().copyWith(createdAt: now),
          now,
        ),
        isFalse,
        reason: 'only pending bookings expire',
      );
    });
  });

  group('stuck booking message', () {
    BookingDetails cancelled(List<BookingEvent> events, {String? cleaner}) =>
        BookingDetails(
          booking: fx.booking(
            status: BookingStatus.cancelled,
            cleanerId: cleaner,
          ),
          address: fx.home,
          events: events,
        );

    test('never confirmed and cancelled by the system: not paid in time', () {
      final details = cancelled([
        _event(BookingStatus.pending),
        _event(BookingStatus.cancelled),
      ]);
      expect(stuckCancellationOf(details), StuckCancellation.unpaid);
    });

    test(
      'confirmed, no cleaner, cancelled by the system: no cleaner found',
      () {
        final details = cancelled([
          _event(BookingStatus.pending),
          _event(BookingStatus.confirmed),
          _event(BookingStatus.cancelled),
        ]);
        expect(stuckCancellationOf(details), StuckCancellation.noCleaner);
      },
    );

    test('a cancellation by the client or an admin is not a stuck one', () {
      final byClient = cancelled([
        _event(BookingStatus.pending),
        _event(BookingStatus.cancelled, actor: 'user-1'),
      ]);
      expect(stuckCancellationOf(byClient), isNull);
    });

    test('bookings that are not cancelled have no such message', () {
      final active = BookingDetails(
        booking: fx.booking(),
        address: fx.home,
        events: [_event(BookingStatus.pending)],
      );
      expect(stuckCancellationOf(active), isNull);
    });

    testWidgets('the details screen explains an unpaid cancellation', (
      tester,
    ) async {
      usePhoneScreen(tester);
      final details = cancelled([
        _event(BookingStatus.pending),
        _event(BookingStatus.cancelled),
      ]);
      await pumpScreen(
        tester,
        BookingDetailsScreen(bookingId: details.booking.id),
        Fakes(
          bookings: FakeBookingRepository()
            ..detailsById = {details.booking.id: details},
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          "This booking was cancelled because it wasn't paid within 30 minutes.",
        ),
        findsOneWidget,
      );
    });

    testWidgets('and one for a missing cleaner', (tester) async {
      usePhoneScreen(tester);
      final details = cancelled([
        _event(BookingStatus.pending),
        _event(BookingStatus.confirmed),
        _event(BookingStatus.cancelled),
      ]);
      await pumpScreen(
        tester,
        BookingDetailsScreen(bookingId: details.booking.id),
        Fakes(
          bookings: FakeBookingRepository()
            ..detailsById = {details.booking.id: details},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('stuckNotice')), findsOneWidget);
      expect(find.textContaining('no cleaner could take it'), findsOneWidget);
    });
  });
}
