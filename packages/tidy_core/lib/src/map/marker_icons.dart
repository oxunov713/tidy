import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:tidy_core/src/map/geo.dart';

/// Draws marker bitmaps in code, so the package needs no image assets.
abstract final class MarkerIcons {
  static final _cache = <MapMarkerKind, Future<Uint8List>>{};

  static Future<Uint8List> png(MapMarkerKind kind) =>
      _cache.putIfAbsent(kind, () => _render(kind));

  static Future<Uint8List> _render(MapMarkerKind kind) async {
    const size = 96.0;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    const center = ui.Offset(size / 2, size / 2);

    final (fill, ring) = switch (kind) {
      MapMarkerKind.pin => (
        const ui.Color(0xFF0A7A55),
        const ui.Color(0xFFFFFFFF),
      ),
      MapMarkerKind.cleaner => (
        const ui.Color(0xFFF5A524),
        const ui.Color(0xFFFFFFFF),
      ),
    };

    canvas
      ..drawCircle(
        center.translate(0, 3),
        size * 0.36,
        ui.Paint()
          ..color = const ui.Color(0x33000000)
          ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 4),
      )
      ..drawCircle(center, size * 0.36, ui.Paint()..color = ring)
      ..drawCircle(center, size * 0.28, ui.Paint()..color = fill);
    if (kind == MapMarkerKind.pin) {
      canvas.drawCircle(
        center,
        size * 0.09,
        ui.Paint()..color = const ui.Color(0xFFFFFFFF),
      );
    }

    final image = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  }
}
