import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:tidy_cleaner/core/location/location_service.dart';
import 'package:tidy_core/tidy_core.dart';

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<LocationAccess> access() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }
    return _map(await Geolocator.checkPermission());
  }

  @override
  Future<LocationAccess> requestAccess() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return _map(permission);
  }

  @override
  Future<GeoPoint> current() async {
    try {
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return GeoPoint(lat: p.latitude, lng: p.longitude);
    } on Exception catch (e) {
      throw LocationUnavailableException(e.toString());
    }
  }

  @override
  Stream<GeoPoint> positions() => Geolocator.getPositionStream(
    // A 10 m filter keeps a parked cleaner from waking the radio needlessly;
    // the reporter repeats the last fix every 5 s anyway.
    locationSettings: const LocationSettings(distanceFilter: 10),
  ).map((p) => GeoPoint(lat: p.latitude, lng: p.longitude));

  @override
  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }

  LocationAccess _map(LocationPermission permission) => switch (permission) {
    LocationPermission.always ||
    LocationPermission.whileInUse => LocationAccess.granted,
    LocationPermission.deniedForever => LocationAccess.deniedForever,
    LocationPermission.denied ||
    LocationPermission.unableToDetermine => LocationAccess.denied,
  };
}
