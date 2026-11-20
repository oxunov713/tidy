# Tidy

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
