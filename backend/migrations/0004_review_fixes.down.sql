DROP INDEX IF EXISTS bookings_plan_idx;
DROP INDEX IF EXISTS booking_plans_client_idx;
ALTER TABLE booking_plans DROP COLUMN IF EXISTS ended_at;
