# Tidy cleaner app

The cleaner app (Android and iOS, package `uz.oxunov.tidy.cleaner`). A shell
for now: Riverpod, go_router, the Tidy theme, English, Russian and Uzbek
strings, and a placeholder home screen.

```bash
flutter run --dart-define=API_URL=http://10.0.2.2:8080
```

See the [client README](../client/README.md) for the emulator URL and
[`tidy_core`](../../packages/tidy_core/README.md#maps-and-the-yandex-key) for
the map key. Strings live in `lib/l10n/*.arb`.
