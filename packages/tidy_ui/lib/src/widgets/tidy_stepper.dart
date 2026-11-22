import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';

/// "−  2  +" with 44 px buttons: an outlined minus and a soft green plus.
/// Buttons disable at [min] and [max].
///
/// [decreaseLabel] and [increaseLabel] are the screen reader names of the
/// buttons; pass translated ones from a localised app.
class TidyStepper extends StatelessWidget {
  const TidyStepper({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.decreaseLabel = 'Decrease',
    this.increaseLabel = 'Increase',
    super.key,
  }) : assert(min <= max, 'min must not exceed max');

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String decreaseLabel;
  final String increaseLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: Icons.remove,
          label: decreaseLabel,
          background: TidyColors.white,
          foreground: TidyColors.ink,
          bordered: true,
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 46,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          label: increaseLabel,
          background: TidyColors.primarySoft,
          foreground: TidyColors.primary,
          bordered: false,
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.bordered,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final bool bordered;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: bordered
              ? const BorderSide(color: TidyColors.line)
              : BorderSide.none,
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: 44,
            child: ExcludeSemantics(
              child: Icon(
                icon,
                size: 20,
                color: enabled
                    ? foreground
                    : TidyColors.muted.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
