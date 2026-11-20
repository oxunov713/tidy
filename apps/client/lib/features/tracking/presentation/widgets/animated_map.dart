import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/tracking/presentation/tracking_geometry.dart';
import 'package:tidy_core/tidy_core.dart';

class _GeoPointTween extends Tween<GeoPoint> {
  _GeoPointTween({super.end});

  @override
  GeoPoint lerp(double t) => lerpGeoPoint(begin!, end!, t);
}

/// Builds the map with the cleaner marker gliding to each new position instead
/// of jumping. [builder] receives the in-between position on every frame.
class AnimatedCleanerPosition extends StatelessWidget {
  const AnimatedCleanerPosition({
    required this.target,
    required this.builder,
    this.duration = const Duration(milliseconds: 1500),
    super.key,
  });

  final GeoPoint target;
  final Duration duration;
  final Widget Function(BuildContext context, GeoPoint position) builder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<GeoPoint>(
      tween: _GeoPointTween(end: target),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, position, _) => builder(context, position),
    );
  }
}
