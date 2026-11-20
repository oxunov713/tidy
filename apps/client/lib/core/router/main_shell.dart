import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Scaffold with the bottom navigation shared by the four main tabs.
class MainShell extends StatelessWidget {
  const MainShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: TidyColors.line)),
        ),
        child: BottomNavBar(
          currentIndex: shell.currentIndex,
          // Tapping the active tab again pops it back to its first page.
          onTap: (index) => shell.goBranch(
            index,
            initialLocation: index == shell.currentIndex,
          ),
          items: [
            TidyNavItem(
              label: l10n.navHome,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
            ),
            TidyNavItem(
              label: l10n.navBookings,
              icon: Icons.calendar_month_outlined,
              selectedIcon: Icons.calendar_month,
            ),
            TidyNavItem(
              label: l10n.navChat,
              icon: Icons.chat_bubble_outline,
              selectedIcon: Icons.chat_bubble,
            ),
            TidyNavItem(
              label: l10n.navProfile,
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
            ),
          ],
        ),
      ),
    );
  }
}
