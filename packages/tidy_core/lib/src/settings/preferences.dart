import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences.g.dart';

/// Loaded once in `main()` and passed in as an override, so the rest of the
/// app reads it synchronously.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
  'Override sharedPreferencesProvider in main()',
);

/// "Now", as a provider so expiry, countdown and "today" logic can be tested
/// with a fixed time.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

const supportedLanguageCodes = ['en', 'ru', 'uz'];

/// The language picked in the profile, or null to follow the device.
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  static const _key = 'locale';

  @override
  Locale? build() {
    final code = ref.watch(sharedPreferencesProvider).getString(_key);
    return supportedLanguageCodes.contains(code) ? Locale(code!) : null;
  }

  Future<void> select(Locale? locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = locale;
    if (locale == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, locale.languageCode);
    }
  }
}
