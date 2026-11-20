import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_controller.dart';
import 'package:tidy_client/features/home/presentation/home_screen.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';
import '../helpers/fixtures.dart' as fx;
import '../helpers/viewport.dart';

void main() {
  testWidgets('greets the user and shows every service as a card', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await pumpScreen(tester, const HomeScreen(), Fakes());
    await tester.pumpAndSettle();

    expect(find.text('Hi Emma, what needs a clean today?'), findsOneWidget);
    expect(find.text('14 Baker Street, London'), findsOneWidget);
    expect(find.text('Standard clean'), findsOneWidget);
    expect(find.text('Deep clean'), findsOneWidget);
    expect(find.text('£45.00'), findsOneWidget);
    expect(find.text('£89.00'), findsOneWidget);
    expect(find.text('MOST BOOKED'), findsOneWidget);
    expect(find.text('PREMIUM'), findsOneWidget);
    expect(find.text('2–3 h'), findsOneWidget);
  });

  testWidgets('tapping a card starts the wizard and opens Configure', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await pumpScreen(
      tester,
      const HomeScreen(),
      Fakes(),
      extraRoutes: ['/book/configure'],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Deep clean'));
    await tester.pumpAndSettle();

    expect(find.text('page:/book/configure'), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.text('page:/book/configure')),
    );
    expect(container.read(bookingWizardProvider).service?.slug, 'deep');
  });

  testWidgets('shows skeleton cards while services load', (tester) async {
    usePhoneScreen(tester);
    await pumpScreen(tester, const HomeScreen(), Fakes());
    // First frame: nothing has resolved yet.
    expect(find.text('Standard clean'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('Standard clean'), findsOneWidget);
  });

  testWidgets('shows an error with retry when services fail to load', (
    tester,
  ) async {
    usePhoneScreen(tester);
    final fakes = Fakes(catalog: FakeCatalogRepositoryFailing());
    await pumpScreen(tester, const HomeScreen(), fakes);
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(
      find.text('No connection. Check your internet and try again.'),
      findsOneWidget,
    );

    fakes.catalog.failServices = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Standard clean'), findsOneWidget);
    expect(find.text('Something went wrong'), findsNothing);
  });

  testWidgets('shows an empty state when there are no services', (
    tester,
  ) async {
    usePhoneScreen(tester);
    final fakes = Fakes(catalog: FakeCatalogRepository(serviceList: const []));
    await pumpScreen(tester, const HomeScreen(), fakes);
    await tester.pumpAndSettle();

    expect(find.text('No services available'), findsOneWidget);
  });

  testWidgets('shows the current booking when a cleaner is on the way', (
    tester,
  ) async {
    usePhoneScreen(tester);
    final active = fx.booking(
      status: BookingStatus.onTheWay,
      cleanerId: 'cl-1',
    );
    final bookings = FakeBookingRepository()
      ..pages[BookingScope.upcoming] = [
        BookingPage(items: [active]),
      ]
      ..detailsById = {
        active.id: BookingDetails(
          booking: active,
          address: fx.home,
          cleaner: const CleanerCard(
            id: 'cl-1',
            fullName: 'Sarah Jones',
            rating: 4.9,
            ratingCount: 212,
          ),
        ),
      };
    await pumpScreen(
      tester,
      const HomeScreen(),
      Fakes(bookings: bookings),
      extraRoutes: ['/booking/:id/track'],
    );
    await tester.pumpAndSettle();

    expect(find.text('Sarah is on the way'), findsOneWidget);
    expect(find.textContaining('Standard clean ·'), findsOneWidget);
  });

  testWidgets('hides the current booking card when nothing is active', (
    tester,
  ) async {
    usePhoneScreen(tester);
    final upcoming = fx.booking();
    final bookings = FakeBookingRepository()
      ..pages[BookingScope.upcoming] = [
        BookingPage(items: [upcoming]),
      ];
    await pumpScreen(tester, const HomeScreen(), Fakes(bookings: bookings));
    await tester.pumpAndSettle();

    expect(find.textContaining('is on the way'), findsNothing);
  });
}

class FakeCatalogRepositoryFailing extends FakeCatalogRepository {
  FakeCatalogRepositoryFailing() : super(failServices: true);
}
