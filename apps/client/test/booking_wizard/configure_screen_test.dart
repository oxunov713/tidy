import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_controller.dart';
import 'package:tidy_client/features/booking_wizard/presentation/configure_screen.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

import '../helpers/app_harness.dart';
import '../helpers/fixtures.dart' as fx;
import '../helpers/viewport.dart';

void main() {
  late Fakes fakes;

  Future<BookingWizard> openConfigure(WidgetTester tester) async {
    usePhoneScreen(tester);
    fakes = Fakes();
    await pumpScreen(
      tester,
      const ConfigureScreen(),
      fakes,
      extraRoutes: ['/book/schedule'],
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ConfigureScreen)),
    );
    final wizard = container.read(bookingWizardProvider.notifier)
      ..start(fx.standard);
    await tester.pumpAndSettle();
    return wizard;
  }

  testWidgets('shows the service, the defaults, extras with prices and total', (
    tester,
  ) async {
    await openConfigure(tester);

    expect(find.text('Step 1 of 3'.toUpperCase()), findsOneWidget);
    expect(find.text('Standard clean'), findsOneWidget);
    expect(find.text('Bedrooms'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Inside oven · +£20.00'), findsOneWidget);
    expect(find.text('Fridge · +£15.00'), findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
    expect(find.text('£65.00'), findsOneWidget);
    expect(find.text('Total · 2.5 h'), findsOneWidget);
  });

  testWidgets('the total shimmers while a new quote loads, then updates', (
    tester,
  ) async {
    await openConfigure(tester);
    final pending = Completer<Quote>();
    fakes.bookings.onQuote = (_) => pending.future;

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();
    await tester.pump();

    expect(find.text('3'), findsOneWidget);
    expect(find.byKey(const ValueKey('total-loading')), findsOneWidget);
    expect(find.byType(Shimmer), findsWidgets);
    expect(find.text('£65.00'), findsNothing);
    // Can not move on with a stale price.
    final button = tester.widget<TidyButton>(find.byType(TidyButton));
    expect(button.onPressed, isNull);

    pending.complete(fx.quoteFor(total: 7500, minutes: 180));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('total-loading')), findsNothing);
    expect(find.text('£75.00'), findsOneWidget);
    expect(find.text('Total · 3 h'), findsOneWidget);
    expect(
      tester.widget<TidyButton>(find.byType(TidyButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('extras and frequency are sent with the next quote request', (
    tester,
  ) async {
    await openConfigure(tester);
    fakes.bookings.quoteRequests.clear();

    await tester.tap(find.text('Inside oven · +£20.00'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Weekly'));
    await tester.pumpAndSettle();

    final last = fakes.bookings.quoteRequests.last;
    expect(last.extraIds, [fx.oven.id]);
    expect(last.frequency, Frequency.weekly);
  });

  testWidgets('minus is disabled at one bathroom', (tester) async {
    await openConfigure(tester);

    final minus = find.byIcon(Icons.remove).last;
    await tester.tap(minus);
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('a failed quote shows the error and a retry', (tester) async {
    final wizard = await openConfigure(tester);
    fakes.bookings.onQuote = (_) => Future.error(const NetworkException());
    wizard.retryQuote();
    await tester.pumpAndSettle();

    expect(find.text('Try again'), findsOneWidget);

    fakes.bookings.onQuote = (_) async => fx.quoteFor();
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('£68.00'), findsOneWidget);
  });

  testWidgets('Choose time continues to the schedule step', (tester) async {
    await openConfigure(tester);

    await tester.tap(find.text('Choose time'));
    await tester.pumpAndSettle();

    expect(find.text('page:/book/schedule'), findsOneWidget);
  });
}
