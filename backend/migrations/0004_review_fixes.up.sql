-- Fixes from the first review: plans that can end, and payments for visits
-- booked further ahead than a card hold lasts.

ALTER TABLE booking_plans ADD COLUMN ended_at timestamptz;

CREATE INDEX booking_plans_client_idx ON booking_plans (client_id) WHERE is_active;
CREATE INDEX bookings_plan_idx ON bookings (plan_id) WHERE plan_id IS NOT NULL;

-- 'saved': a SetupIntent saved the card, nothing is held yet.
ALTER TYPE payment_status ADD VALUE IF NOT EXISTS 'saved';

-- A payment row is either a PaymentIntent or a SetupIntent.
ALTER TABLE payments ADD COLUMN kind text NOT NULL DEFAULT 'payment' CHECK (kind IN ('payment', 'setup'));

-- When the scheduler should hold the money on the saved card.
ALTER TABLE bookings ADD COLUMN authorize_at timestamptz;
CREATE INDEX bookings_authorize_idx ON bookings (authorize_at) WHERE authorize_at IS NOT NULL;

-- The provider's customer for a user, so a card saved once can be used again.
CREATE TABLE payment_customers (
    user_id      uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider     text NOT NULL,
    customer_ref text NOT NULL,
    created_at   timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, provider)
);
