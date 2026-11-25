import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/testing.dart';
import 'package:tidy_core/tidy_core.dart';

import '../helpers/fixtures.dart' as fx;

ProviderContainer _container(FakeSessionRepository repo) {
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      sessionRepositoryProvider.overrideWithValue(repo),
      realtimeClientProvider.overrideWithValue(FakeRealtimeClient()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('a cleaner account is refused and the user stays signed out', () async {
    final repo = FakeSessionRepository()
      ..verifyError = const WrongRoleException(
        expected: UserRole.client,
        actual: UserRole.cleaner,
      );
    final container = _container(repo)
      ..listen(authControllerProvider, (_, _) {});
    await container.read(authControllerProvider.future);

    await expectLater(
      container
          .read(authControllerProvider.notifier)
          .verify(phone: '+447700900101', code: '123456'),
      throwsA(isA<WrongRoleException>()),
    );
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('the server 403 for a registered number is passed on', () async {
    final repo = FakeSessionRepository()
      ..verifyError = const ForbiddenException(
        message: 'This number is registered as a cleaner.',
      );
    final container = _container(repo)
      ..listen(authControllerProvider, (_, _) {});
    await container.read(authControllerProvider.future);

    await expectLater(
      container
          .read(authControllerProvider.notifier)
          .verify(phone: '+447700900101', code: '123456'),
      throwsA(
        isA<ForbiddenException>().having(
          (e) => e.message,
          'message',
          'This number is registered as a cleaner.',
        ),
      ),
    );
  });

  test(
    'offline at launch is an error state (splash), not a sign-out',
    () async {
      final repo = FakeSessionRepository()
        ..restoreError = const NetworkException();
      final container = _container(repo)
        ..listen(authControllerProvider, (_, _) {});
      await expectLater(
        container.read(authControllerProvider.future),
        throwsA(isA<NetworkException>()),
      );
      expect(container.read(authControllerProvider).hasError, isTrue);

      repo
        ..restoreError = null
        ..restoreResult = fx.user();
      container.invalidate(authControllerProvider);
      final user = await container.read(authControllerProvider.future);
      expect(user?.id, 'user-1');
    },
  );

  test('signing in as a client works and logout ends the session', () async {
    final repo = FakeSessionRepository(verifyResult: fx.user());
    final container = _container(repo)
      ..listen(authControllerProvider, (_, _) {});
    await container.read(authControllerProvider.future);

    await container
        .read(authControllerProvider.notifier)
        .verify(phone: '+447700900201', code: '123456');
    expect(container.read(authControllerProvider).value?.id, 'user-1');

    await container.read(authControllerProvider.notifier).logout();
    expect(repo.logoutCalls, 1);
    expect(container.read(authControllerProvider).value, isNull);
  });

  testWidgets('the wrong-role message tells the user which app to use', (
    tester,
  ) async {
    late String text;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            text = errorMessage(
              context,
              const WrongRoleException(
                expected: UserRole.client,
                actual: UserRole.cleaner,
              ),
            );
            return const SizedBox();
          },
        ),
      ),
    );
    expect(text, contains('cleaner account'));
    expect(text, contains('Tidy Pro'));
  });
}
