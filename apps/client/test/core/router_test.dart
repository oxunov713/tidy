import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidy_client/core/router/app_router.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/auth/presentation/otp_screen.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/app_harness.dart';
import '../helpers/viewport.dart';

Future<GoRouter> _pump(WidgetTester tester, {required bool signedIn}) async {
  usePhoneScreen(tester);
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final fakes = Fakes(signedOut: !signedIn);
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      ...fakes.overrides,
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  final router = container.read(appRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await _settle(tester);
  return router;
}

/// The code screen runs a resend timer, so `pumpAndSettle` would never end.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

String _location(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.toString();

void main() {
  testWidgets('the code screen takes the phone number from the path', (
    tester,
  ) async {
    final router = await _pump(tester, signedIn: false);
    expect(_location(router), Routes.welcome);

    router.go(Routes.otpFor('+447700900123'));
    await _settle(tester);

    final screen = tester.widget<OtpScreen>(find.byType(OtpScreen));
    expect(screen.phone, '+447700900123');
  });

  testWidgets('a deep link to the code screen works without extra state', (
    tester,
  ) async {
    final router = await _pump(tester, signedIn: false);
    router.go('/otp/%2B447700900123');
    await _settle(tester);
    expect(
      tester.widget<OtpScreen>(find.byType(OtpScreen)).phone,
      '+447700900123',
    );
  });

  testWidgets('a signed-in user is sent past the code screen', (tester) async {
    final router = await _pump(tester, signedIn: true);
    router.go(Routes.otpFor('+447700900123'));
    await _settle(tester);
    expect(_location(router), Routes.home);
  });
}
