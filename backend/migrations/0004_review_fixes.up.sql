-- Fixes from the first review: plans that can end.

ALTER TABLE booking_plans ADD COLUMN ended_at timestamptz;

CREATE INDEX booking_plans_client_idx ON booking_plans (client_id) WHERE is_active;
CREATE INDEX bookings_plan_idx ON bookings (plan_id) WHERE plan_id IS NOT NULL;
