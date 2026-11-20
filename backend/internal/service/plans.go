package service

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// PlanSummary is an active recurring plan as the client app lists it.
type PlanSummary struct {
	ID           uuid.UUID        `json:"id"`
	Frequency    domain.Frequency `json:"frequency"`
	NextRunOn    string           `json:"next_run_on"`
	ServiceTitle string           `json:"service_title"`
	StartTime    domain.TimeOfDay `json:"start_time"`
	AddressID    uuid.UUID        `json:"address_id"`
}

// CancelledBooking is a booking that was just cancelled, with the cleaners
// whose open offers for it were withdrawn.
type CancelledBooking struct {
	Booking   domain.Booking
	Withdrawn []uuid.UUID
}

type EndedPlan struct {
	// Ended is false when the plan had already ended.
	Ended     bool
	Cancelled []CancelledBooking
}

func (s *Bookings) Plans(ctx context.Context, p Principal) ([]PlanSummary, error) {
	return s.store.ListPlans(ctx, p.UserID)
}

// EndPlan stops a recurring series. Future visits without a cleaner are
// cancelled and refunded; the next visit is never created.
func (s *Bookings) EndPlan(ctx context.Context, p Principal, id uuid.UUID) error {
	plan, err := s.store.GetPlan(ctx, id)
	if err != nil {
		return err
	}
	if plan.ClientID != p.UserID {
		return domain.Forbidden("This isn't your plan.")
	}
	_, err = s.endPlan(ctx, id, &p.UserID)
	return err
}

func (s *Bookings) endPlan(ctx context.Context, id uuid.UUID, actor *uuid.UUID) (bool, error) {
	ended, err := s.store.EndPlan(ctx, id, s.clock.now(), actor)
	if err != nil {
		return false, err
	}
	for _, c := range ended.Cancelled {
		s.afterCancel(ctx, c, true)
	}
	return ended.Ended, nil
}

// RunPlans creates the bookings of recurring plans that are due within the
// next week. Returns how many bookings were created.
func (s *Bookings) RunPlans(ctx context.Context) (int, error) {
	now := s.clock.now()
	plans, err := s.store.DuePlans(ctx, dateOf(now.In(s.loc()).Add(planLookahead)))
	if err != nil {
		return 0, err
	}
	created := 0
	for _, plan := range plans {
		if err := ctx.Err(); err != nil {
			return created, err
		}
		ok, err := s.runPlan(ctx, plan, now)
		if err != nil {
			s.log.Error("run booking plan", "plan_id", plan.ID, "err", err)
			continue
		}
		if ok {
			created++
		}
	}
	return created, nil
}

func (s *Bookings) runPlan(ctx context.Context, plan domain.Plan, now time.Time) (bool, error) {
	usable, err := s.planUsable(ctx, plan)
	if err != nil || !usable {
		return false, err
	}
	t := plan.Template
	next := plan.NextRunOn.AddDate(0, 0, plan.Frequency.IntervalDays())
	start := t.StartTime.On(plan.NextRunOn, s.loc()).UTC()
	if start.Before(now.Add(minLeadTime)) {
		// Missed while the service was down; skip rather than book at short notice.
		return false, s.store.AdvancePlan(ctx, plan.ID, next)
	}
	q, extras, err := s.quote(ctx, QuoteRequest{
		ServiceID: t.ServiceID, Bedrooms: t.Bedrooms, Bathrooms: t.Bathrooms,
		ExtraIDs: t.ExtraIDs, Frequency: plan.Frequency,
	})
	if errors.Is(err, domain.ErrInvalidRequest) {
		// The service was switched off or an extra was removed. Skip this
		// visit; the plan picks up again once the catalogue allows it.
		s.log.Warn("skip plan visit the catalogue no longer allows", "plan_id", plan.ID, "err", err)
		return false, s.store.AdvancePlan(ctx, plan.ID, next)
	}
	if err != nil {
		return false, err
	}
	b, err := s.store.CreateBooking(ctx, domain.NewBooking{
		ClientID:           plan.ClientID,
		ServiceID:          t.ServiceID,
		AddressID:          t.AddressID,
		RequestedCleanerID: t.CleanerID,
		Bedrooms:           t.Bedrooms,
		Bathrooms:          t.Bathrooms,
		Frequency:          plan.Frequency,
		Start:              start,
		End:                start.Add(time.Duration(q.Minutes) * time.Minute),
		Quote:              q,
		Extras:             extras,
		FromPlan:           &domain.PlanRun{PlanID: plan.ID, NextRunOn: next},
	})
	if errors.Is(err, domain.ErrPlanEnded) {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	if _, err := s.payments.Start(ctx, b); err != nil {
		return false, err
	}
	s.push.Notify(plan.ClientID, domain.Notification{
		Title: "Next clean booked",
		Body:  b.ServiceTitle + " on " + b.Start.In(s.loc()).Format("Mon 2 Jan 15:04"),
		Data:  map[string]string{"type": "booking.status", "booking_id": b.ID.String()},
	})
	return true, nil
}

// planUsable ends a plan whose client or address is gone: no later visit
// could be booked either.
func (s *Bookings) planUsable(ctx context.Context, plan domain.Plan) (bool, error) {
	reason := ""
	client, err := s.store.GetUser(ctx, plan.ClientID)
	switch {
	case errors.Is(err, domain.ErrNotFound):
		reason = "client not found"
	case err != nil:
		return false, err
	case client.Role != domain.RoleClient:
		reason = "account is no longer a client"
	}
	if reason == "" {
		addr, err := s.store.GetAddress(ctx, plan.Template.AddressID)
		switch {
		case errors.Is(err, domain.ErrNotFound):
			reason = "address not found"
		case err != nil:
			return false, err
		case addr.Deleted || addr.UserID != plan.ClientID:
			reason = "address was deleted"
		}
	}
	if reason == "" {
		return true, nil
	}
	s.log.Info("ending plan that can't be booked any more", "plan_id", plan.ID, "reason", reason)
	if _, err := s.endPlan(ctx, plan.ID, nil); err != nil {
		return false, err
	}
	s.push.Notify(plan.ClientID, domain.Notification{
		Title: "Regular clean stopped",
		Body:  "We stopped your regular clean: it can't be booked any more.",
		Data:  map[string]string{"type": "plan.ended", "plan_id": plan.ID.String()},
	})
	return false, nil
}
