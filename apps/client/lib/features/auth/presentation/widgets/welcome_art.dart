import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// The illustration on the welcome screen, built from plain boxes like in the
/// design file so it needs no image assets.
class WelcomeArt extends StatelessWidget {
  const WelcomeArt({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 300,
        height: 250,
        decoration: BoxDecoration(
          color: TidyColors.primarySoft,
          borderRadius: BorderRadius.circular(32),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            _box(40, 120, 220, 90, TidyColors.white, radius: 18),
            _box(160, 140, 80, 12, TidyColors.line, radius: 6),
            _box(160, 162, 56, 12, TidyColors.line, radius: 6),
            _box(62, 142, 70, 50, TidyColors.accent, radius: 12),
            Positioned(
              left: 62,
              top: 60,
              child: Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: TidyColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  size: 38,
                  color: TidyColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(
    double left,
    double top,
    double width,
    double height,
    Color color, {
    required double radius,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
