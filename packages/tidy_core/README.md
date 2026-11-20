# tidy_core

Everything the three Tidy apps share that is not UI: models, the REST client,
token storage, the WebSocket client and the map abstraction.

## Layout

```
lib/src/
├── models/      freezed + json_serializable, snake_case JSON
├── api/         ApiClient, one class per area, ApiException, refresh interceptor
├── auth/        TokenStorage (secure storage) and an in-memory variant
├── realtime/    RealtimeClient and the sealed RealtimeEvent classes
├── map/         MapProvider, GeoPoint, MapMarker, YandexMapProvider
└── providers/   Riverpod wiring (riverpod_generator)
```

Import `package:tidy_core/tidy_core.dart`.

## REST

```dart
final api = ref.watch(apiClientProvider);

await api.auth.requestOtp('+447700900123');
final session = await api.auth.verify(
  phone: '+447700900123', code: '123456', role: UserRole.client,
); // tokens are stored for you

final quote = await api.bookings.quote(
  QuoteRequest(serviceId: id, bedrooms: 2, bathrooms: 1),
);
```

`role` only matters the first time a phone number signs in. Existing accounts
keep their role, and admins sign in without one (the server rejects `admin`).
The catalogue and `quote` need no sign in and send no token.

Areas: `auth`, `me`, `catalog`, `bookings`, `cleaner`, `admin`. Every method
returns a typed model or throws an `ApiException`. It is a sealed class, so a
`switch` can cover `SlotTakenException`, `InvalidTransitionException`,
`UnauthorizedException`, `NetworkException` and the rest.

Money is an integer in pence and times are UTC. Calls return what the server
returns: `cancel` gives a `Cancellation` (`booking` and `refunded`), `review` the
`Review`, `acceptOffer` and `setJobStatus` the updated `Booking`. Calls the
server answers with `204` (`setOnline`, `declineOffer`, `approveCleaner`,
`suspendCleaner`, `requestOtp`, `logout`) return `Future<void>`.

Different screens get different shapes of a booking, as on the wire:

| Call | Returns |
|---|---|
| `bookings.list` | `BookingPage` of `Booking` |
| `bookings.get` | `BookingDetails`: `booking`, `address`, `cleaner`, `lastLocation`, `events`, `review` |
| `cleaner.offers` | `Offer`: `booking`, `expiresAt`, `distanceKm`, `postcode`, `city` |
| `cleaner.jobs` | `Job`: `booking`, `address`, `clientName` |
| `admin.bookings` | `AdminBookingPage` of `AdminBooking`: `booking`, `clientName`, `clientPhone`, `cleanerName` |

### Pagination

`bookings.list` and `admin.bookings` take `cursor` and `limit` (20 by default,
50 at most) and return a page with `items` and `nextCursor`. `nextCursor` is an
empty string on the last page; use `page.hasMore`.

```dart
var page = await api.bookings.list(scope: BookingScope.past);
while (page.hasMore) {
  page = await api.bookings.list(
    scope: BookingScope.past,
    cursor: page.nextCursor,
  );
}
```

### Errors

`ApiException` subtypes follow the error codes of the API: `InvalidRequest`
(`details` maps field to problem), `Unauthorized`, `Forbidden`, `NotFound`,
`SlotTaken`, `InvalidTransition`, `OfferGone`, `TooManyRequests`,
`ServerException` (5xx and `internal`) and `NetworkException`. A cleaner setting
`on_the_way` more than 3 hours before the start gets `InvalidTransitionException`.

The base URL comes from `--dart-define`:

```bash
flutter run --dart-define=API_URL=http://10.0.2.2:8080   # Android emulator
```

It defaults to `http://localhost:8080`. `/api/v1` is added by the client.

### Token refresh

`AuthInterceptor` adds the bearer token. On a 401 it calls `/auth/refresh` once
and replays the request. If several requests fail at the same time they share
one refresh, which matters because refresh tokens rotate. If the refresh is
rejected the tokens are cleared and `apiClient.sessionExpired` fires.

## WebSocket

```dart
final rt = ref.read(realtimeClientProvider);
await rt.connect();
rt.subscribe(Rooms.booking(bookingId)); // clients and the assigned cleaner
rt.subscribe(Rooms.cleanerOffers);      // cleaners, for new offers
rt.events.listen((event) => switch (event) {
  BookingStatusChanged(:final status) => ...,
  CleanerLocationUpdated(:final lat, :final lng) => ...,
  OfferReceived(:final booking, :final expiresAt) => ...,
  _ => null,
});
```

