package postgres

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

func (s *Store) CreatePayment(ctx context.Context, p domain.Payment) error {
	if p.Kind == "" {
		p.Kind = domain.PaymentKindPayment
	}
	_, err := s.pool.Exec(ctx, `
		INSERT INTO payments (booking_id, provider, kind, provider_ref, amount, status)
		VALUES ($1, $2, $3, $4, $5, $6)`, p.BookingID, p.Provider, p.Kind, p.Ref, p.Amount, p.Status)
	return err
}

func (s *Store) PaymentForBooking(ctx context.Context, bookingID uuid.UUID) (domain.Payment, error) {
	var p domain.Payment
	err := s.pool.QueryRow(ctx, `
		SELECT id, booking_id, provider, kind, provider_ref, amount, status FROM payments
		WHERE booking_id = $1 ORDER BY created_at DESC LIMIT 1`, bookingID).
		Scan(&p.ID, &p.BookingID, &p.Provider, &p.Kind, &p.Ref, &p.Amount, &p.Status)
	if isNoRows(err) {
		return p, domain.NotFound("Payment")
	}
	return p, err
}

func (s *Store) CountPayments(ctx context.Context, bookingID uuid.UUID) (int, error) {
	var n int
	err := s.pool.QueryRow(ctx, `SELECT count(*) FROM payments WHERE booking_id = $1`, bookingID).Scan(&n)
	return n, err
}

func (s *Store) SetPaymentStatus(ctx context.Context, id uuid.UUID, status domain.PaymentStatus) error {
	_, err := s.pool.Exec(ctx, `UPDATE payments SET status = $2 WHERE id = $1`, id, status)
	return err
}

func (s *Store) PaymentCustomer(ctx context.Context, userID uuid.UUID, provider string) (string, error) {
	var ref string
	err := s.pool.QueryRow(ctx, `
		SELECT customer_ref FROM payment_customers WHERE user_id = $1 AND provider = $2`, userID, provider).Scan(&ref)
	if isNoRows(err) {
		return "", domain.NotFound("Payment customer")
	}
	return ref, err
}

func (s *Store) SavePaymentCustomer(ctx context.Context, userID uuid.UUID, provider, ref string) (string, error) {
	// The no-op update makes RETURNING give the stored value on a conflict.
	err := s.pool.QueryRow(ctx, `
		INSERT INTO payment_customers (user_id, provider, customer_ref) VALUES ($1, $2, $3)
		ON CONFLICT (user_id, provider) DO UPDATE SET customer_ref = payment_customers.customer_ref
		RETURNING customer_ref`, userID, provider, ref).Scan(&ref)
	return ref, err
}

func (s *Store) ScheduleAuthorization(ctx context.Context, bookingID uuid.UUID, at *time.Time) error {
	_, err := s.pool.Exec(ctx, `UPDATE bookings SET authorize_at = $2 WHERE id = $1`, bookingID, at)
	return err
}

func (s *Store) ClaimAuthorizations(ctx context.Context, now time.Time, limit int) ([]domain.Booking, error) {
	var out []domain.Booking
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		rows, err := tx.Query(ctx, `
			UPDATE bookings SET authorize_at = NULL
			WHERE id IN (
				SELECT id FROM bookings
				WHERE status = 'pending' AND authorize_at <= $1
				ORDER BY authorize_at LIMIT $2 FOR UPDATE SKIP LOCKED)
			RETURNING id`, now, limit)
		if err != nil {
			return err
		}
		ids, err := pgx.CollectRows(rows, pgx.RowTo[uuid.UUID])
		if err != nil || len(ids) == 0 {
			return err
		}
		out, err = queryBookings(ctx, tx, `SELECT `+bookingColumns+bookingFrom+`
			WHERE b.id = ANY($1::uuid[]) ORDER BY lower(b.period)`, uuidStrings(ids))
		return err
	})
	return out, err
}

