import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/features/auth/presentation/login_page.dart';
import 'package:tidy_core/testing.dart';
import 'package:tidy_core/tidy_core.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(setUpFonts);

  Future<void> signIn(WidgetTester tester, FakeSessionRepository repo) async {
    await pumpApp(
      tester,
      const LoginPage(),
      overrides: fakeRepositories(auth: repo),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('phone-field')),
      '+447700900101',
    );
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('code-field')), '123456');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
  }

  testWidgets('a non-admin account sees the no-access message', (tester) async {
    final repo = fakeAdminSession()
      ..verifyError = const WrongRoleException(
        expected: UserRole.admin,
        actual: UserRole.cleaner,
      );
    await signIn(tester, repo);

    expect(find.text('This account has no admin access.'), findsOneWidget);
    expect(find.byKey(const Key('code-field')), findsOneWidget);
  });

  testWidgets('a bad phone number is flagged before anything is sent', (
    tester,
  ) async {
    final repo = fakeAdminSession();
    await pumpApp(
      tester,
      const LoginPage(),
      overrides: fakeRepositories(auth: repo),
    );
    await tester.enterText(find.byKey(const Key('phone-field')), '07700');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();

    expect(find.textContaining('international format'), findsOneWidget);
    expect(repo.requestedPhones, isEmpty);
  });

  testWidgets('API errors from the code request are shown inline', (
    tester,
  ) async {
    final repo = fakeAdminSession()
      ..requestOtpError = const TooManyRequestsException(message: 'slow');
    await pumpApp(
      tester,
      const LoginPage(),
      overrides: fakeRepositories(auth: repo),
    );
    await tester.enterText(
      find.byKey(const Key('phone-field')),
      '+447700900001',
    );
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Too many attempts'), findsOneWidget);
  });
}
