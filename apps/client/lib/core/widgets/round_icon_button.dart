import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// The 44 px square button with a hairline border used for back, close and
/// notification buttons in the design.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.filled = false,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  /// White fill without a border, for buttons floating over a map.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? TidyColors.white : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: filled
            ? BorderSide.none
            : const BorderSide(color: TidyColors.line),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: SizedBox.square(
            dimension: 44,
            child: Icon(icon, size: 20, color: TidyColors.ink),
          ),
        ),
      ),
    );
  }
}
