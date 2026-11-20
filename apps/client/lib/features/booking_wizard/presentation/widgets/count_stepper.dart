import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// "−  2  +" with the 44 px buttons from the design: an outlined minus and a
/// soft green plus.
class CountStepper extends StatelessWidget {
  const CountStepper({
    required this.value,
    required this.onChanged,
    required this.decreaseLabel,
    required this.increaseLabel,
    this.min = 1,
    this.max = 6,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final String decreaseLabel;
  final String increaseLabel;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Button(
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
        _Button(
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

class _Button extends StatelessWidget {
  const _Button({
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
