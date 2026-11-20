# Tidy Pro (cleaner app)

The app for cleaners (Android and iOS, package `uz.oxunov.tidy.cleaner`):
sign in with a phone number, go online, accept offers, work a job from "on my
way" to "finished", set weekly hours and see earnings.

| Screen | What it does |
|---|---|
| Sign in | Phone, then the 6-digit code, role `cleaner` |
| Review / suspended | Shown instead of the app while the profile is `pending` or `suspended`. Pull down to check again |
| Jobs | Dark header with the online switch (sends the current position) and today's numbers, open offers with a countdown, "Next up" |
| Offer alert | A new offer opens a full-screen card on any tab, with a sound and vibration hook |
| Active job | Client, access notes, Open in Maps, progress, checklist, the button that sets the next status |
| Chat | Messages with the client of a job, live over the socket |
| Schedule | Working days and hours (`PUT /cleaner/availability`) and a timeline of the chosen day |
| Earnings | Week or month, bar chart per day, tips, average per hour, recent jobs |
| Profile | Name, bio, language (en / ru / uz), sign out |

## Run

Start the backend first (see [backend/README.md](../../backend/README.md)), then:

```bash
cd apps/cleaner
flutter run --dart-define=API_URL=http://10.0.2.2:8080   # Android emulator
flutter run --dart-define=API_URL=http://localhost:8080  # iOS simulator
```

In development the one-time code is printed in the API log. The seeded
cleaners (`+447700900101` and friends) are approved; a number that is new to
the system signs up as `pending` and sees the review screen until an admin
approves it (`POST /admin/cleaners/{id}/approve`).

The Android debug build allows plain `http` for the local API; release builds
do not.

## Tests and checks

```bash
flutter analyze
dart format --output=none --set-exit-if-changed .
flutter test
```

Controllers are tested against fakes (`test/support`): the offer controller
(receive, expire, gone, accept, `slot_taken`), the job status controller
(transitions, `invalid_transition`), the location reporter, and widget tests
for the Jobs and Earnings screens.

## Structure

```
lib/
├── core/        clock, formatting, realtime gateway, location, maps, push,
│                alerts, shared widgets (app-local), theme extras
├── features/
│   ├── auth/         sign in, session, review gates
│   ├── jobs/         offers, schedule list, online switch, Jobs screen
│   ├── active_job/   status button, checklist, LocationReporter
│   ├── chat/  schedule/  earnings/  profile/  permissions/  shell/
│   └── <feature>/{data,domain,presentation}
├── l10n/        ARB files (English complete, Russian and Uzbek translated)
├── router.dart  go_router with the auth / approval redirect
└── main.dart
```

Each feature has `domain/` (interfaces), `data/` (the implementation on
`tidy_core`) and `presentation/` (Riverpod controllers and widgets).
Controllers depend on interfaces such as `RealtimeGateway`, `LocationService`,
`OffersRepository` and `OfferAlerts`, so tests replace them with fakes.

Realtime: the shell connects the socket and joins `cleaner:offers`; each open
job joins `booking:<id>` for status changes and chat. While a job is
`on_the_way` the `LocationReporter` sends the position every 5 seconds. It
only runs while the app is open, stops when the job moves on, and stops if the
server answers `invalid_transition`.

## Location

Going online asks for location through a rationale screen first. Only
foreground ("while in use") access is used, and the manifest and `Info.plist`
declare nothing else:

- Android: `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, plus `<queries>`
  for Yandex Maps, `geo:` and `https` links.
- iOS: `NSLocationWhenInUseUsageDescription` and `LSApplicationQueriesSchemes`
  (`yandexmaps`).

## Push notifications

`PushService` (`lib/core/push/push_service.dart`) is an interface and the app
uses `NoopPushService`, so there is no Firebase dependency. After sign-in the
token, if any, is sent to `POST /me/devices`. To use Firebase Cloud Messaging:

1. Add `firebase_core` and `firebase_messaging`, run `flutterfire configure`.
2. Implement `PushService`: `initialize()` calls `Firebase.initializeApp()` and
   `FirebaseMessaging.instance.requestPermission()`, `token()` returns
   `getToken()`, `tokenRefreshes` is `onTokenRefresh`.
3. Override `pushServiceProvider` in `lib/main.dart`:
   `pushServiceProvider.overrideWithValue(FirebasePushService())`.
4. Offers also arrive over the socket while the app is open; with push the
   backend can wake a closed app.

## Generated code

`*.g.dart` (Riverpod) and `lib/l10n/app_localizations*.dart` are committed.

```bash
dart run build_runner build
flutter gen-l10n
```
