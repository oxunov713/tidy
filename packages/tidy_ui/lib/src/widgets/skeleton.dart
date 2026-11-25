import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';
import 'package:tidy_ui/src/tokens/radii.dart';
import 'package:tidy_ui/src/tokens/spacing.dart';

/// Sweeps a light band over [child]. Wrap placeholder boxes in it while data
/// loads; the boxes themselves only need a solid colour.
class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, super.key});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              final t = _controller.value;
              return LinearGradient(
                begin: Alignment(-1.5 + 3 * t, 0),
                end: Alignment(-0.5 + 3 * t, 0),
                colors: const [
                  TidyColors.line,
                  TidyColors.surface,
                  TidyColors.line,
                ],
              ).createShader(bounds);
            },
            child: child,
          );
        },
      ),
    );
  }
}

/// A rounded grey block, the building piece of loading skeletons. Put it
/// inside a [Shimmer] to animate it.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.width,
    this.height = 16,
    this.radius = 8,
    super.key,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: TidyColors.line,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}

/// A shimmering stack of card-sized placeholders for a list that is loading.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    this.count = 3,
    this.height = 72,
    this.semanticLabel,
    super.key,
  });

  final int count;
  final double height;

  /// What a screen reader says, for example the translated "Loading".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Loading',
      child: Shimmer(
        child: Column(
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) const SizedBox(height: TidySpacing.md),
              SkeletonBox(height: height, radius: TidyRadii.card),
            ],
          ],
        ),
      ),
    );
  }
}
