import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_core/tidy_core.dart';

part 'location_service.g.dart';

enum LocationAccess {
  /// Permission given and the device's location switch is on.
  granted,

  /// Not asked yet, or denied once: asking again will show the system dialog.
  denied,

  /// Denied for good: only the system settings can change it.
  deniedForever,

  /// The device's location switch is off.
  serviceDisabled,
}

class LocationUnavailableException implements Exception {
  const LocationUnavailableException([this.reason = 'Location unavailable']);

  final String reason;

  @override
  String toString() => 'LocationUnavailableException: $reason';
}

/// Position access behind an interface: `geolocator` in the app, a fake in
/// tests.
abstract interface class LocationService {
  Future<LocationAccess> access();

  /// Shows the system permission dialog when it can still be shown.
  Future<LocationAccess> requestAccess();

  /// One fix. Throws [LocationUnavailableException].
  Future<GeoPoint> current();

  /// Foreground position updates. The stream ends when the listener cancels.
  Stream<GeoPoint> positions();

  Future<void> openSettings();
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) =>
    throw UnimplementedError('Override locationServiceProvider in main()');
