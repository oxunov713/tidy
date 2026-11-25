# Tidy API

Base URL: `/api/v1`. JSON in and out. Times are RFC 3339 in UTC. Money is an
integer in pence (`6800` = £68.00).

All business times (working hours, slots, "today", plan dates) are
Europe/London. Apps format times in Europe/London (configurable with
`--dart-define=BUSINESS_TZ`), not in the device's zone.

Request bodies over 64 KB are rejected with `413 payload_too_large`.

Authenticated requests send `Authorization: Bearer <access token>`.

## Errors

Every error has the same shape:

```json
{ "error": { "code": "slot_taken", "message": "This time was just booked by someone else." } }
```

| HTTP | code | when |
|---|---|---|
| 400 | `invalid_request` | body or query failed validation (`details` lists fields) |
| 401 | `unauthorized` | missing, expired or bad token |
| 403 | `forbidden` | wrong role, or not your booking |
| 404 | `not_found` | |
| 409 | `slot_taken` | the cleaner was booked at that time |
| 409 | `invalid_transition` | e.g. finishing a booking that hasn't started; the message names the current status |
| 409 | `offer_gone` | the offer expired or another cleaner took the job |
| 413 | `payload_too_large` | request body over 64 KB |
| 429 | `too_many_requests` | OTP, sign-in or refresh rate limit |
| 500 | `internal` | anything unexpected; the request id is in the `X-Request-Id` header |

## Pagination

Paginated lists take `cursor` and `limit` (default 20, max 50) and return
`{ "items": [...], "next_cursor": "…" }`. `next_cursor` is empty on the last page.

## Auth

| Method | Path | Body | Response |
|---|---|---|---|
| POST | `/auth/otp` | `{ "phone": "+447700900123" }` | `204` |
| POST | `/auth/verify` | `{ "phone", "code", "role"?: "client" \| "cleaner" \| "admin" }` | `{ access_token, refresh_token, user }` |
| POST | `/auth/refresh` | `{ "refresh_token" }` | `{ access_token, refresh_token }` |
| POST | `/auth/logout` | `{ "refresh_token" }` | `204` |

OTP: 6 digits, valid 5 minutes, 5 attempts, max 3 requests per phone per 10 minutes.

Roles on `/auth/verify`:

- An unknown phone with `client` or `cleaner` (or no role, meaning `client`)
  signs up with that role.
- `role: "admin"` never creates an account. If the phone isn't an admin →
  `403 forbidden`. Admins are promoted in the database.
- An existing account sent a different role → `403 forbidden` with the message
  "This number is registered as a <role>." (e.g. "as a cleaner", "as an admin").
  Leaving the role out signs in with the account's own role.

