package postgres

import (
	"context"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

const serviceColumns = `id, slug, title, base_price, per_bedroom, per_bathroom, base_minutes, minutes_per_room, is_active, sort_order`

func scanService(row pgx.Row) (domain.Service, error) {
	var s domain.Service
	err := row.Scan(&s.ID, &s.Slug, &s.Title, &s.BasePrice, &s.PerBedroom, &s.PerBathroom,
		&s.BaseMinutes, &s.MinutesPerRoom, &s.IsActive, &s.SortOrder)
	if isNoRows(err) {
		return s, domain.NotFound("Service")
	}
	return s, err
}

func (s *Store) ListServices(ctx context.Context, activeOnly bool) ([]domain.Service, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT `+serviceColumns+` FROM services
		WHERE is_active OR NOT $1 ORDER BY sort_order, title`, activeOnly)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []domain.Service{}
	for rows.Next() {
		svc, err := scanService(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, svc)
	}
	return out, rows.Err()
}

func (s *Store) GetService(ctx context.Context, id uuid.UUID) (domain.Service, error) {
	return scanService(s.pool.QueryRow(ctx, `SELECT `+serviceColumns+` FROM services WHERE id = $1`, id))
}

func (s *Store) UpdateService(ctx context.Context, svc domain.Service) (domain.Service, error) {
	return scanService(s.pool.QueryRow(ctx, `
		UPDATE services SET title = $2, base_price = $3, per_bedroom = $4, per_bathroom = $5,
			base_minutes = $6, minutes_per_room = $7, is_active = $8
		WHERE id = $1 RETURNING `+serviceColumns,
		svc.ID, svc.Title, svc.BasePrice, svc.PerBedroom, svc.PerBathroom,
		svc.BaseMinutes, svc.MinutesPerRoom, svc.IsActive))
}

func (s *Store) ListExtras(ctx context.Context) ([]domain.Extra, error) {
	return s.queryExtras(ctx, `SELECT id, slug, title, price, minutes FROM service_extras ORDER BY title`)
}

func (s *Store) GetExtras(ctx context.Context, ids []uuid.UUID) ([]domain.Extra, error) {
	if len(ids) == 0 {
		return nil, nil
	}
	extras, err := s.queryExtras(ctx, `
		SELECT id, slug, title, price, minutes FROM service_extras
		WHERE id = ANY($1::uuid[]) ORDER BY title`, uuidStrings(ids))
	if err != nil {
		return nil, err
	}
	if len(extras) != len(ids) {
		return nil, domain.Invalid("extra_ids", "unknown extra")
	}
	return extras, nil
}

func (s *Store) queryExtras(ctx context.Context, sql string, args ...any) ([]domain.Extra, error) {
	rows, err := s.pool.Query(ctx, sql, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []domain.Extra{}
	for rows.Next() {
		var e domain.Extra
		if err := rows.Scan(&e.ID, &e.Slug, &e.Title, &e.Price, &e.Minutes); err != nil {
			return nil, err
		}
		out = append(out, e)
	}
	return out, rows.Err()
}
