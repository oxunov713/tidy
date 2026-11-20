import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';
import 'package:tidy_ui/src/tokens/radii.dart';

enum TidyButtonVariant { primary, secondary, ghost }

/// Full-width-capable button with a loading state.
///
/// While [isLoading] is true the button shows a spinner and ignores taps, but
/// keeps its size so the layout does not jump.
class TidyButton extends StatelessWidget {
  const TidyButton({
    required this.label,
    required this.onPressed,
    this.variant = TidyButtonVariant.primary,
    this.isLoading = false,
    this.expand = true,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final TidyButtonVariant variant;
  final bool isLoading;
  final bool expand;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final (background, foreground, border) = switch (variant) {
      TidyButtonVariant.primary => (
        TidyColors.primary,
        TidyColors.white,
        Colors.transparent,
      ),
      TidyButtonVariant.secondary => (
        TidyColors.primarySoft,
        TidyColors.primary,
        Colors.transparent,
      ),
      TidyButtonVariant.ghost => (
        Colors.transparent,
        TidyColors.primary,
        TidyColors.line,
      ),
    };

    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(64, 52)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20),
      ),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: TidyRadii.controlBorder,
          side: BorderSide(color: border),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) && !isLoading
            ? TidyColors.line
            : background,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) && !isLoading
            ? TidyColors.muted
            : foreground,
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );

    final content = Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLoading ? 0 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
        if (isLoading)
          SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: foreground,
              semanticsLabel: 'Loading',
            ),
          ),
      ],
    );

    final button = FilledButton(
      onPressed: enabled ? onPressed : null,
      style: style,
      child: content,
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
