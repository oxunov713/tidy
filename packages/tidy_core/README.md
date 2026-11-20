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

Areas: `auth`, `me`, `catalog`, `bookings`, `cleaner`, `admin`. Every method
returns a typed model or throws an `ApiException`. It is a sealed class, so a
`switch` can cover `SlotTakenException`, `InvalidTransitionException`,
`UnauthorizedException`, `NetworkException` and the rest.

Calls that only change state (`cancel`, `review`, `acceptOffer`, `setJobStatus`
...) return `Future<void>`. Refetch the booking, or listen to `booking.status`
on the socket.

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
rt.subscribe(Rooms.booking(bookingId));
rt.events.listen((event) => switch (event) {
  BookingStatusChanged(:final status) => ...,
  CleanerLocationUpdated(:final lat, :final lng) => ...,
  _ => null,
});
```

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

## Where the API contract was ambiguous

`docs/API.md` does not spell out every shape, so these are guesses to check
against the backend:

- Paginated lists (`/bookings`, `/admin/bookings`) are read as
  `{ "items": [...], "next_cursor": "..." | null }`.
- `extra_ids` in `GET /slots` is sent comma-separated.
- The WebSocket lives at `/api/v1/ws` (same prefix as REST).
- Fields on `Booking`, `Cleaner`, `Earnings`, `ClientSummary` beyond what the
  docs mention (for example `code`, `service_title`, `cleaner_location`,
  per-day earnings as `days`) follow the database columns. Most of them have
  defaults or are nullable so a missing field does not break decoding.
- Body of `PUT /admin/services/{id}` uses the `services` table columns, and
  `PATCH /admin/bookings/{id}` takes `cleaner_id` and/or `status`.

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

Covers JSON round-trips, error mapping, the single-flight refresh, WebSocket
event parsing and reconnect behaviour.
