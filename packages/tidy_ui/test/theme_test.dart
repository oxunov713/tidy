import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tidy_ui/tidy_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  test('light theme uses the design tokens', () {
    final theme = TidyTheme.light();
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, TidyColors.primary);
    expect(theme.scaffoldBackgroundColor, TidyColors.surface);
  });
}
