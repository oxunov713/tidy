# Tidy admin

The admin panel for Tidy, built with Flutter Web. It talks to the Go backend
through `tidy_core` and uses the shared theme and widgets from `tidy_ui`.

## Pages

| Route | What it does |
|---|---|
| `/login` | Phone + one-time code. Accounts that are not admins are turned away. |
| `/bookings` | KPI tiles (refreshed every 30 s), search, status chips and a paginated table. Rows become cards on narrow screens. |
| `/bookings/:id` | Details with the events timeline. Reassign the cleaner (approved cleaners only) or cancel. Opens beside the list on wide screens, as a page otherwise. |
| `/cleaners` | Pending, approved and suspended tabs with approve and suspend. The UI updates at once and rolls back if the server refuses. |
| `/services` | Prices (typed in pounds, sent as pence) and durations. `is_active` is always sent, because the API requires it. |

The layout follows the screen width: a sidebar from 1024 px, a collapsible rail
from 600 px, a drawer below that. Strings are in English, Russian and Uzbek
(`lib/l10n/*.arb`).

## Run

```bash
flutter run -d chrome --dart-define=API_URL=http://localhost:8080
```

`API_URL` is the server origin without `/api/v1`. The backend must allow the
panel's origin (`CORS_ALLOWED_ORIGINS`, `http://localhost:*` by default).

To sign in locally, start the backend (see `backend/README.md`), run
`make seed` and use the demo admin `+447700900001`. In development the one-time
code is printed in the API log.

## Test

```bash
flutter test
flutter analyze
```

Controllers are tested against fake repositories (`test/helpers/fakes.dart`);
widget tests cover the bookings table, the service form and the shell.

## Build and deploy

```bash
flutter build web --release --dart-define=API_URL=https://api.example.com
```

The output in `build/web` is plain static files, so any static host works
(Netlify, Firebase Hosting, GitHub Pages, S3 + CloudFront, nginx). Routes use
the URL hash, so no rewrite rules are needed. If the panel is served from a
sub-path, add `--base-href=/admin/`. Add `--no-web-resources-cdn` to serve
CanvasKit from your own host instead of gstatic.

The theme loads Inter and Space Grotesk from Google Fonts at runtime; bundle
them as assets if the panel must work without access to fonts.googleapis.com.
