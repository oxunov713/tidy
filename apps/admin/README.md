# Tidy admin

The admin panel, built with Flutter Web. A shell for now: Riverpod, go_router,
the Tidy theme, English, Russian and Uzbek strings, and a placeholder home
screen.

```bash
flutter run -d chrome --dart-define=API_URL=http://localhost:8080
flutter build web --dart-define=API_URL=https://api.example.com
```

The backend must allow the admin's origin (CORS). `yandex_mapkit` does not
support web, so the admin should not use `MapProvider.buildMap`; importing
`tidy_core` is fine and compiles for web.
