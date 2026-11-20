# Tidy client app

The customer app (Android and iOS, package `uz.oxunov.tidy.client`): book a
home clean, follow the cleaner live, chat, pay and review.

## Run

```bash
flutter run \
  --dart-define=API_URL=http://10.0.2.2:8080 \
  --dart-define=YANDEX_MAPKIT_KEY=<your key>
```

`10.0.2.2` is the host machine from the Android emulator; use
`http://localhost:8080` on the iOS simulator. Start the backend first (see
[`backend/README.md`](../../backend/README.md)); in dev the sign in code is
printed in the API log. The seeded client is `+447700900201`.

| Define | Purpose | Default |
|---|---|---|
| `API_URL` | backend origin | `http://localhost:8080` |
| `YANDEX_MAPKIT_KEY` | Yandex MapKit key (Android only through this define) | none, map stays grey |
| `STRIPE_PUBLISHABLE_KEY` | switches the payment sheet from the mock to Stripe | none, mock |

### Yandex MapKit

Create a "MapKit Mobile SDK" key at <https://developer.tech.yandex.ru/services/>.
The key is never committed.

- **Android**: `MainApplication` calls `MapKitFactory.setApiKey` with
  `BuildConfig.YANDEX_MAPKIT_KEY`. Gradle reads it from `--dart-define`, then
  `yandex.mapkit.key` in `android/local.properties`, then the
  `YANDEX_MAPKIT_KEY` environment variable.
- **iOS**: copy `ios/Flutter/Secrets.xcconfig.example` to
  `ios/Flutter/Secrets.xcconfig` (git-ignored) and set the key. It reaches
  `AppDelegate` through `Info.plist`.

### Payments

The backend runs with `PAYMENT_PROVIDER=mock` by default, so a booking confirms
itself. The app shows a `MockPaymentSheet` (card form, "Test mode" label) that
charges nothing. With `--dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_...` the
`StripePaymentSheet` is used instead; point the backend at Stripe test mode too.
Both implement `PaymentSheet` in `lib/features/payment`.

### Push notifications

`PushService` (`lib/core/push`) is a no-op, so the app builds without Firebase
config. To enable push: add `firebase_core` and `firebase_messaging`, add
`google-services.json` / `GoogleService-Info.plist`, implement `PushService`
with `FirebaseMessaging` (request permission in `init`, return
`getToken()`, forward `onTokenRefresh`), override `pushServiceProvider`, and
send the token with `meApi.registerDevice(token:, platform:)` after sign in.

## Structure

Feature first, each feature split into `data`, `domain` and `presentation`:

```
lib/
  core/        router, shared widgets, formatting, locale, push, live channel
  features/
    auth/ addresses/ catalog/ home/
    bookings/        repository, lists, details, cancel
    booking_wizard/  configure, schedule, checkout (one Riverpod notifier)
    payment/ tracking/ review/ chat/ profile/
  l10n/        en (complete), ru, uz
```

State is Riverpod with code generation, navigation is go_router with an auth
redirect. Screens depend on repository interfaces, so tests swap in fakes.

## Tests and code generation

```bash
flutter test
dart run build_runner build   # after changing providers or freezed classes
flutter gen-l10n              # after editing the ARB files
```
