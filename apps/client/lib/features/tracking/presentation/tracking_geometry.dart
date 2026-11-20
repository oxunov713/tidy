import 'dart:math' as math;

import 'package:tidy_core/tidy_core.dart';

/// Great-circle distance between two points in kilometres.
double distanceKm(GeoPoint a, GeoPoint b) {
  const earthRadiusKm = 6371.0;
  double rad(double deg) => deg * math.pi / 180;
  final dLat = rad(b.lat - a.lat);
  final dLng = rad(b.lng - a.lng);
  final h =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(a.lat)) *
          math.cos(rad(b.lat)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * earthRadiusKm * math.asin(math.min(1, math.sqrt(h)));
}

GeoPoint midpoint(GeoPoint a, GeoPoint b) =>
    GeoPoint(lat: (a.lat + b.lat) / 2, lng: (a.lng + b.lng) / 2);

/// A zoom level at which two points [km] apart both stay on screen. The map
/// interface cannot fit bounds, so this stands in for it.
double zoomForDistance(double km) {
  if (km < 0.4) return 16;
  if (km < 1) return 15;
  if (km < 2) return 14.5;
  if (km < 4) return 13.5;
  if (km < 8) return 12.5;
  if (km < 16) return 11.5;
  return 10.5;
}

/// Straight-line interpolation, good enough over the few hundred metres that
/// separate two location updates.
GeoPoint lerpGeoPoint(GeoPoint a, GeoPoint b, double t) => GeoPoint(
  lat: a.lat + (b.lat - a.lat) * t,
  lng: a.lng + (b.lng - a.lng) * t,
);
