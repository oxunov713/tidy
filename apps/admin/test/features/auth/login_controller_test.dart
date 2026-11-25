import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_admin/features/auth/presentation/auth_providers.dart';
import 'package:tidy_admin/features/auth/presentation/login_controller.dart';
import 'package:tidy_core/testing.dart';
import 'package:tidy_core/tidy_core.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  late FakeSessionRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = fakeAdminSession();
    container = makeContainer(fakeRepositories(auth: repo));
  });

  LoginController notifier() =>
      container.read(loginControllerProvider.notifier);
  LoginState state() => container.read(loginControllerProvider);

  test('normalisePhone accepts spaces and rejects local numbers', () {
    expect(normalisePhone('+44 7700 900001'), '+447700900001');
    expect(normalisePhone('+44 (7700) 900-001'), '+447700900001');
    expect(normalisePhone('07700900001'), isNull);
    expect(normalisePhone('+12'), isNull);
    expect(normalisePhone(''), isNull);
  });

  test('a malformed number is not sent', () async {
    expect(await notifier().requestCode('07700 900001'), isFalse);
    expect(repo.requestedPhones, isEmpty);
    expect(state().step, LoginStep.phone);
  });

  test('asking for a code moves to the code step', () async {
    expect(await notifier().requestCode('+44 7700 900001'), isTrue);
    expect(repo.requestedPhones, ['+447700900001']);
    expect(state().step, LoginStep.code);
    expect(state().phone, '+447700900001');
  });

  test('a rate limit stays on the phone step with the error', () async {
    repo.requestOtpError = const TooManyRequestsException(message: 'slow down');
    expect(await notifier().requestCode('+447700900001'), isFalse);
    expect(state().step, LoginStep.phone);
    expect(state().error, isA<TooManyRequestsException>());
    expect(state().busy, isFalse);
  });

  test('an admin code signs in', () async {
    container.listen(authControllerProvider, (_, _) {});
    await container.read(authControllerProvider.future);
    await notifier().requestCode('+447700900001');
    await notifier().verify('123456');

    expect(container.read(authControllerProvider).value?.role, UserRole.admin);
  });

  test('a non-admin account is refused and stays signed out', () async {
    container.listen(authControllerProvider, (_, _) {});
    await container.read(authControllerProvider.future);
    repo.verifyError = const WrongRoleException(
      expected: UserRole.admin,
      actual: UserRole.cleaner,
    );
    await notifier().requestCode('+447700900101');
    await notifier().verify('123456');

    expect(state().error, isA<WrongRoleException>());
    expect(state().busy, isFalse);
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('changing the number goes back to the first step', () async {
    await notifier().requestCode('+447700900001');
    notifier().changePhone();
    expect(state().step, LoginStep.phone);
    expect(state().error, isNull);
  });
}
