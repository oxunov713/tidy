package postgres

import (
	"context"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

func (s *Store) CreatePayment(ctx context.Context, p domain.Payment) error {
	_, err := s.pool.Exec(ctx, `
		INSERT INTO payments (booking_id, provider, provider_ref, amount, status)
		VALUES ($1, $2, $3, $4, $5)`, p.BookingID, p.Provider, p.Ref, p.Amount, p.Status)
	return err
}

func (s *Store) PaymentForBooking(ctx context.Context, bookingID uuid.UUID) (domain.Payment, error) {
	var p domain.Payment
	err := s.pool.QueryRow(ctx, `
		SELECT id, booking_id, provider, provider_ref, amount, status FROM payments
		WHERE booking_id = $1 ORDER BY created_at DESC LIMIT 1`, bookingID).
		Scan(&p.ID, &p.BookingID, &p.Provider, &p.Ref, &p.Amount, &p.Status)
	if isNoRows(err) {
		return p, domain.NotFound("Payment")
	}
	return p, err
}

func (s *Store) SetPaymentStatus(ctx context.Context, id uuid.UUID, status domain.PaymentStatus) error {
	_, err := s.pool.Exec(ctx, `UPDATE payments SET status = $2 WHERE id = $1`, id, status)
	return err
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
		UPDATE bookings SET status = 'confirmed', updated_at = now()
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
