import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidy_core/tidy_core.dart';

Future<ProviderContainer> _container(Map<String, Object> initial) async {
  SharedPreferences.setMockInitialValues(initial);
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('LocaleController', () {
    test('follows the device until a language is picked', () async {
      final c = await _container({});
      expect(c.read(localeControllerProvider), isNull);
    });

    test('reads a saved language', () async {
      final c = await _container({'locale': 'uz'});
      expect(c.read(localeControllerProvider), const Locale('uz'));
    });

    test('ignores a language the app does not have', () async {
      final c = await _container({'locale': 'de'});
      expect(c.read(localeControllerProvider), isNull);
    });

    test('select saves it and null clears it', () async {
      final c = await _container({});
      final prefs = c.read(sharedPreferencesProvider);

      await c
          .read(localeControllerProvider.notifier)
          .select(const Locale('ru'));
      expect(c.read(localeControllerProvider), const Locale('ru'));
      expect(prefs.getString('locale'), 'ru');

      await c.read(localeControllerProvider.notifier).select(null);
      expect(c.read(localeControllerProvider), isNull);
      expect(prefs.containsKey('locale'), isFalse);
    });
  });

  test('the clock provider is the real clock until overridden', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final before = DateTime.now();
    final now = c.read(clockProvider)();
    expect(now.isBefore(before), isFalse);

    final fixed = DateTime.utc(2026, 12, 3);
    final frozen = ProviderContainer(
      overrides: [clockProvider.overrideWithValue(() => fixed)],
    );
    addTearDown(frozen.dispose);
    expect(frozen.read(clockProvider)(), fixed);
  });
}
