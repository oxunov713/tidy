import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';
import 'package:tidy_ui/src/tokens/radii.dart';

/// Builds the Material 3 theme used by every Tidy app.
abstract final class TidyTheme {
  static ThemeData light() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: TidyColors.primary,
        ).copyWith(
          primary: TidyColors.primary,
          onPrimary: TidyColors.white,
          primaryContainer: TidyColors.primarySoft,
          onPrimaryContainer: TidyColors.primary,
          secondary: TidyColors.accent,
          onSecondary: TidyColors.ink,
          surface: TidyColors.white,
          onSurface: TidyColors.ink,
          onSurfaceVariant: TidyColors.muted,
          surfaceContainerLow: TidyColors.surface,
          surfaceContainer: TidyColors.surface,
          outline: TidyColors.line,
          outlineVariant: TidyColors.line,
          error: TidyColors.danger,
        );

    final body = GoogleFonts.interTextTheme();
    final textTheme = body
        .copyWith(
          displayLarge: _heading(32),
          displayMedium: _heading(28),
          displaySmall: _heading(24),
          headlineLarge: _heading(28),
          headlineMedium: _heading(24),
          headlineSmall: _heading(20),
          titleLarge: _heading(20),
          titleMedium: body.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          titleSmall: body.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        )
        .apply(bodyColor: TidyColors.ink, displayColor: TidyColors.ink);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: TidyColors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: TidyColors.surface,
        foregroundColor: TidyColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: _heading(20).copyWith(color: TidyColors.ink),
      ),
      cardTheme: const CardThemeData(
        color: TidyColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: TidyRadii.cardBorder,
          side: BorderSide(color: TidyColors.line),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: TidyColors.line,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: TidyColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: TidyRadii.controlBorder,
          borderSide: BorderSide(color: TidyColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: TidyRadii.controlBorder,
          borderSide: BorderSide(color: TidyColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: TidyRadii.controlBorder,
          borderSide: BorderSide(color: TidyColors.primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: TidyColors.white,
        indicatorColor: TidyColors.primarySoft,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? TidyColors.primary
                : TidyColors.muted,
          ),
        ),
      ),
    );
  }

  static TextStyle _heading(double size) => GoogleFonts.spaceGrotesk(
    fontSize: size,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.2,
  );
}
