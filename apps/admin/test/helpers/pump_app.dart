import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/features/auth/presentation/auth_providers.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_admin/features/cleaners/presentation/cleaners_providers.dart';
import 'package:tidy_admin/features/services/presentation/services_providers.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/testing.dart';
import 'package:tidy_ui/tidy_ui.dart';

import 'fakes.dart';

/// Call once per test file: the theme uses the bundled fonts, which
/// need no network.
void setUpFonts() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

/// Overrides for every repository the panel reads; pass only the fakes a test
/// cares about.
List<Override> fakeRepositories({
  FakeBookingsRepository? bookings,
  FakeCleanersRepository? cleaners,
  FakeServicesRepository? services,
  FakeSessionRepository? auth,
  Duration? statsInterval,
}) => [
  if (bookings != null) bookingsRepositoryProvider.overrideWithValue(bookings),
  if (cleaners != null) cleanersRepositoryProvider.overrideWithValue(cleaners),
  if (services != null) servicesRepositoryProvider.overrideWithValue(services),
  if (auth != null) sessionRepositoryProvider.overrideWithValue(auth),
  if (statsInterval != null)
    statsRefreshIntervalProvider.overrideWithValue(statsInterval),
];

ProviderContainer makeContainer(List<Override> overrides) {
  final container = ProviderContainer(
    overrides: overrides,
    retry: (_, _) => null,
  );
  addTearDown(container.dispose);
  return container;
}

/// Pumps [child] inside the app theme, English strings and a real size.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  Size size = const Size(1100, 1400),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      retry: (_, _) => null,
      child: MaterialApp(
        theme: TidyTheme.light(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    ),
  );
}
