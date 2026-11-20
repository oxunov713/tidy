import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/features/shell/presentation/admin_shell.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(setUpFonts);

  Future<void> pumpShell(WidgetTester tester, Size size) async {
    await pumpApp(
      tester,
      const AdminShell(location: '/bookings', child: SizedBox()),
      overrides: fakeRepositories(
        auth: FakeAuthRepository(restored: adminUser()),
      ),
      size: size,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('desktop shows the full sidebar and the signed-in admin', (
    tester,
  ) async {
    await pumpShell(tester, const Size(1280, 800));
    expect(find.text('Services and prices'), findsOneWidget);
    expect(find.text('Cleaners'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsNothing);
    expect(find.text('Ada Admin'), findsOneWidget);
  });

  testWidgets('tablet starts as a rail that can be expanded', (tester) async {
    await pumpShell(tester, const Size(800, 900));
    expect(find.text('Services and prices'), findsNothing);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.text('Services and prices'), findsOneWidget);
  });

  testWidgets('phone keeps the navigation in a drawer', (tester) async {
    await pumpShell(tester, const Size(390, 800));
    expect(find.text('Services and prices'), findsNothing);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Services and prices'), findsOneWidget);
  });
}
