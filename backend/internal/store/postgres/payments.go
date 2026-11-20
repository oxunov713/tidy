package postgres

import (
	"context"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
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

func (s *Store) ApplyPaymentEvent(ctx context.Context, provider string, ev domain.PaymentEvent) (*domain.Booking, error) {
	var changed *domain.Booking
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		if ev.ID != "" {
			tag, err := tx.Exec(ctx, `
				INSERT INTO processed_webhooks (provider, event_id) VALUES ($1, $2)
				ON CONFLICT DO NOTHING`, provider, ev.ID)
			if err != nil || tag.RowsAffected() == 0 {
				return err
			}
		}

		var paymentStatus domain.PaymentStatus
		var bookingTo domain.BookingStatus
		switch ev.Kind {
		case domain.PaymentEventAuthorized:
			paymentStatus, bookingTo = domain.PaymentAuthorized, domain.StatusConfirmed
		case domain.PaymentEventFailed:
			paymentStatus, bookingTo = domain.PaymentFailed, domain.StatusCancelled
		default:
			return nil
		}

		var bookingID uuid.UUID
		err := tx.QueryRow(ctx, `
			UPDATE payments SET status = $3
			WHERE provider = $1 AND provider_ref = $2 AND status = 'requires_action'
			RETURNING booking_id`, provider, ev.Ref, paymentStatus).Scan(&bookingID)
		if isNoRows(err) {
			// Unknown intent, or already handled through another event.
			return nil
		}
		if err != nil {
			return err
		}

		tag, err := tx.Exec(ctx, `
			UPDATE bookings SET status = $2, updated_at = now()
			WHERE id = $1 AND status = 'pending'`, bookingID, bookingTo)
		if err != nil || tag.RowsAffected() == 0 {
			return err
		}
		if err := addEvent(ctx, tx, bookingID, bookingTo, nil); err != nil {
			return err
		}
		b, err := getBooking(ctx, tx, bookingID)
		changed = &b
		return err
	})
	return changed, err
}
