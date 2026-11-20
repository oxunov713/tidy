import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';

/// Pill-shaped selectable chip, used for filters, tags and option pickers.
class TidyChip extends StatelessWidget {
  const TidyChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? TidyColors.primary : TidyColors.muted;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? TidyColors.primarySoft : TidyColors.white,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? TidyColors.primary : TidyColors.line,
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onSelected == null ? null : () => onSelected!(!selected),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: foreground),
                  const SizedBox(width: 6),
                ],
                ExcludeSemantics(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: foreground,
                    ),
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