func (s *Store) ApplyPaymentEvent(ctx context.Context, provider string, ev domain.PaymentEvent) (service.AppliedPayment, error) {
	var out service.AppliedPayment
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		if ev.ID != "" {
			tag, err := tx.Exec(ctx, `
				INSERT INTO processed_webhooks (provider, event_id) VALUES ($1, $2)
				ON CONFLICT DO NOTHING`, provider, ev.ID)
			if err != nil || tag.RowsAffected() == 0 {
				return err
			}
		}
		switch ev.Kind {
		case domain.PaymentEventAuthorized:
			return applyAuthorized(ctx, tx, provider, ev.Ref, &out)
		case domain.PaymentEventFailed:
			// The client retries in the same payment sheet; nothing else changes.
			_, err := tx.Exec(ctx, `
				UPDATE payments SET status = 'failed'
				WHERE provider = $1 AND provider_ref = $2 AND status = 'requires_action'`, provider, ev.Ref)
			return err
		case domain.PaymentEventSaved:
			// The money is held AuthorizeAhead before the visit; until then
			// the booking stays pending.
			_, err := tx.Exec(ctx, `
				WITH saved AS (
					UPDATE payments SET status = 'saved'
					WHERE provider = $1 AND provider_ref = $2 AND kind = 'setup' AND status IN ('requires_action', 'failed')
					RETURNING booking_id)
				UPDATE bookings b SET authorize_at = lower(b.period) - make_interval(secs => $3)
				FROM saved WHERE b.id = saved.booking_id AND b.status = 'pending'`,
				provider, ev.Ref, domain.AuthorizeAhead.Seconds())
			return err
		case domain.PaymentEventCanceled:
			return applyCanceled(ctx, tx, provider, ev.Ref, &out)
		}
		return nil
	})
	return out, err
}

func applyAuthorized(ctx context.Context, tx pgx.Tx, provider, ref string, out *service.AppliedPayment) error {
	var bookingID uuid.UUID
	err := tx.QueryRow(ctx, `
		UPDATE payments SET status = 'authorized'
		WHERE provider = $1 AND provider_ref = $2 AND status IN ('requires_action', 'failed')
		RETURNING booking_id`, provider, ref).Scan(&bookingID)
	if isNoRows(err) {
		// Unknown intent, or already handled through another event.
		return nil
	}
	if err != nil {
		return err
	}
	tag, err := tx.Exec(ctx, `
		UPDATE bookings SET status = 'confirmed', authorize_at = NULL, updated_at = now()
		WHERE id = $1 AND status = 'pending'`, bookingID)
	if err != nil || tag.RowsAffected() == 0 {
		return err
	}
	if err := addEvent(ctx, tx, bookingID, domain.StatusConfirmed, nil); err != nil {
		return err
	}
	b, err := getBooking(ctx, tx, bookingID)
	out.Booking = &b
	return err
}

// applyCanceled cancels the booking when the intent that went away is the
// one the booking relies on. An older intent the client replaced doesn't count.
func applyCanceled(ctx context.Context, tx pgx.Tx, provider, ref string, out *service.AppliedPayment) error {
	var bookingID uuid.UUID
	var latest bool
	err := tx.QueryRow(ctx, `
		UPDATE payments p SET status = 'canceled'
		WHERE provider = $1 AND provider_ref = $2 AND status IN ('requires_action', 'failed', 'authorized')
		RETURNING booking_id, NOT EXISTS (
			SELECT 1 FROM payments n WHERE n.booking_id = p.booking_id AND n.created_at > p.created_at)`,
		provider, ref).Scan(&bookingID, &latest)
	if isNoRows(err) || (err == nil && !latest) {
		return nil
	}
	if err != nil {
		return err
	}
	var status domain.BookingStatus
	if err := tx.QueryRow(ctx, `SELECT status FROM bookings WHERE id = $1 FOR UPDATE`, bookingID).Scan(&status); err != nil {
		return err
	}
	if !status.CanTransitionTo(domain.StatusCancelled) {
		return nil
	}
	if err := setStatus(ctx, tx, bookingID, status, domain.StatusCancelled, nil); err != nil {
		return err
	}
	if out.Withdrawn, err = withdrawOffers(ctx, tx, bookingID); err != nil {
		return err
	}
	b, err := getBooking(ctx, tx, bookingID)
	out.Booking = &b
	return err
}
