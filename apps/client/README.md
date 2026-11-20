# Tidy client app

The customer app (Android and iOS, package `uz.oxunov.tidy.client`). Right now
it is a shell: Riverpod, go_router, the Tidy theme and English, Russian and
Uzbek strings, with a placeholder home screen. The feature screens go on top of
this.

```bash
flutter run --dart-define=API_URL=http://10.0.2.2:8080
```

`10.0.2.2` is the host machine from the Android emulator; use
`http://localhost:8080` on the iOS simulator. The Yandex MapKit key setup is
described in [`packages/tidy_core`](../../packages/tidy_core/README.md#maps-and-the-yandex-key).

Strings live in `lib/l10n/*.arb`; `flutter gen-l10n` regenerates the Dart files,
which are committed.
