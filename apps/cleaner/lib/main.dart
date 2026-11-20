import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidy_cleaner/app.dart';
import 'package:tidy_cleaner/core/location/geolocator_location_service.dart';
import 'package:tidy_cleaner/core/location/location_service.dart';
import 'package:tidy_cleaner/core/storage/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      // Failed requests show an error with a retry button; do not retry them
      // silently in the background.
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        locationServiceProvider.overrideWithValue(
          const GeolocatorLocationService(),
        ),
      ],
      child: const TidyCleanerApp(),
    ),
  );
}
