import 'package:flutter/widgets.dart';
import 'package:tidy_core/src/map/geo.dart';

/// Map abstraction used by the apps, so the SDK behind it can be swapped.
///
/// Screens only ever talk to this interface; `YandexMapProvider` is the
/// implementation that ships today. A Google Maps one would be one more class.
// A single method is the point: the architecture doc fixes this interface.
// ignore: one_member_abstracts
abstract interface class MapProvider {
  /// Builds a map widget centred on [center].
  ///
  /// [markers] are matched by [MapMarker.id] between rebuilds. [route] draws a
  /// polyline through the points in order. [onTap] reports taps on empty map.
  Widget buildMap({
    required GeoPoint center,
    List<MapMarker> markers = const [],
    List<GeoPoint>? route,
    void Function(GeoPoint)? onTap,
  });
}
