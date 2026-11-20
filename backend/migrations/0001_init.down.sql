DROP SEQUENCE IF EXISTS booking_code_seq;
DROP TABLE IF EXISTS messages, device_tokens, reviews, processed_webhooks, payments,
    booking_events, booking_extras, bookings, booking_plans, addresses,
    service_extras, services, cleaner_availability, cleaners, refresh_tokens,
    otp_codes, users;
DROP TYPE IF EXISTS frequency, payment_status, booking_status, cleaner_status, user_role;
