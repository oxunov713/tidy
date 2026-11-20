DROP INDEX IF EXISTS booking_plans_due_idx;
DROP INDEX IF EXISTS payments_booking_idx;
DROP INDEX IF EXISTS refresh_tokens_user_idx;
DROP INDEX IF EXISTS bookings_cleaner_idx;
ALTER TABLE addresses DROP COLUMN IF EXISTS deleted_at;
ALTER TABLE bookings DROP COLUMN IF EXISTS requested_cleaner_id;
DROP TABLE IF EXISTS booking_locations;
DROP TABLE IF EXISTS otp_requests;
DROP TABLE IF EXISTS booking_offers;
DROP TYPE IF EXISTS offer_status;
-- Postgres can't drop an enum value; 'canceled' stays in payment_status.
