# Tidy backend

Go service behind the Tidy apps: REST API, WebSocket, booking dispatch,
payments and push. The contract is in [docs/API.md](../docs/API.md) and the
design in [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md).

## Run locally

With Docker:

```bash
docker compose up --build                            # from the repo root; API on :8080
docker compose run --rm --entrypoint /seed api       # demo accounts
```

Without Docker you need Go 1.24 and PostgreSQL 16:

```bash
cd backend
cp .env.example .env          # set DATABASE_URL and JWT_SECRET
make migrate seed run
```

Log in as one of the demo accounts the seed prints, e.g. the client:

```bash
curl -X POST localhost:8080/api/v1/auth/otp -d '{"phone":"+447700900201"}'
# the code is in the API log: msg="login code" phone=+447700900201 code=123456
curl -X POST localhost:8080/api/v1/auth/verify -d '{"phone":"+447700900201","code":"123456"}'
```

`PAYMENT_PROVIDER=mock` succeeds at every payment instantly, so a booking
within 5 days is confirmed and offered to a cleaner as soon as it is created.
Later bookings save the card and are confirmed by the scheduler 48 h before
the visit. For Stripe test
mode set `PAYMENT_PROVIDER=stripe` and the two `STRIPE_*` keys, and forward
webhooks with `stripe listen --forward-to localhost:8080/api/v1/webhooks/stripe`.

## Tests

```bash
make test-unit                                     # no database needed
TEST_DATABASE_URL=postgres://... make test         # adds the Postgres integration tests
make lint
```

The integration tests migrate the database in `TEST_DATABASE_URL` and wipe
its tables, so point it at a database used only for tests.

## Layout

| Path | What lives there |
|---|---|
| `cmd/api` | wiring and graceful shutdown |
| `cmd/migrate`, `cmd/seed` | apply migrations, create demo data |
| `internal/domain` | entities, errors, pricing, booking state machine |
| `internal/service` | use cases and the interfaces they need (`ports.go`) |
| `internal/store/postgres` | pgx implementation of those interfaces |
| `internal/httpapi` | router, middleware, handlers |
| `internal/realtime` | WebSocket hub |
| `internal/payment`, `internal/push` | Stripe/mock and FCM/log adapters |
| `internal/scheduler` | recurring bookings, offer expiry, saved-card charges, stuck bookings |
| `migrations` | SQL migrations, embedded in the binary |
