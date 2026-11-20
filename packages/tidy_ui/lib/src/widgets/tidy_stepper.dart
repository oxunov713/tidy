import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';

/// "− 2 +" counter, e.g. for bedrooms. Buttons disable at [min] and [max].
class TidyStepper extends StatelessWidget {
  const TidyStepper({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    super.key,
  }) : assert(min <= max, 'min must not exceed max');

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: Icons.remove,
          tooltip: 'Decrease',
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 44,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _StepButton(
          icon: Icons.add,
          tooltip: 'Increase',
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        foregroundColor: TidyColors.primary,
        disabledForegroundColor: TidyColors.muted.withValues(alpha: 0.5),
        side: const BorderSide(color: TidyColors.line),
        fixedSize: const Size(40, 40),
      ),
    );
  }
}
