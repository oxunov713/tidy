# Contract changes after review #1

Both the backend and the apps implement exactly this. When the backend work
lands, these sections move into API.md and this file is deleted.

## Recurring plans

- `GET /plans` — the client's active plans: `[{ id, frequency, next_run_on, service_title, start_time, address_id }]`.
- `DELETE /plans/{id}` — ends the series. `204`. Future bookings of the plan
  that have no cleaner yet are cancelled and refunded; the next run is never created.
- `POST /bookings/{id}/cancel` takes an optional body `{ "scope": "visit" | "series" }`
  (default `visit`). `series` also ends the plan. Response:
  `{ booking, refunded, plan_ended }`.
- The scheduler skips plans whose client, address or service is no longer usable.

## Payments

- `POST /bookings` returns `payment: { kind: "payment" | "setup", client_secret }`.
  - Start within 5 days → `payment`: a manual-capture PaymentIntent, as today.
  - Start later → `setup`: a SetupIntent that saves the card. 48 h before the
    visit the scheduler authorises the saved card off-session.
  - Recurring visits always use the saved card off-session.
- If an off-session authorisation fails, the booking stays `pending`, the
  client is notified (push + `booking.status`), and can pay with
  `POST /bookings/{id}/payment` → `{ kind: "payment", client_secret }`.
- A declined card no longer cancels the booking. Only `payment_intent.canceled`
  does. The client can retry in the same sheet.
- Mock provider follows the same shape (`kind` and a fake secret) and succeeds instantly.

## Stuck bookings

- `pending` for 30 minutes without payment → `cancelled`.
- `confirmed` with no cleaner 2 h before start → `cancelled` and refunded.
- Both emit `booking.status` and a push to the client.

## Auth

- `role: "admin"` in `/auth/verify` never creates an account. If the phone isn't
  an admin → `403 forbidden`.
- If an existing account has a different role than the one sent →
  `403 forbidden` with message "This number is registered as a <role>."
  Unknown phone + `client`/`cleaner` signs up as before.
- Refresh: reusing a refresh token within 10 s of its rotation returns the same
  new pair (no family revoke). Outside the grace window reuse still revokes.
  `/auth/refresh` has its own limit (60/min per IP), separate from login.
- Apps clear tokens only when refresh answers `401`. Network errors, `429` and
  `5xx` keep the session and surface an error.
- `DELETE /me/devices/{token}` — `204`, called on logout.

## Cleaners

- Sign-out calls `POST /cleaner/online { online: false }` first.
- Dispatch skips cleaners not seen for 10 minutes (`last_seen_at`).
- Suspending a cleaner moves their future jobs back to `confirmed` and
  re-dispatches them. Job actions, chat and location from a cleaner who isn't
  `approved` get `403 forbidden`.

## Real-time

- When someone loses access to a booking room (reassign, cancel, suspend),
  the server removes them and sends
  `{ "type": "unsubscribed", "room": "booking:<id>", "reason": "access_revoked" }`.
- Room subscriptions are reference-counted on the client (`RealtimeClient` in
  tidy_core): two screens can watch the same room and closing one keeps the other.
- `RealtimeClient` emits a `Reconnected` event after a reconnect, so screens
  refetch state they may have missed.

## Validation

- `PUT /admin/services/{id}`: every field required. Prices 1–1,000,000 pence,
  minutes 1–1,440, title 1–80 chars.
- Strings: address lines 200, city 80, postcode 12, access notes 500,
  names 80, bio 500, chat 2,000, review comment 1,000. Bedrooms/bathrooms 1–10, tip 0–10,000 pence.
- Request bodies over 64 KB → `413`.

## Admin rules

- Reassign: only `confirmed` or `assigned`. Cancel: only `pending`, `confirmed`
  or `assigned`. Anything else → `409 invalid_transition` with a message that
  names the current status, e.g. "A completed booking can't be cancelled."
- Chat is closed on `cancelled` bookings and 24 h after `completed` → `409 invalid_transition`.

## Time

All business times are Europe/London. Apps format times in Europe/London
(configurable via `--dart-define=BUSINESS_TZ`), not in the device zone.
