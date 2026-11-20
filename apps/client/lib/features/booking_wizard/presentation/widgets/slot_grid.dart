import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Start times in three columns. Taken times are struck through and cannot be
/// selected.
class SlotGrid extends StatelessWidget {
  const SlotGrid({
    required this.slots,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<Slot> slots;
  final DateTime? selected;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.3,
      children: [
        for (final slot in slots)
          _SlotButton(
            label: formatClock(slot.start),
            available: slot.available,
            selected: slot.start == selected,
            onTap: () => onSelected(slot.start),
          ),
      ],
    );
  }
}

class _SlotButton extends StatelessWidget {
  const _SlotButton({
    required this.label,
    required this.available,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool available;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: !available
          ? const BorderSide(color: TidyColors.line)
          : BorderSide(
              color: selected ? TidyColors.primary : TidyColors.line,
              width: selected ? 2 : 1,
            ),
    );
    return Semantics(
      button: true,
      enabled: available,
      selected: selected,
      label: label,
      child: Material(
        color: !available
            ? TidyColors.surface
            : selected
            ? TidyColors.primarySoft
            : TidyColors.white,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: available ? onTap : null,
          child: ExcludeSemantics(
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: !available
                      ? TidyColors.muted
                      : selected
                      ? TidyColors.primary
                      : TidyColors.ink,
                  decoration: available ? null : TextDecoration.lineThrough,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
