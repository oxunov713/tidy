import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo.freezed.dart';

/// A WGS84 coordinate. Independent of any map SDK.
@freezed
abstract class GeoPoint with _$GeoPoint {
  const factory GeoPoint({required double lat, required double lng}) =
      _GeoPoint;
}

enum MapMarkerKind {
  /// Generic place, e.g. the customer's address.
  pin,

  /// A cleaner's live position.
  cleaner,
}

/// Something to draw on the map.
@freezed
abstract class MapMarker with _$MapMarker {
  const factory MapMarker({
    /// Stable id so the map can update a marker in place instead of
    /// recreating it on every location tick.
    required String id,
    required GeoPoint position,
    @Default(MapMarkerKind.pin) MapMarkerKind kind,
    String? title,
  }) = _MapMarker;
}
