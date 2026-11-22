import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_ui/tidy_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('light theme uses the design tokens', () {
    final theme = TidyTheme.light();
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, TidyColors.primary);
    expect(theme.scaffoldBackgroundColor, TidyColors.surface);
    expect(theme.textTheme.bodyMedium?.fontFamily, TidyFonts.body);
    expect(theme.textTheme.headlineMedium?.fontFamily, TidyFonts.heading);
  });
}
