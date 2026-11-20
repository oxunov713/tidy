-- Initial schema for Tidy.
-- Double booking is blocked by the database itself (see bookings_no_overlap),
-- so the API never has to rely on "check then insert" in application code.

CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE user_role AS ENUM ('client', 'cleaner', 'admin');
CREATE TYPE cleaner_status AS ENUM ('pending', 'approved', 'suspended');
CREATE TYPE booking_status AS ENUM (
    'pending',      -- created, waiting for payment authorisation
    'confirmed',    -- paid (authorised), waiting for a cleaner
    'assigned',     -- cleaner accepted
    'on_the_way',
    'in_progress',
    'completed',
    'cancelled'
);
CREATE TYPE payment_status AS ENUM ('requires_action', 'authorized', 'captured', 'refunded', 'failed');
CREATE TYPE frequency AS ENUM ('once', 'weekly', 'fortnightly');

CREATE TABLE users (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phone       text UNIQUE NOT NULL,
    full_name   text NOT NULL DEFAULT '',
    email       text,
    role        user_role NOT NULL DEFAULT 'client',
    avatar_url  text,
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE otp_codes (
    phone       text NOT NULL,
    code_hash   text NOT NULL,
    expires_at  timestamptz NOT NULL,
    attempts    int NOT NULL DEFAULT 0,
    PRIMARY KEY (phone)
);

CREATE TABLE refresh_tokens (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  text UNIQUE NOT NULL,
    expires_at  timestamptz NOT NULL,
    revoked_at  timestamptz
);

CREATE TABLE cleaners (
    user_id       uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    status        cleaner_status NOT NULL DEFAULT 'pending',
    bio           text NOT NULL DEFAULT '',
    rating_sum    int NOT NULL DEFAULT 0,
    rating_count  int NOT NULL DEFAULT 0,
    is_online     boolean NOT NULL DEFAULT false,
    last_lat      double precision,
    last_lng      double precision,
    last_seen_at  timestamptz
);

-- Weekly working hours, e.g. Monday 08:00-17:00.
CREATE TABLE cleaner_availability (
    cleaner_id  uuid NOT NULL REFERENCES cleaners(user_id) ON DELETE CASCADE,
    weekday     smallint NOT NULL CHECK (weekday BETWEEN 0 AND 6), -- 0 = Monday
    start_time  time NOT NULL,
    end_time    time NOT NULL CHECK (end_time > start_time),
    PRIMARY KEY (cleaner_id, weekday)
);

CREATE TABLE services (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug            text UNIQUE NOT NULL,
    title           text NOT NULL,
    base_price      int NOT NULL,          -- pence, covers 1 bed + 1 bath
    per_bedroom     int NOT NULL,
    per_bathroom    int NOT NULL,
    base_minutes    int NOT NULL,
    minutes_per_room int NOT NULL,
    is_active       boolean NOT NULL DEFAULT true,
    sort_order      int NOT NULL DEFAULT 0
);

CREATE TABLE service_extras (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug        text UNIQUE NOT NULL,
    title       text NOT NULL,
    price       int NOT NULL,
    minutes     int NOT NULL DEFAULT 0
);

CREATE TABLE addresses (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    line1       text NOT NULL,
    line2       text NOT NULL DEFAULT '',
    city        text NOT NULL,
    postcode    text NOT NULL,
    lat         double precision NOT NULL,
    lng         double precision NOT NULL,
    access_notes text NOT NULL DEFAULT ''
);

-- A recurring plan creates future bookings through the scheduler.
CREATE TABLE booking_plans (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id   uuid NOT NULL REFERENCES users(id),
    frequency   frequency NOT NULL CHECK (frequency <> 'once'),
    template    jsonb NOT NULL,           -- service, rooms, extras, address, start time
    next_run_on date NOT NULL,
    is_active   boolean NOT NULL DEFAULT true
);

CREATE TABLE bookings (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code          text UNIQUE NOT NULL,   -- human friendly, e.g. TD-1042
    client_id     uuid NOT NULL REFERENCES users(id),
    cleaner_id    uuid REFERENCES cleaners(user_id),
    service_id    uuid NOT NULL REFERENCES services(id),
    address_id    uuid NOT NULL REFERENCES addresses(id),
    plan_id       uuid REFERENCES booking_plans(id),
    bedrooms      smallint NOT NULL CHECK (bedrooms BETWEEN 1 AND 10),
    bathrooms     smallint NOT NULL CHECK (bathrooms BETWEEN 1 AND 10),
    frequency     frequency NOT NULL DEFAULT 'once',
    period        tstzrange NOT NULL,     -- start and end of the visit
    status        booking_status NOT NULL DEFAULT 'pending',
    subtotal      int NOT NULL,
    discount      int NOT NULL DEFAULT 0,
    total         int NOT NULL,
    cleaner_payout int NOT NULL,
    created_at    timestamptz NOT NULL DEFAULT now(),
    updated_at    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT total_matches CHECK (total = subtotal - discount),
    -- One cleaner can't be in two places at once. Cancelled and unassigned
    -- bookings don't count.
    CONSTRAINT bookings_no_overlap EXCLUDE USING gist (
        cleaner_id WITH =,
        period WITH &&
    ) WHERE (cleaner_id IS NOT NULL AND status <> 'cancelled')
);

CREATE INDEX bookings_client_idx ON bookings (client_id, lower(period) DESC);
CREATE INDEX bookings_status_idx ON bookings (status, lower(period));

CREATE TABLE booking_extras (
    booking_id  uuid NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    extra_id    uuid NOT NULL REFERENCES service_extras(id),
    price       int NOT NULL,             -- price at the moment of booking
    PRIMARY KEY (booking_id, extra_id)
);

CREATE TABLE booking_events (
    id          bigserial PRIMARY KEY,
    booking_id  uuid NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    status      booking_status NOT NULL,
    actor_id    uuid REFERENCES users(id),
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE payments (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id      uuid NOT NULL REFERENCES bookings(id),
    provider        text NOT NULL,        -- 'stripe' or 'mock'
    provider_ref    text NOT NULL,        -- PaymentIntent id
    amount          int NOT NULL,
    currency        text NOT NULL DEFAULT 'gbp',
    status          payment_status NOT NULL,
    created_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE (provider, provider_ref)
);

-- Webhooks can arrive twice; we store every event id we've handled.
CREATE TABLE processed_webhooks (
    provider    text NOT NULL,
    event_id    text NOT NULL,
    processed_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (provider, event_id)
);

CREATE TABLE reviews (
    booking_id  uuid PRIMARY KEY REFERENCES bookings(id),
    cleaner_id  uuid NOT NULL REFERENCES cleaners(user_id),
    rating      smallint NOT NULL CHECK (rating BETWEEN 1 AND 5),
    tags        text[] NOT NULL DEFAULT '{}',
    comment     text NOT NULL DEFAULT '',
    tip         int NOT NULL DEFAULT 0,
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE device_tokens (
    token       text PRIMARY KEY,
    user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    platform    text NOT NULL CHECK (platform IN ('android', 'ios', 'web')),
    updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE messages (
    id          bigserial PRIMARY KEY,
    booking_id  uuid NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    sender_id   uuid NOT NULL REFERENCES users(id),
    body        text NOT NULL CHECK (length(body) BETWEEN 1 AND 2000),
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE SEQUENCE booking_code_seq START 1000;
