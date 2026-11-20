package postgres

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

const cleanerColumns = `c.user_id, c.status, c.bio, c.rating_sum, c.rating_count, c.is_online, c.last_lat, c.last_lng, c.last_seen_at`

func scanCleaner(row pgx.Row, extra ...any) (domain.Cleaner, error) {
	var c domain.Cleaner
	var sum int
	dest := append([]any{&c.UserID, &c.Status, &c.Bio, &sum, &c.RatingCount, &c.IsOnline, &c.LastLat, &c.LastLng, &c.LastSeenAt}, extra...)
	err := row.Scan(dest...)
	if isNoRows(err) {
		return c, domain.NotFound("Cleaner")
	}
	c.Rating = domain.AverageRating(sum, c.RatingCount)
	return c, err
}

func (s *Store) GetCleaner(ctx context.Context, id uuid.UUID) (domain.Cleaner, error) {
	return scanCleaner(s.pool.QueryRow(ctx, `SELECT `+cleanerColumns+` FROM cleaners c WHERE c.user_id = $1`, id))
}

func (s *Store) ListApprovedCleaners(ctx context.Context, onlineOnly bool) ([]domain.Cleaner, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT `+cleanerColumns+` FROM cleaners c
		WHERE c.status = 'approved' AND (c.is_online OR NOT $1)`, onlineOnly)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []domain.Cleaner
	for rows.Next() {
		c, err := scanCleaner(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, c)
	}
	return out, rows.Err()
}

const availabilityColumns = `weekday, (extract(epoch FROM start_time) / 60)::int, (extract(epoch FROM end_time) / 60)::int`

func (s *Store) AvailabilityFor(ctx context.Context, cleanerIDs []uuid.UUID, weekday int) (map[uuid.UUID]domain.Availability, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT cleaner_id, `+availabilityColumns+` FROM cleaner_availability
		WHERE cleaner_id = ANY($1::uuid[]) AND weekday = $2`, uuidStrings(cleanerIDs), weekday)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make(map[uuid.UUID]domain.Availability)
	for rows.Next() {
		var id uuid.UUID
		var a domain.Availability
		if err := rows.Scan(&id, &a.Weekday, &a.StartTime, &a.EndTime); err != nil {
			return nil, err
		}
		out[id] = a
	}
	return out, rows.Err()
}

func (s *Store) BusyPeriods(ctx context.Context, cleanerIDs []uuid.UUID, from, to time.Time) (map[uuid.UUID][]domain.Period, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT cleaner_id, lower(period), upper(period) FROM bookings
		WHERE cleaner_id = ANY($1::uuid[]) AND status <> 'cancelled'
		  AND period && tstzrange($2, $3, '[)')`, uuidStrings(cleanerIDs), from, to)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make(map[uuid.UUID][]domain.Period)
	for rows.Next() {
		var id uuid.UUID
		var p domain.Period
		if err := rows.Scan(&id, &p.Start, &p.End); err != nil {
			return nil, err
		}
		out[id] = append(out[id], p)
	}
	return out, rows.Err()
}

func (s *Store) SetCleanerOnline(ctx context.Context, id uuid.UUID, online bool, lat, lng *float64) error {
	tag, err := s.pool.Exec(ctx, `
		UPDATE cleaners SET is_online = $2,
			last_lat = coalesce($3, last_lat), last_lng = coalesce($4, last_lng), last_seen_at = now()
		WHERE user_id = $1`, id, online, lat, lng)
	if err == nil && tag.RowsAffected() == 0 {
		return domain.NotFound("Cleaner")
	}
	return err
}

func (s *Store) GetAvailability(ctx context.Context, id uuid.UUID) ([]domain.Availability, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT `+availabilityColumns+` FROM cleaner_availability
		WHERE cleaner_id = $1 ORDER BY weekday`, id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []domain.Availability{}
	for rows.Next() {
		var a domain.Availability
		if err := rows.Scan(&a.Weekday, &a.StartTime, &a.EndTime); err != nil {
			return nil, err
		}
		out = append(out, a)
	}
	return out, rows.Err()
}

func (s *Store) ReplaceAvailability(ctx context.Context, id uuid.UUID, list []domain.Availability) error {
	return s.inTx(ctx, func(tx pgx.Tx) error {
		if _, err := tx.Exec(ctx, `DELETE FROM cleaner_availability WHERE cleaner_id = $1`, id); err != nil {
			return err
		}
		for _, a := range list {
			_, err := tx.Exec(ctx, `
				INSERT INTO cleaner_availability (cleaner_id, weekday, start_time, end_time)
				VALUES ($1, $2, $3::time, $4::time)`, id, a.Weekday, a.StartTime.String(), a.EndTime.String())
			if err != nil {
				return err
			}
		}
		return nil
	})
}

func (s *Store) CompletedJobs(ctx context.Context, cleanerID uuid.UUID, from, to time.Time) ([]service.EarningJob, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT b.id, b.code, s.title, lower(b.period),
			(extract(epoch FROM upper(b.period) - lower(b.period)) / 60)::int,
			b.cleaner_payout, coalesce(r.tip, 0)
		FROM bookings b
		JOIN services s ON s.id = b.service_id
		LEFT JOIN reviews r ON r.booking_id = b.id
		WHERE b.cleaner_id = $1 AND b.status = 'completed'
		  AND lower(b.period) >= $2 AND lower(b.period) < $3
		ORDER BY lower(b.period) DESC`, cleanerID, from, to)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []service.EarningJob{}
	for rows.Next() {
		var j service.EarningJob
		if err := rows.Scan(&j.BookingID, &j.Code, &j.ServiceTitle, &j.Start, &j.Minutes, &j.Amount, &j.Tip); err != nil {
			return nil, err
		}
		out = append(out, j)
	}
	return out, rows.Err()
}

func (s *Store) ListCleanerProfiles(ctx context.Context, status *domain.CleanerStatus) ([]domain.CleanerProfile, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT `+cleanerColumns+`, u.id, u.phone, u.full_name, u.email, u.role, u.avatar_url, u.created_at
		FROM cleaners c JOIN users u ON u.id = c.user_id
		WHERE $1::cleaner_status IS NULL OR c.status = $1
		ORDER BY u.created_at DESC`, status)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []domain.CleanerProfile{}
	for rows.Next() {
		var p domain.CleanerProfile
		u := &p.User
		c, err := scanCleaner(rows, &u.ID, &u.Phone, &u.FullName, &u.Email, &u.Role, &u.AvatarURL, &u.CreatedAt)
		if err != nil {
			return nil, err
		}
		p.Cleaner = c
		out = append(out, p)
	}
	return out, rows.Err()
}

func (s *Store) SetCleanerStatus(ctx context.Context, id uuid.UUID, status domain.CleanerStatus) error {
	// A suspended cleaner goes offline so the dispatcher stops picking them.
	tag, err := s.pool.Exec(ctx, `
		UPDATE cleaners SET status = $2, is_online = is_online AND $2 = 'approved'
		WHERE user_id = $1`, id, status)
	if err == nil && tag.RowsAffected() == 0 {
		return domain.NotFound("Cleaner")
	}
	return err
}
