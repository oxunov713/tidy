# Tidy — architecture

Tidy is a home cleaning marketplace: customers book a cleaner, cleaners accept
jobs and share their location on the way, and an admin panel keeps an eye on
everything.

Three Flutter apps talk to one Go backend.

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  Client app  │  │ Cleaner app  │  │  Admin web   │
│ (iOS/Android)│  │ (iOS/Android)│  │ (Flutter Web)│
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘
       │   REST (JSON) + WebSocket          │
       └──────────────┬────────────────────┘
               ┌──────┴───────┐
               │  Go backend  │──── Stripe (test mode) / mock
               │   (api)      │──── FCM push
               └──────┬───────┘
               ┌──────┴───────┐
               │ PostgreSQL 16│
               └──────────────┘
```

## Repository layout

```
tidy/
├── backend/                 Go service
│   ├── cmd/api/             main.go, wiring only
│   ├── internal/
│   │   ├── config/          env parsing
│   │   ├── domain/          entities, errors, pricing rules (no imports from other layers)
│   │   ├── service/         use cases: auth, booking, dispatch, payment, review
│   │   ├── store/postgres/  repositories (pgx)
│   │   ├── httpapi/         router, handlers, middleware, request/response DTOs
│   │   ├── realtime/        WebSocket hub (per-booking rooms)
│   │   ├── payment/         PaymentProvider + stripe and mock implementations
│   │   ├── push/            Notifier + fcm and log implementations
│   │   └── scheduler/       recurring bookings, offer expiry, saved-card charges, stuck bookings
│   └── migrations/          plain SQL, golang-migrate format
├── apps/
│   ├── client/              customer app
│   ├── cleaner/             cleaner app
│   └── admin/               Flutter Web admin
├── packages/
│   ├── tidy_core/           models, API client, auth storage, MapProvider, WS client
│   └── tidy_ui/             design tokens, theme, shared widgets
├── docs/
└── .github/workflows/       CI for backend and Flutter
```

The Flutter side is a Dart pub workspace (one `pubspec.yaml` at the root with
`workspace:`), so the three apps share `tidy_core` and `tidy_ui` without
publishing anything.

## Backend

- **Go 1.24**, `chi` router, `pgx/v5` for Postgres, `golang-migrate` for migrations,
  `coder/websocket` for WebSockets, `golang-jwt/jwt/v5`.
- Layers only point inwards: `httpapi → service → domain`, and `service` talks to
  storage through interfaces defined in `service`. Postgres, Stripe and FCM are
  details that live at the edges, so tests can swap them out.
- Money is always an `int` in pence. No floats anywhere near prices.
- Every request carries a request id; logs are structured (`log/slog`).

### Auth

Phone number + one-time code. In dev the code is printed to the log instead of
being sent by SMS. Login returns a short-lived access token (JWT, 15 min) and a
refresh token (random, stored hashed, 30 days, rotated on every use). The role
(`client`, `cleaner`, `admin`) is inside the access token and checked by
middleware. Each app sends its role on sign-in; a number registered with
another role is refused, and admins are never created through the API.

The successor of a refresh token is derived from it (HMAC with the server
secret) and its access token is issued at the rotation time. That makes a
retried refresh within 10 s return exactly the same pair without storing any
token in plain text; reuse after that is treated as theft and signs the user
out everywhere.

### Booking flow

```
pending ──pay──▶ confirmed ──accept──▶ assigned ──▶ on_the_way ──▶ in_progress ──▶ completed
   │                 │                    │
   └────cancel───────┴──────cancel────────┘──▶ cancelled
