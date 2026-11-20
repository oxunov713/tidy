import 'package:material_ui/material_ui.dart';

class TidyNavItem {
  const TidyNavItem({
    required this.label,
    required this.icon,
    IconData? selectedIcon,
  }) : selectedIcon = selectedIcon ?? icon;

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Thin wrapper over [NavigationBar]; styling comes from `TidyTheme`.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  }) : assert(items.length >= 2, 'A navigation bar needs at least 2 items');

  final List<TidyNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          ),
      ],
    );
  }
}
