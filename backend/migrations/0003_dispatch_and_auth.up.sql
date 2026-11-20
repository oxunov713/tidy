-- Dispatch offers, OTP rate limiting, live location and a few columns the
-- API needs on top of the initial schema.

ALTER TYPE payment_status ADD VALUE IF NOT EXISTS 'canceled';

CREATE TYPE offer_status AS ENUM ('open', 'accepted', 'declined', 'expired', 'withdrawn');

-- One row per cleaner we asked about a booking. A cleaner is never asked
-- twice about the same booking.
CREATE TABLE booking_offers (
    booking_id  uuid NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    cleaner_id  uuid NOT NULL REFERENCES cleaners(user_id) ON DELETE CASCADE,
    status      offer_status NOT NULL DEFAULT 'open',
    distance_km double precision NOT NULL DEFAULT 0,
    expires_at  timestamptz NOT NULL,
    created_at  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (booking_id, cleaner_id)
);

CREATE INDEX booking_offers_open_idx ON booking_offers (expires_at) WHERE status = 'open';
CREATE INDEX booking_offers_cleaner_open_idx ON booking_offers (cleaner_id) WHERE status = 'open';

-- Every OTP request, for the "3 per phone per 10 minutes" limit.
CREATE TABLE otp_requests (
    phone       text NOT NULL,
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX otp_requests_phone_idx ON otp_requests (phone, created_at);

-- Only the latest point is kept; the live track goes over the WebSocket.
CREATE TABLE booking_locations (
    booking_id  uuid PRIMARY KEY REFERENCES bookings(id) ON DELETE CASCADE,
    lat         double precision NOT NULL,
    lng         double precision NOT NULL,
    recorded_at timestamptz NOT NULL DEFAULT now()
);

-- "Book Sarah again": the dispatcher offers the job to this cleaner first.
ALTER TABLE bookings ADD COLUMN requested_cleaner_id uuid REFERENCES cleaners(user_id);

-- Bookings keep pointing at deleted addresses, so they are only hidden.
ALTER TABLE addresses ADD COLUMN deleted_at timestamptz;

CREATE INDEX bookings_cleaner_idx ON bookings (cleaner_id, lower(period)) WHERE cleaner_id IS NOT NULL;
CREATE INDEX refresh_tokens_user_idx ON refresh_tokens (user_id);
CREATE INDEX payments_booking_idx ON payments (booking_id);
CREATE INDEX booking_plans_due_idx ON booking_plans (next_run_on) WHERE is_active;
