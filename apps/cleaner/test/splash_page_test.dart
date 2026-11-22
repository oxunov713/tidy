import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/auth/presentation/splash_page.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fixtures.dart' as fx;

/// Fails the first start-up check like a phone without a connection, then
/// succeeds.
class _FlakySession extends SessionController {
  static int calls = 0;

  @override
  Future<User?> build() async {
    calls++;
    if (calls == 1) throw const NetworkException();
    return fx.user();
  }
}

void main() {
  testWidgets('offline at launch: splash with a retry, then the session', (
    tester,
  ) async {
    _FlakySession.calls = 0;
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [sessionControllerProvider.overrideWith(_FlakySession.new)],
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return const MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                ...GlobalMaterialLocalizations.delegates,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: SplashPage(),
            );
          },
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(
      find.text('No connection. Check your internet and try again.'),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);
    // The error is not a sign-out.
    expect(container.read(sessionControllerProvider).hasError, isTrue);

    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(_FlakySession.calls, 2);
    expect(container.read(sessionControllerProvider).value?.id, 'me');
  });
}