```

1. Client asks `POST /quotes` for a price. The price is calculated on the server
   from `domain/pricing.go`; the app never sends a price it calculated itself.
2. `POST /bookings` creates the booking in `pending` and starts the payment
   (see [Payments](#payments)). Stripe holds the money (manual capture) and
   charges it only on `completed`.
3. When the payment is authorised (webhook, mock, or the off-session charge
   48 h before), the booking becomes `confirmed` and the dispatcher offers it to
   nearby online cleaners seen in the last 10 minutes, one at a time, each offer
   valid for 60 seconds.
4. A cleaner accepts. Assigning a cleaner is a single `UPDATE`; the
   `bookings_no_overlap` exclusion constraint in Postgres rejects it if the
   cleaner already has a job at that time. Two cleaners accepting at the same
   moment is also safe: the update is conditional on `status = 'confirmed'`.
5. On the way, the cleaner app sends its location every 5 seconds over the
   WebSocket. The server forwards it to everyone watching that booking and
   stores only the latest point.
6. `completed` captures the payment; the client can then leave a review and tip.

Recurring bookings (`weekly`, `fortnightly`) are stored as a `booking_plan`. A
scheduler job runs every hour and creates the next booking 7 days ahead; it is
paid with the card saved on the first visit. The client ends a plan with
`DELETE /plans/{id}` or by cancelling a visit with `scope: "series"`; future
visits without a cleaner are then cancelled and refunded. The scheduler ends
plans whose address was deleted and skips visits while a service is switched
off.

Suspending a cleaner moves their jobs that haven't started back to
`confirmed` and dispatches them again; a cleaner who isn't approved can't
change job status, chat or share a location.

### Scheduler

One goroutine per job, each running once at start-up and then on its interval.
`main` binds the listener before the scheduler starts, so a failed start never
leaves jobs running.

| Job | Every | What it does |
|---|---|---|
| plans | 1 h | creates the next visit of each plan due within 7 days |
| offers | 5 s | expires unanswered offers, dispatches confirmed bookings without an offer |
| payments | 1 min | authorises saved cards off-session for visits starting within 48 h |
| stuck | 1 min | cancels `pending` bookings unpaid for 30 min and `confirmed` ones still without a cleaner 2 h before the start, with a refund |

### Real-time

One WebSocket per app session at `GET /ws?token=…`. Clients subscribe to rooms
(`booking:<id>` or `cleaner:offers`). Messages are JSON with a `type` field; see
[API.md](API.md#websocket). The hub is in-memory, which is fine for a single
instance. If the service ever runs on several instances, the hub would move to
Postgres `LISTEN/NOTIFY` without changing the message format.

Access to a booking room is checked on subscribe and again before every message
sent to the room. When access is taken away (reassign, cancel, suspend) the
service tells the hub, which removes the user from the room and sends
`unsubscribed` with `reason: "access_revoked"`; the re-check catches anything
that changed by another path. A cleaner's answer to the server's 30 s ping
counts as being seen for dispatch.

### Payments

```go
type PaymentProvider interface {
    Name() string
    CreateCustomer(ctx context.Context, u domain.User) (string, error)
    CreateIntent(ctx context.Context, req domain.ChargeRequest) (domain.PaymentIntent, error)   // hold now
    CreateSetup(ctx context.Context, req domain.ChargeRequest) (domain.PaymentIntent, error)    // save the card
    AuthorizeSaved(ctx context.Context, req domain.ChargeRequest) (domain.PaymentIntent, error) // hold off-session
    Capture(ctx context.Context, ref string) error
    Refund(ctx context.Context, ref string) error
    ParseWebhook(payload []byte, signature string) (domain.PaymentEvent, error)
}
```

A card hold lasts about a week, but visits can be booked 60 days ahead:

```
start ≤ 5 days away:  PaymentIntent (manual capture) ── authorised ──▶ confirmed
start > 5 days away:  SetupIntent ── card saved ──▶ pending … T-48 h: off-session hold ──▶ confirmed
plan visit:           pending … T-48 h: off-session hold on the saved card ──▶ confirmed
off-session declined: stays pending, push + booking.status, POST /bookings/{id}/payment
```

Every user gets one customer per provider (`payment_customers`), and the first
visit of a plan saves its card on that customer (`setup_future_usage`). The
`payments` table keeps one row per intent (`kind` is `payment` or `setup`); the
newest row is the booking's current payment. A declined card only marks that
row `failed`, since the client can retry with the same intent; only
`payment_intent.canceled` for the current intent cancels the booking.
`bookings.authorize_at` says when the scheduler charges the saved card, and
`bookings.payment_due_at` when an unpaid pending booking is cancelled.

`PAYMENT_PROVIDER=stripe` uses Stripe in test mode, `mock` succeeds at
everything instantly so the whole flow works without a Stripe account. Webhook
event ids are stored in `processed_webhooks`, so a repeated webhook does nothing.

## Flutter apps

- **Riverpod 3** (`riverpod_generator`), **go_router**, **freezed** + `json_serializable`,
  **dio** for HTTP.
- Each feature is split into `data/` (DTOs, repositories), `domain/` (entities,
  repository interfaces) and `presentation/` (screens, widgets, providers).
- Maps go through an interface in `tidy_core`, with **Yandex MapKit** as the
  implementation. Swapping to Google Maps means writing one more class:

```dart
abstract interface class MapProvider {
  Widget buildMap({
    required GeoPoint center,
    List<MapMarker> markers,
    List<GeoPoint>? route,
    void Function(GeoPoint)? onTap,
  });
}
```

- Tokens are stored with `flutter_secure_storage`; a dio interceptor refreshes
  the access token once on 401 and retries the request. The tokens are cleared
  only when the refresh itself answers 401.
- Times are shown in the business zone (Europe/London, `--dart-define=BUSINESS_TZ`),
  not the device's.
- Push is an interface, `PushService` in `tidy_core`, whose default does
  nothing, so the apps run and are tested without Firebase. A real
  implementation (for example `firebase_messaging`) is passed in when the app
  starts; its token is sent to `POST /me/devices` and removed on logout.
- English is the main language, with Russian and Uzbek translations (ARB files).

## Design

The screens are in the Tidy design canvas. Colours and type used everywhere:

| Token | Value |
|---|---|
| primary | `#0A7A55` |
| primarySoft | `#E3F3EC` |
| ink | `#10201B` |
| muted | `#5B6B66` |
| surface | `#F4F7F5` |
| line | `#E3E9E6` |
| accent | `#F5A524` |
| headings | Space Grotesk |
| body | Inter |

## Local setup

```bash
docker compose up -d db          # Postgres on :5432
cd backend && make migrate run   # API on :8080
cd apps/client && flutter run
```

`.env.example` in `backend/` lists every variable.

## Git

- `main` is always releasable. Work happens on `feature/…`, `fix/…`, `chore/…`
  branches and is merged with a pull request.
- Commit messages: short, imperative, lower case after the prefix,
  e.g. `feat: reject overlapping bookings in the database`.
