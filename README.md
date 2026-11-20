# Tidy

[![Backend CI](https://github.com/oxunov713/tidy/actions/workflows/backend.yml/badge.svg)](https://github.com/oxunov713/tidy/actions/workflows/backend.yml) [![Flutter CI](https://github.com/oxunov713/tidy/actions/workflows/flutter.yml/badge.svg)](https://github.com/oxunov713/tidy/actions/workflows/flutter.yml)

Book a home cleaner in a minute. Tidy is a full marketplace: a customer app, a
cleaner app and an admin panel, all in Flutter, on top of a Go backend.

> Work in progress. Screenshots and a demo video will land here once the first
> flow is working end to end.

## What's inside

- **Client app** — pick a service, size and extras, see the price update live,
  choose a time slot, pay, then follow the cleaner on the map.
- **Cleaner app** — go online, accept or decline nearby jobs, update the job
  status, set working hours, see weekly earnings.
- **Admin web** — today's numbers, every booking with filters, cleaner approval.
- **Backend** — Go, PostgreSQL, WebSockets for live status and location,
  Stripe (test mode) behind a payment interface, FCM push.

## Stack

| | |
|---|---|
| Mobile & web | Flutter, Riverpod, go_router, freezed, dio |
| Maps | Yandex MapKit (behind a `MapProvider` interface) |
| Backend | Go 1.24, chi, pgx, golang-migrate, WebSocket |
| Database | PostgreSQL 16 |
| Payments | Stripe test mode, or a built-in mock |

## Docs

- [Architecture](docs/ARCHITECTURE.md)
- [API](docs/API.md)

## Development

The Flutter side is a Dart pub workspace. Run these from the repository root:

```bash
flutter pub get                         # resolves every package and app
flutter analyze                         # whole workspace, strict lints
cd packages/tidy_core && flutter test   # same for tidy_ui and each app
```

Generated files (`*.g.dart`, `*.freezed.dart`, and the `lib/l10n/` Dart files
in each app) are committed, so the repository builds without running code
generation. If you change a model, a provider or an `.arb` file, regenerate
and commit the result:

```bash
cd packages/tidy_core && dart run build_runner build
cd apps/client && flutter gen-l10n
```

Point an app at a backend with `--dart-define=API_URL=http://10.0.2.2:8080`
(the default is `http://localhost:8080`). The widget gallery for `tidy_ui` is in
`packages/tidy_ui/example`. See the package READMEs for details.
