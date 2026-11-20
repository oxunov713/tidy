import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/core/providers/preferences.dart';

part 'locale_controller.g.dart';

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
    if (locale == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, locale.languageCode);
    }
    state = locale;
  }
}
