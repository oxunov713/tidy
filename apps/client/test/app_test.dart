import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tidy_client/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('shows the placeholder home in English by default', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TidyClientApp()));
    await tester.pumpAndSettle();
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('uses Russian when the device locale is Russian', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ru')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(const ProviderScope(child: TidyClientApp()));
    await tester.pumpAndSettle();
    expect(find.text('Скоро здесь появится'), findsOneWidget);
  });
}