Events: `BookingStatusChanged`, `CleanerLocationUpdated`, `OfferReceived`,
`OfferWithdrawn`, `MessageReceived`, and the replies to the client's own
messages: `RoomSubscribed`, `RoomUnsubscribed` and `RealtimeError` (for example
`forbidden` when joining someone else's booking; the socket stays open). A
cleaner shares the position with `sendLocation`, which the server accepts only
while the booking is assigned or on the way (`RealtimeError` with
`invalid_transition` otherwise). `OfferReceived` has no distance or area; fetch
`cleaner.offers()` for those.

The client reconnects with exponential backoff (0.5 s up to 30 s, with jitter)
and joins the same rooms again. If a connection attempt fails it calls
`ApiClient.refreshSession` first, so an expired access token does not keep the
socket down. Unknown event types arrive as `UnknownRealtimeEvent`.

## Maps and the Yandex key

`MapProvider` is the only thing screens depend on. `YandexMapProvider` wraps
[`yandex_mapkit`](https://pub.dev/packages/yandex_mapkit).

I picked `yandex_mapkit` over Yandex's own `yandex_maps_mapkit` package. It has
a widget-based API (`YandexMap`, `PlacemarkMapObject`) that fits behind a small
interface, more users, and a release in July 2026. The official package is
newer and closer to the native SDK, but its API is much lower level and would
need a bigger adapter for the same result. Swapping later only means writing
another `MapProvider`.

It supports Android and iOS only. Do not call `buildMap` in the admin web app.

Setup in each mobile app (`apps/client`, `apps/cleaner`):

1. Create a "MapKit Mobile SDK" key at <https://developer.tech.yandex.ru/services/>.
2. **Android**: add `implementation 'com.yandex.android:maps.mobile:4.39.1-lite'`
   to `android/app/build.gradle`, add `yandexMapkit.variant=lite` to
   `android/gradle.properties`, create a `MainApplication` class that calls
   `MapKitFactory.setApiKey("...")`, reference it with `android:name` in
   `AndroidManifest.xml`, and add the `INTERNET` and `ACCESS_FINE_LOCATION`
   permissions.
3. **iOS**: call `YMKMapKit.setApiKey("...")` in `AppDelegate.swift` before
   `GeneratedPluginRegistrant.register`.

The key is not in the repository. Keep it in a local, untracked file or inject
it in CI. The plugin's README has the exact snippets.

## Wire format

The models mirror `backend/internal/httpapi` and the DTOs it uses field for
field: `snake_case` keys, RFC 3339 timestamps (read as UTC, sent as UTC), a
nullable Dart field only where the Go field is a pointer. `BookingDetails`,
`Job` and `AdminBooking` wrap a `Booking` because the server flattens the
booking and the extra fields into one object. `GET /admin/cleaners` returns
users with a `cleaner` profile, so it gives `List<User>`.

## Generated code

`*.freezed.dart` and `*.g.dart` are committed. After changing a model or a
provider:

```bash
dart run build_runner build
```

## Tests

```bash
flutter test
```

Covers JSON decoding with payloads copied from the backend, error mapping, the
single-flight refresh, WebSocket event parsing and reconnect behaviour.

### Against a running backend

`test/integration/api_flow_test.dart` uses the real `ApiClient` and
`RealtimeClient` against a local API and walks through a whole booking: OTP
sign in as client, cleaner and admin, quote, slots, booking, offer over the
socket, accept, `on_the_way` / `in_progress` / `completed` with the client
receiving `booking.status` and `cleaner.location`, review, earnings, cancel,
pagination and the admin screens. It is tagged `integration` and skipped unless
`TIDY_API_URL` is set.

```bash
cd backend
export DATABASE_URL=postgres://postgres@localhost:5433/tidy_dev?sslmode=disable \
       JWT_SECRET=local-dev-secret-at-least-32-characters-long PAYMENT_PROVIDER=mock
make migrate seed
go run ./cmd/api > /tmp/tidy-api.log 2>&1 &

cd ../packages/tidy_core
TIDY_API_URL=http://localhost:8080 \
TIDY_API_LOG=/tmp/tidy-api.log \
TIDY_DATABASE_URL=$DATABASE_URL \
flutter test test/integration
```

`TIDY_API_LOG` is where the API writes its log: in development the one-time
codes are printed there. The test signs up a fresh client and a fresh cleaner
each run, so reruns do not collide; `TIDY_CLEANER_PHONE=+447700900101` uses a
seeded cleaner instead (it then keeps the slot of every run).
`TIDY_DATABASE_URL` is optional and needs `psql`: it lets the test approve the
new cleaner by hand if `POST /admin/cleaners/{id}/approve` fails, and move the booking to two hours from now when the first free slot
is more than 3 hours away (the server refuses `on_the_way` before that). The
API limits login codes to 3 per phone per 10 minutes and 30 auth requests per
minute per IP, so wait a minute between runs.
