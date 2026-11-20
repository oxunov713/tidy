package postgres

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

func (s *Store) CreateOffer(ctx context.Context, o domain.Offer) (bool, error) {
	created := false
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		// Locking the booking serialises dispatchers working on it, which
		// keeps "one open offer per booking" true.
		var status domain.BookingStatus
		err := tx.QueryRow(ctx, `SELECT status FROM bookings WHERE id = $1 FOR UPDATE`, o.BookingID).Scan(&status)
		if isNoRows(err) {
			return domain.NotFound("Booking")
		}
		if err != nil || status != domain.StatusConfirmed {
			return err
		}
		tag, err := tx.Exec(ctx, `
			INSERT INTO booking_offers (booking_id, cleaner_id, distance_km, expires_at)
			SELECT $1, $2, $3, $4
			WHERE NOT EXISTS (SELECT 1 FROM booking_offers WHERE booking_id = $1 AND status = 'open')
			ON CONFLICT (booking_id, cleaner_id) DO NOTHING`,
			o.BookingID, o.CleanerID, o.DistanceKm, o.ExpiresAt)
		created = tag.RowsAffected() == 1
		return err
	})
	return created, err
}

func (s *Store) OfferedCleaners(ctx context.Context, bookingID uuid.UUID) (map[uuid.UUID]bool, error) {
	rows, err := s.pool.Query(ctx, `SELECT cleaner_id FROM booking_offers WHERE booking_id = $1`, bookingID)
	if err != nil {
		return nil, err
	}
	ids, err := pgx.CollectRows(rows, pgx.RowTo[uuid.UUID])
	if err != nil {
		return nil, err
	}
	out := make(map[uuid.UUID]bool, len(ids))
	for _, id := range ids {
		out[id] = true
	}
	return out, nil
}

func (s *Store) AcceptOffer(ctx context.Context, bookingID, cleanerID uuid.UUID, now time.Time) (domain.Booking, []uuid.UUID, error) {
	var b domain.Booking
	var withdrawn []uuid.UUID
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		// No FOR UPDATE here: the winner withdraws the other offers, and a
		// loser holding a lock on its own offer would deadlock with it.
		var status domain.OfferStatus
		var expires time.Time
		err := tx.QueryRow(ctx, `
			SELECT status, expires_at FROM booking_offers
			WHERE booking_id = $1 AND cleaner_id = $2`, bookingID, cleanerID).Scan(&status, &expires)
		if isNoRows(err) {
			return domain.NotFound("Offer")
		}
		if err != nil {
			return err
		}
		if status != domain.OfferOpen || !now.Before(expires) {
			return domain.ErrOfferGone
		}

		// The whole race is settled here. A second cleaner waits for the
		// first one's row lock and then finds status <> 'confirmed'; a cleaner
		// who is busy at that time hits bookings_no_overlap.
		tag, err := tx.Exec(ctx, `
			UPDATE bookings SET cleaner_id = $2, status = 'assigned', updated_at = now()
			WHERE id = $1 AND status = 'confirmed' AND cleaner_id IS NULL`, bookingID, cleanerID)
		if err != nil {
			return mapAssignError(err)
		}
		if tag.RowsAffected() == 0 {
			return domain.ErrOfferGone
		}

		if _, err := tx.Exec(ctx, `
			UPDATE booking_offers SET status = 'accepted' WHERE booking_id = $1 AND cleaner_id = $2`,
			bookingID, cleanerID); err != nil {
			return err
		}
		if withdrawn, err = withdrawOffers(ctx, tx, bookingID); err != nil {
			return err
		}
		if err := addEvent(ctx, tx, bookingID, domain.StatusAssigned, &cleanerID); err != nil {
			return err
		}
		b, err = getBooking(ctx, tx, bookingID)
		return err
	})
	return b, withdrawn, err
}

func (s *Store) CloseOffer(ctx context.Context, bookingID, cleanerID uuid.UUID, status domain.OfferStatus) (bool, error) {
	tag, err := s.pool.Exec(ctx, `
		UPDATE booking_offers SET status = $3
		WHERE booking_id = $1 AND cleaner_id = $2 AND status = 'open'`, bookingID, cleanerID, status)
	return tag.RowsAffected() == 1, err
}

func (s *Store) ExpireOffers(ctx context.Context, now time.Time) ([]domain.OfferRef, error) {
	rows, err := s.pool.Query(ctx, `
		UPDATE booking_offers SET status = 'expired'
		WHERE status = 'open' AND expires_at <= $1
		RETURNING booking_id, cleaner_id`, now)
	if err != nil {
		return nil, err
	}
	return pgx.CollectRows(rows, func(row pgx.CollectableRow) (domain.OfferRef, error) {
		var r domain.OfferRef
		err := row.Scan(&r.BookingID, &r.CleanerID)
		return r, err
	})
}

// dispatchBatch bounds one sweep; the next sweep picks up the rest.
const dispatchBatch = 100

func (s *Store) BookingsAwaitingOffer(ctx context.Context, now time.Time) ([]uuid.UUID, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT b.id FROM bookings b
		WHERE b.status = 'confirmed' AND lower(b.period) > $1
		  AND NOT EXISTS (SELECT 1 FROM booking_offers o WHERE o.booking_id = b.id AND o.status = 'open')
		ORDER BY lower(b.period) LIMIT $2`, now, dispatchBatch)
	if err != nil {
		return nil, err
	}
	return pgx.CollectRows(rows, pgx.RowTo[uuid.UUID])
}

func (s *Store) OpenOffers(ctx context.Context, cleanerID uuid.UUID, now time.Time) ([]domain.Offer, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT booking_id, cleaner_id, status, distance_km, expires_at FROM booking_offers
		WHERE cleaner_id = $1 AND status = 'open' AND expires_at > $2
		ORDER BY expires_at`, cleanerID, now)
	if err != nil {
		return nil, err
	}
	return pgx.CollectRows(rows, func(row pgx.CollectableRow) (domain.Offer, error) {
		var o domain.Offer
		err := row.Scan(&o.BookingID, &o.CleanerID, &o.Status, &o.DistanceKm, &o.ExpiresAt)
		return o, err
	})
}
