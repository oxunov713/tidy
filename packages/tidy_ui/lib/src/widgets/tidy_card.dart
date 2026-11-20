import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';
import 'package:tidy_ui/src/tokens/radii.dart';
import 'package:tidy_ui/src/tokens/spacing.dart';

/// White rounded container with a hairline border. Tappable when [onTap] is set.
class TidyCard extends StatelessWidget {
  const TidyCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(TidySpacing.lg),
    this.highlighted = false,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Draws a primary-coloured border, e.g. for the selected option in a list.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? TidyColors.primarySoft : TidyColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: TidyRadii.cardBorder,
        side: BorderSide(
          color: highlighted ? TidyColors.primary : TidyColors.line,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
