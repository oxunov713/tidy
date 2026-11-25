import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidy_client/core/providers/map_factory.dart';
import 'package:tidy_client/features/addresses/presentation/address_providers.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_controller.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_state.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/catalog/presentation/catalog_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/testing.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

import 'fakes.dart';

/// Fakes shared by the tests, so each test only sets what it cares about.
class Fakes {
  Fakes({
    FakeCatalogRepository? catalog,
    FakeAddressRepository? addresses,
    FakeBookingRepository? bookings,
    FakeRealtimeClient? realtime,
  }) : realtime = realtime ?? FakeRealtimeClient(),
       catalog = catalog ?? FakeCatalogRepository(),
       addresses = addresses ?? FakeAddressRepository(),
       bookings = bookings ?? FakeBookingRepository();

  final FakeCatalogRepository catalog;
  final FakeAddressRepository addresses;
  final FakeBookingRepository bookings;
  final FakeRealtimeClient realtime;

  List<Override> get overrides => [
    realtimeClientProvider.overrideWithValue(realtime),
    catalogRepositoryProvider.overrideWithValue(catalog),
    addressRepositoryProvider.overrideWithValue(addresses),
    bookingRepositoryProvider.overrideWithValue(bookings),
    authControllerProvider.overrideWith(FakeAuthController.new),
    mapFactoryProvider.overrideWithValue(
      ({zoom = 15}) => const FakeMapProvider(),
    ),
  ];
}

Future<ProviderContainer> makeContainer(
  Fakes fakes, {
  Duration debounce = Duration.zero,
  DateTime Function()? now,
  List<Override> extra = const [],
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      ...fakes.overrides,
      sharedPreferencesProvider.overrideWithValue(prefs),
      quoteDebounceProvider.overrideWithValue(debounce),
      if (now != null) clockProvider.overrideWithValue(now),
      ...extra,
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Pumps [child] at `/` of a small router, with placeholder pages for the
/// routes a tap may navigate to.
Future<GoRouter> pumpScreen(
  WidgetTester tester,
  Widget child,
  Fakes fakes, {
  List<String> extraRoutes = const [],
  List<Override> extraOverrides = const [],
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(body: child),
      ),
      for (final path in extraRoutes)
        GoRoute(
          path: path,
          builder: (_, _) => Scaffold(body: Text('page:$path')),
        ),
    ],
  );
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      ...fakes.overrides,
      sharedPreferencesProvider.overrideWithValue(prefs),
      quoteDebounceProvider.overrideWithValue(Duration.zero),
      ...extraOverrides,
    ],
  );
  addTearDown(container.dispose);
  // Screens only exist for a signed-in user, so resolve that first; otherwise
  // user-scoped providers would load twice.
  await container.read(authControllerProvider.future);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: TidyTheme.light(),
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  return router;
}

/// Short handle on the wizard inside a container.
class ProviderContainerLike {
  ProviderContainerLike(this.container);

  final ProviderContainer container;

  BookingWizard get notifier => container.read(bookingWizardProvider.notifier);
  BookingWizardState get state => container.read(bookingWizardProvider);

  /// Lets pending futures and zero-length timers run.
  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 10));
}
