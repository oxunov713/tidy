# Tidy API

Base URL: `/api/v1`. JSON in and out. Times are RFC 3339 in UTC. Money is an
integer in pence (`6800` = £68.00).

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
| 409 | `invalid_transition` | e.g. finishing a booking that hasn't started |
| 409 | `offer_gone` | the offer expired or another cleaner took the job |
| 429 | `too_many_requests` | OTP or login rate limit |
| 500 | `internal` | anything unexpected; the request id is in the `X-Request-Id` header |

## Pagination

Paginated lists take `cursor` and `limit` (default 20, max 50) and return
`{ "items": [...], "next_cursor": "…" }`. `next_cursor` is empty on the last page.

## Auth

| Method | Path | Body | Response |
|---|---|---|---|
| POST | `/auth/otp` | `{ "phone": "+447700900123" }` | `204` |
| POST | `/auth/verify` | `{ "phone", "code", "role": "client" \| "cleaner" }` | `{ access_token, refresh_token, user }` |
| POST | `/auth/refresh` | `{ "refresh_token" }` | `{ access_token, refresh_token }` |
| POST | `/auth/logout` | `{ "refresh_token" }` | `204` |

OTP: 6 digits, valid 5 minutes, 5 attempts, max 3 requests per phone per 10 minutes.

`role` only matters the first time a phone number signs up. Leave it out for
existing accounts and for admins (admins are promoted in the database, the API
never creates one).

## Me

| Method | Path | Notes |
|---|---|---|
| GET | `/me` | current user (+ `cleaner` object for cleaners) |
| PATCH | `/me` | `{ full_name, email }` |
| POST | `/me/devices` | `{ token, platform }` — FCM token |
| GET | `/me/addresses` | |
| POST | `/me/addresses` | `{ line1, line2, city, postcode, lat, lng, access_notes }` |
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
| POST | `/bookings` | quote fields + `{ address_id, start, cleaner_id? }` → `201 { booking, payment: { client_secret } }` |
| GET | `/bookings?scope=upcoming\|past&cursor=` | own bookings, paginated |
| GET | `/bookings/{id}` | includes cleaner, last location, events |
| POST | `/bookings/{id}/cancel` | `{ booking, refunded }`. Free until 24 h before start; later the full price is charged |
| POST | `/bookings/{id}/review` | `{ rating, tags, comment, tip }`, only after `completed` |
| GET | `/bookings/{id}/messages` | chat history |
| POST | `/bookings/{id}/messages` | `{ body }` |

## Cleaner

| Method | Path | Notes |
|---|---|---|
| POST | `/cleaner/online` | `{ online: true, lat, lng }` |
| GET | `/cleaner/offers` | open offers sent to me: `[{ booking, expires_at, distance_km, postcode, city }]` |
| POST | `/cleaner/offers/{booking_id}/accept` | `409 slot_taken` if I'm busy then |
| POST | `/cleaner/offers/{booking_id}/decline` | |
| GET | `/cleaner/jobs?from=&to=` | my schedule |
| POST | `/cleaner/jobs/{id}/status` | `{ status: "on_the_way" \| "in_progress" \| "completed" }`; `on_the_way` from 3 h before the start |
| GET | `/cleaner/availability` | weekly hours |
| PUT | `/cleaner/availability` | `[{ weekday, start_time, end_time }]` |
| GET | `/cleaner/earnings?period=week` | `week` or `month`: `{ total, tips, jobs, minutes, days: [{ date, amount }], recent: [...] }`. `total` is without tips; `days[].amount` includes them |

## Admin

| Method | Path | Notes |
|---|---|---|
| GET | `/admin/stats/today` | bookings, revenue, cleaners online, pending approvals |
| GET | `/admin/bookings?status=&q=&cursor=` | |
| PATCH | `/admin/bookings/{id}` | reassign cleaner or cancel |
| GET | `/admin/cleaners?status=` | |
| POST | `/admin/cleaners/{id}/approve` | |
| POST | `/admin/cleaners/{id}/suspend` | |
| GET | `/admin/services` | every service with all price fields, inactive ones too |
| PUT | `/admin/services/{id}` | prices and duration |

## Payments

`POST /webhooks/stripe` — Stripe calls this; checked with the signing secret.
In mock mode the payment is authorised right after `POST /bookings`.

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
{ "type": "error", "code": "forbidden", "message": "…" }
```

Only the client and the assigned cleaner can join `booking:<id>`. Cleaners get
`offer.*` after subscribing to the `cleaner:offers` room. `location` is accepted
only while the booking is `assigned` or `on_the_way`; otherwise the server
answers with an `error` message (`invalid_transition`). The server pings every 30 s and drops silent connections after 60 s.
