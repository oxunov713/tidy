import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/features/shell/presentation/offer_alert_host.dart';
import 'package:tidy_cleaner/features/shell/presentation/realtime_connection.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Bottom navigation around the four tabs, plus everything that has to run
/// while the cleaner is signed in: the socket and the offer alerts.
class ShellPage extends ConsumerWidget {
  const ShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(realtimeConnectionProvider);
    final l10n = AppLocalizations.of(context);
    return OfferAlertHost(
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (i) => navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          ),
          items: [
            TidyNavItem(
              label: l10n.navJobs,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
            ),
            TidyNavItem(
              label: l10n.navSchedule,
              icon: Icons.calendar_month_outlined,
              selectedIcon: Icons.calendar_month,
            ),
            TidyNavItem(
              label: l10n.navEarnings,
              icon: Icons.bar_chart_outlined,
              selectedIcon: Icons.bar_chart_rounded,
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
