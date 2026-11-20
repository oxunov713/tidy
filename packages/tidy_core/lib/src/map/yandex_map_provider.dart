import 'dart:async';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:tidy_core/src/map/geo.dart';
import 'package:tidy_core/src/map/map_provider.dart';
import 'package:tidy_core/src/map/marker_icons.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// [MapProvider] backed by `yandex_mapkit` (Android and iOS only).
///
/// The MapKit API key is set natively, not here; see the package README.
class YandexMapProvider implements MapProvider {
  const YandexMapProvider({this.zoom = 15});

  final double zoom;

  @override
  Widget buildMap({
    required GeoPoint center,
    List<MapMarker> markers = const [],
    List<GeoPoint>? route,
    void Function(GeoPoint)? onTap,
  }) {
    return _YandexMapView(
      center: center,
      markers: markers,
      route: route,
      onTap: onTap,
      zoom: zoom,
    );
  }
}

class _YandexMapView extends StatefulWidget {
  const _YandexMapView({
    required this.center,
    required this.markers,
    required this.route,
    required this.onTap,
    required this.zoom,
  });

  final GeoPoint center;
  final List<MapMarker> markers;
  final List<GeoPoint>? route;
  final void Function(GeoPoint)? onTap;
  final double zoom;

  @override
  State<_YandexMapView> createState() => _YandexMapViewState();
}

class _YandexMapViewState extends State<_YandexMapView> {
  YandexMapController? _controller;
  final _icons = <MapMarkerKind, Uint8List>{};

  @override
  void initState() {
    super.initState();
    unawaited(_loadIcons());
  }

  @override
  void didUpdateWidget(_YandexMapView old) {
    super.didUpdateWidget(old);
    if (old.center != widget.center) _moveCamera();
  }

  Future<void> _loadIcons() async {
    for (final kind in MapMarkerKind.values) {
      final bytes = await MarkerIcons.png(kind);
      if (!mounted) return;
      setState(() => _icons[kind] = bytes);
    }
  }

  void _moveCamera({bool animated = true}) {
    unawaited(
      _controller?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _point(widget.center), zoom: widget.zoom),
        ),
        animation: animated ? const MapAnimation(duration: 0.5) : null,
      ),
    );
  }

  static Point _point(GeoPoint p) => Point(latitude: p.lat, longitude: p.lng);

  @override
  Widget build(BuildContext context) {
    final route = widget.route;
    final objects = <MapObject<dynamic>>[
      if (route != null && route.length >= 2)
        PolylineMapObject(
          mapId: const MapObjectId('route'),
          polyline: Polyline(points: route.map(_point).toList()),
          strokeColor: const Color(0xFF0A7A55),
          strokeWidth: 5,
        ),
      for (final marker in widget.markers)
        PlacemarkMapObject(
          mapId: MapObjectId('marker:${marker.id}'),
          point: _point(marker.position),
          opacity: 1,
          icon: _icons[marker.kind] == null
              ? null
              : PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromBytes(_icons[marker.kind]!),
                    scale: 0.5,
                  ),
                ),
        ),
    ];

    return YandexMap(
      mapObjects: objects,
      onMapCreated: (controller) {
        _controller = controller;
        _moveCamera(animated: false);
      },
      onMapTap: widget.onTap == null
          ? null
          : (point) => widget.onTap!(
              GeoPoint(lat: point.latitude, lng: point.longitude),
            ),
    );
  }
}
