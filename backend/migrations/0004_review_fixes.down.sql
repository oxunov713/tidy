ALTER TABLE refresh_tokens DROP COLUMN IF EXISTS replaced_by;
DROP TABLE IF EXISTS payment_customers;
DROP INDEX IF EXISTS bookings_authorize_idx;
ALTER TABLE bookings DROP COLUMN IF EXISTS authorize_at;
ALTER TABLE payments DROP COLUMN IF EXISTS kind;
-- Postgres can't drop an enum value; 'saved' stays in payment_status.
DROP INDEX IF EXISTS bookings_plan_idx;
DROP INDEX IF EXISTS booking_plans_client_idx;
ALTER TABLE booking_plans DROP COLUMN IF EXISTS ended_at;
