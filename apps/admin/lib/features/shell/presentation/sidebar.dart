import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/features/shell/presentation/destinations.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// The dark navigation column. [collapsed] shows icons only (tablet rail).
class Sidebar extends StatelessWidget {
  const Sidebar({
    required this.selected,
    required this.onSelect,
    this.collapsed = false,
    this.onToggle,
    super.key,
  });

  final AdminDestination selected;
  final ValueChanged<AdminDestination> onSelect;
  final bool collapsed;

  /// Expands or collapses the rail; null hides the toggle (desktop, drawer).
  final VoidCallback? onToggle;

  static Color get _idle => TidyColors.white.withValues(alpha: 0.72);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: TidyColors.ink,
      child: SizedBox(
        width: collapsed ? 76 : 248,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? TidySpacing.md : TidySpacing.lg,
              vertical: TidySpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Logo(collapsed: collapsed),
                const SizedBox(height: TidySpacing.xl),
                for (final d in AdminDestination.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: TidySpacing.xs),
                    child: _NavItem(
                      destination: d,
                      label: d.label(l10n),
                      selected: d == selected,
                      collapsed: collapsed,
                      onTap: () => onSelect(d),
                    ),
                  ),
                const Spacer(),
                if (onToggle != null)
                  IconButton(
                    tooltip: collapsed ? l10n.navExpand : l10n.navCollapse,
                    onPressed: onToggle,
                    color: _idle,
                    icon: Icon(
                      collapsed ? Icons.chevron_right : Icons.chevron_left,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: TidyColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    if (collapsed) return Center(child: mark);
    final style = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(color: TidyColors.white);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TidySpacing.sm),
      child: Row(
        children: [
          mark,
          const SizedBox(width: TidySpacing.sm),
          Flexible(
            child: Text.rich(
              const TextSpan(
                text: 'tidy ',
                children: [
                  TextSpan(
                    text: 'admin',
                    style: TextStyle(color: TidyColors.primarySoft),
                  ),
                ],
              ),
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.label,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final AdminDestination destination;
  final String label;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? TidyColors.white : Sidebar._idle;
    final item = Material(
      color: selected
          ? TidyColors.white.withValues(alpha: 0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TidySpacing.md),
            child: Row(
              mainAxisAlignment: collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  size: 22,
                  color: color,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: TidySpacing.md),
                  Expanded(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: collapsed ? Tooltip(message: label, child: item) : item,
    );
  }
}