Refresh tokens are rotated on every use. Presenting a refresh token again
within 10 s of its rotation returns the same new pair (a retried or racing
refresh doesn't sign anyone out). Reuse outside that window revokes every
refresh token of the user. Sign-in (`/auth/otp`, `/auth/verify`, `/auth/logout`)
is limited to 30 requests a minute per IP; `/auth/refresh` has its own limit of
60 a minute per IP.

Apps clear the stored tokens only when refresh answers `401`. Network errors,
`429` and `5xx` keep the session and show an error.

## Me

| Method | Path | Notes |
|---|---|---|
| GET | `/me` | current user (+ `cleaner` object for cleaners) |
| PATCH | `/me` | `{ full_name, email }`; name up to 80 characters |
| POST | `/me/devices` | `{ token, platform }` — FCM token |
| DELETE | `/me/devices/{token}` | `204`; called on logout. Unknown tokens are ignored |
| GET | `/me/addresses` | |
| POST | `/me/addresses` | `{ line1, line2, city, postcode, lat, lng, access_notes }`; lines up to 200 characters, city 80, postcode 12, access notes 500 |
| DELETE | `/me/addresses/{id}` | |

## Catalogue (public)

| Method | Path | Response |
|---|---|---|
| GET | `/services` | `[{ id, slug, title, from_price, minutes }]` |
| GET | `/extras` | `[{ id, slug, title, price }]` |

## Booking (client)

### `POST /quotes`

```json
{ "service_id": "…", "bedrooms": 2, "bathrooms": 1, "extra_ids": ["…"], "frequency": "weekly" }
```

No login needed. `minutes` includes the time for extras.

```json
{ "subtotal": 8000, "discount": 1200, "total": 6800, "minutes": 180,
  "lines": [ { "label": "Standard clean · 2 bed, 1 bath", "amount": 6000 },
             { "label": "Inside oven", "amount": 2000 },
             { "label": "Weekly discount (15%)", "amount": -1200 } ] }
```

### `GET /slots?service_id=&bedrooms=&bathrooms=&extra_ids=&date=2026-12-03&address_id=`

Start times on that day where at least one approved cleaner near the address is
free for the whole visit.

```json
{ "date": "2026-12-03", "slots": [ { "start": "2026-12-03T08:00:00Z", "available": true }, … ] }
```

Optional `cleaner_id` limits the check to one cleaner ("book Sarah again").

### Bookings

| Method | Path | Notes |
|---|---|---|
| POST | `/bookings` | quote fields + `{ address_id, start, cleaner_id? }` → `201 { booking, payment: { kind, client_secret } }`, see [Payments](#payments) |
| GET | `/bookings?scope=upcoming\|past&cursor=` | own bookings, paginated |
| GET | `/bookings/{id}` | includes cleaner, last location, events |
| POST | `/bookings/{id}/payment` | pay a `pending` booking again → `{ kind: "payment", client_secret }`; any other status → `409` |
| POST | `/bookings/{id}/cancel` | optional `{ "scope": "visit" \| "series" }` (default `visit`) → `{ booking, refunded, plan_ended }`. Free until 24 h before start; later the full price is charged. `series` also ends the booking's plan |
| POST | `/bookings/{id}/review` | `{ rating, tags, comment, tip }`, only after `completed`; comment up to 1,000 characters, at most 10 tags, tip 0–10,000 |
| GET | `/bookings/{id}/messages` | chat history |
| POST | `/bookings/{id}/messages` | `{ body }`, 1–2,000 characters. Closed (`409 invalid_transition`) on `cancelled` bookings and 24 h after `completed` |

Bedrooms and bathrooms are 1–10. Text limits count characters, not bytes.

### Stuck bookings

The scheduler cancels bookings that can't happen any more and sends
`booking.status` and a push to the client:

- `pending` for 30 minutes without payment → `cancelled`. The 30 minutes start
  when the client is asked to pay: on `POST /bookings`, on
  `POST /bookings/{id}/payment`, or when the saved card was declined. A booking
  whose card is saved and waiting for its 48 h authorisation doesn't time out.
- `confirmed` with no cleaner 2 h before the start → `cancelled` and refunded.

### Recurring plans

`weekly` and `fortnightly` bookings create a plan; the scheduler books each
next visit 7 days ahead.

| Method | Path | Notes |
|---|---|---|
| GET | `/plans` | the client's active plans: `[{ id, frequency, next_run_on, service_title, start_time, address_id }]`; `next_run_on` is `YYYY-MM-DD`, `start_time` `HH:MM` |
| DELETE | `/plans/{id}` | ends the series, `204`. Future visits of the plan without a cleaner yet are cancelled and refunded; the next visit is never created. Ending an ended plan is fine |

The scheduler ends a plan whose client or address is gone (deleted address)
and skips a visit while the service is switched off.

## Cleaner

| Method | Path | Notes |
|---|---|---|
| POST | `/cleaner/online` | `{ online: true, lat, lng }`; sign-out sends `{ online: false }` first |
| GET | `/cleaner/offers` | open offers sent to me: `[{ booking, expires_at, distance_km, postcode, city }]` |
| POST | `/cleaner/offers/{booking_id}/accept` | `409 slot_taken` if I'm busy then |
| POST | `/cleaner/offers/{booking_id}/decline` | |
| GET | `/cleaner/jobs?from=&to=` | my schedule |
| POST | `/cleaner/jobs/{id}/status` | `{ status: "on_the_way" \| "in_progress" \| "completed" }`; `on_the_way` from 3 h before the start |
| GET | `/cleaner/availability` | weekly hours |
| PUT | `/cleaner/availability` | `[{ weekday, start_time, end_time }]` |
| GET | `/cleaner/earnings?period=week` | `week` or `month`: `{ total, tips, jobs, minutes, days: [{ date, amount }], recent: [...] }`. `total` is without tips; `days[].amount` includes them |

Dispatch only offers jobs to online cleaners seen in the last 10 minutes
(`last_seen_at`). Going online, a location update and answering the WebSocket
heartbeat all count. A cleaner the client asked for by name is still asked
first, even offline.

Job status, chat and location from a cleaner whose profile isn't `approved`
get `403 forbidden`. Suspending a cleaner moves their jobs that haven't started
(`assigned`, `on_the_way`) back to `confirmed`, withdraws their open offers and
dispatches both again.

## Admin

| Method | Path | Notes |
|---|---|---|
| GET | `/admin/stats/today` | bookings, revenue, cleaners online, pending approvals |
| GET | `/admin/bookings?status=&q=&cursor=` | |
| PATCH | `/admin/bookings/{id}` | `{ cleaner_id }` to reassign (only `confirmed` or `assigned`) or `{ status: "cancelled" }` to cancel with a full refund (only `pending`, `confirmed` or `assigned`). Anything else → `409 invalid_transition`, e.g. "A completed booking can't be cancelled." |
| GET | `/admin/cleaners?status=` | |
| POST | `/admin/cleaners/{id}/approve` | |
| POST | `/admin/cleaners/{id}/suspend` | |
| GET | `/admin/services` | every service with all price fields, inactive ones too |
| PUT | `/admin/services/{id}` | `{ title, base_price, per_bedroom, per_bathroom, base_minutes, minutes_per_room, is_active }`, every field required. Prices 1–1,000,000 pence, minutes 1–1,440, title 1–80 characters |

## Payments

`POST /bookings` answers `payment: { kind, client_secret }`:

- Start within 5 days → `kind: "payment"`: a manual-capture PaymentIntent. The
  app confirms it with the client secret; the booking is `confirmed` once the
  money is held.
- Start later → `kind: "setup"`: a SetupIntent that saves the card. The booking
  stays `pending`; 48 h before the visit the scheduler authorises the saved card
  off-session and the booking becomes `confirmed`.
- Visits the scheduler books from a plan always use the saved card off-session
  48 h before (the first visit saves the card).

If an off-session authorisation fails, the booking stays `pending`, the client
gets a push and `booking.status`, and can pay with `POST /bookings/{id}/payment`
→ `{ kind: "payment", client_secret }`.

A declined card doesn't cancel the booking: the client can retry in the same
payment sheet. Only `payment_intent.canceled` for the booking's current intent
cancels it.

`POST /webhooks/stripe` — Stripe calls this; checked with the signing secret.
Handled events: `payment_intent.amount_capturable_updated`,
`payment_intent.payment_failed`, `payment_intent.canceled`,
`setup_intent.succeeded`, `setup_intent.setup_failed`.

The mock provider (`PAYMENT_PROVIDER=mock`) answers with the same shape (`kind`
and a fake secret) and succeeds at once: a payment is authorised and a card
saved right after `POST /bookings`.

## WebSocket

`GET /ws?token=<access token>`

Client → server:

```json
{ "type": "subscribe", "room": "booking:3f2c…" }
{ "type": "unsubscribe", "room": "booking:3f2c…" }
{ "type": "location", "booking_id": "3f2c…", "lat": 51.52, "lng": -0.15 }
```

Server → client:

```json
{ "type": "booking.status", "booking_id": "…", "status": "on_the_way", "at": "…" }
{ "type": "cleaner.location", "booking_id": "…", "lat": 51.52, "lng": -0.15, "eta_minutes": 12 }
{ "type": "offer.new", "booking": { … }, "expires_at": "…" }
{ "type": "offer.gone", "booking_id": "…" }
{ "type": "message.new", "booking_id": "…", "message": { … } }
{ "type": "subscribed", "room": "booking:3f2c…" }
{ "type": "unsubscribed", "room": "booking:3f2c…" }
{ "type": "unsubscribed", "room": "booking:3f2c…", "reason": "access_revoked" }
{ "type": "error", "code": "forbidden", "message": "…" }
```

Only the client and the assigned, approved cleaner can join `booking:<id>`;
the cleaner loses access when the booking is cancelled. When someone loses
access to a booking room (reassign, cancel, suspend), the server removes them
and sends `unsubscribed` with `reason: "access_revoked"`. Access is also checked
again before every message to a booking room.

Room subscriptions are reference-counted on the client (`RealtimeClient` in
tidy_core): two screens can watch the same room and closing one keeps the
other. `RealtimeClient` emits a `Reconnected` event after a reconnect, so
screens refetch state they may have missed. Cleaners get
`offer.*` after subscribing to the `cleaner:offers` room. `location` is accepted
only while the booking is `assigned` or `on_the_way`; otherwise the server
answers with an `error` message (`invalid_transition`). The server pings every 30 s and drops silent connections after 60 s.
