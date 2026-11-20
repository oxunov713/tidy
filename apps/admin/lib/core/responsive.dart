import 'package:material_ui/material_ui.dart';

/// Layout classes of the admin panel: a drawer on phones, a rail on tablets
/// and a full sidebar on desktop.
enum ScreenSize {
  phone,
  tablet,
  desktop;

  static const double tabletMin = 600;
  static const double desktopMin = 1024;

  static ScreenSize fromWidth(double width) {
    if (width >= desktopMin) return desktop;
    if (width >= tabletMin) return tablet;
    return phone;
  }

  static ScreenSize of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);
}

/// Outer padding of a page, so every screen lines up with the top bar.
EdgeInsets pagePadding(BuildContext context) =>
    switch (ScreenSize.of(context)) {
      ScreenSize.phone => const EdgeInsets.fromLTRB(16, 8, 16, 24),
      ScreenSize.tablet => const EdgeInsets.fromLTRB(24, 8, 24, 32),
      ScreenSize.desktop => const EdgeInsets.fromLTRB(32, 12, 32, 40),
    };
