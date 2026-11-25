package postgres

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

const planColumns = `id, client_id, frequency, template, next_run_on, is_active`

func scanPlan(row pgx.Row) (domain.Plan, error) {
	var p domain.Plan
	err := row.Scan(&p.ID, &p.ClientID, &p.Frequency, &p.Template, &p.NextRunOn, &p.IsActive)
	if isNoRows(err) {
		return p, domain.NotFound("Plan")
	}
	return p, err
}

func (s *Store) GetPlan(ctx context.Context, id uuid.UUID) (domain.Plan, error) {
	return scanPlan(s.pool.QueryRow(ctx, `SELECT `+planColumns+` FROM booking_plans WHERE id = $1`, id))
}

func (s *Store) ListPlans(ctx context.Context, clientID uuid.UUID) ([]service.PlanSummary, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT p.id, p.frequency, p.next_run_on, coalesce(sv.title, ''), p.template
		FROM booking_plans p
		LEFT JOIN services sv ON sv.id = (p.template->>'service_id')::uuid
		WHERE p.client_id = $1 AND p.is_active
		ORDER BY p.next_run_on, p.id`, clientID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []service.PlanSummary{}
	for rows.Next() {
		var ps service.PlanSummary
		var next time.Time
		var t domain.PlanTemplate
		if err := rows.Scan(&ps.ID, &ps.Frequency, &next, &ps.ServiceTitle, &t); err != nil {
			return nil, err
		}
		ps.NextRunOn = next.Format(time.DateOnly)
		ps.StartTime, ps.AddressID = t.StartTime, t.AddressID
		out = append(out, ps)
	}
	return out, rows.Err()
}

func (s *Store) DuePlans(ctx context.Context, until time.Time) ([]domain.Plan, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT `+planColumns+` FROM booking_plans
		WHERE is_active AND next_run_on <= $1::date ORDER BY next_run_on`, until.Format(time.DateOnly))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []domain.Plan
	for rows.Next() {
		p, err := scanPlan(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, p)
	}
	return out, rows.Err()
}

func (s *Store) AdvancePlan(ctx context.Context, id uuid.UUID, next time.Time) error {
	_, err := s.pool.Exec(ctx, `UPDATE booking_plans SET next_run_on = $2::date WHERE id = $1 AND is_active`,
		id, next.Format(time.DateOnly))
	return err
}

func (s *Store) EndPlan(ctx context.Context, id uuid.UUID, now time.Time, actor *uuid.UUID) (service.EndedPlan, error) {
	var out service.EndedPlan
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		tag, err := tx.Exec(ctx, `UPDATE booking_plans SET is_active = false, ended_at = $2 WHERE id = $1 AND is_active`, id, now)
		if err != nil {
			return err
		}
		out.Ended = tag.RowsAffected() == 1

		// Visits that already have a cleaner stay: someone has planned their day around them.
		rows, err := tx.Query(ctx, `
			SELECT id, status FROM bookings
			WHERE plan_id = $1 AND status IN ('pending', 'confirmed') AND cleaner_id IS NULL AND lower(period) > $2
			ORDER BY lower(period) FOR UPDATE`, id, now)
		if err != nil {
			return err
		}
		type due struct {
			id     uuid.UUID
			status domain.BookingStatus
		}
		list, err := pgx.CollectRows(rows, func(row pgx.CollectableRow) (due, error) {
			var d due
			err := row.Scan(&d.id, &d.status)
			return d, err
		})
		if err != nil {
			return err
		}
		for _, d := range list {
			if err := setStatus(ctx, tx, d.id, d.status, domain.StatusCancelled, actor); err != nil {
				return err
			}
			withdrawn, err := withdrawOffers(ctx, tx, d.id)
			if err != nil {
				return err
			}
			b, err := getBooking(ctx, tx, d.id)
			if err != nil {
				return err
			}
			out.Cancelled = append(out.Cancelled, service.CancelledBooking{Booking: b, Withdrawn: withdrawn})
		}
		return nil
	})
	return out, err
}
