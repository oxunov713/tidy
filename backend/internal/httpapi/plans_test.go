package httpapi_test

import (
	"net/http"
	"testing"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

type planSummary struct {
	ID           uuid.UUID `json:"id"`
	Frequency    string    `json:"frequency"`
	NextRunOn    string    `json:"next_run_on"`
	ServiceTitle string    `json:"service_title"`
	StartTime    string    `json:"start_time"`
	AddressID    uuid.UUID `json:"address_id"`
}

func (e *testEnv) runPlans() int {
	e.t.Helper()
	n, err := e.bookings.RunPlans(e.t.Context())
	if err != nil {
		e.t.Fatal(err)
	}
	return n
}

func (e *testEnv) plans(c client) []planSummary {
	e.t.Helper()
	var list []planSummary
	e.expect(e.do("GET", "/plans", c.AccessToken, nil), http.StatusOK).decode(e.t, &list)
	return list
}

func (e *testEnv) clientBookings(clientID uuid.UUID) int {
	e.t.Helper()
	var n int
	if err := e.store.Pool().QueryRow(e.t.Context(), `SELECT count(*) FROM bookings WHERE client_id = $1`, clientID).Scan(&n); err != nil {
		e.t.Fatal(err)
	}
	return n
}

func TestCancelSeriesEndsPlan(t *testing.T) {
	e := newEnv(t)
	e.cleaner("+447700901001", 51.5200, -0.1550, true)
	c := e.client("+447700901101")
	b := e.bookEvery(c, tomorrowAt(10), domain.FrequencyWeekly)

	var res struct {
		Booking   domain.Booking `json:"booking"`
		Refunded  bool           `json:"refunded"`
		PlanEnded bool           `json:"plan_ended"`
	}
	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/cancel", c.AccessToken, map[string]string{"scope": "series"}), http.StatusOK).decode(t, &res)
	if res.Booking.Status != domain.StatusCancelled || !res.PlanEnded {
		t.Fatalf("cancel = %+v, want cancelled with the plan ended", res)
	}
	if plans := e.plans(c); len(plans) != 0 {
		t.Errorf("plans after cancelling the series = %+v, want none", plans)
	}

	// A day later the next visit would be inside the scheduler's week.
	e.travelTo(time.Now().Add(24 * time.Hour))
	if n := e.runPlans(); n != 0 {
		t.Errorf("scheduler created %d bookings for an ended plan", n)
	}
	if n := e.clientBookings(c.User.ID); n != 1 {
		t.Errorf("client has %d bookings, want only the cancelled one", n)
	}
}

func TestCancelVisitKeepsPlan(t *testing.T) {
	e := newEnv(t)
	e.cleaner("+447700901002", 51.5200, -0.1550, true)
	c := e.client("+447700901102")
	b := e.bookEvery(c, tomorrowAt(10), domain.FrequencyWeekly)

	// No body at all is a single visit.
	var res struct {
		PlanEnded bool `json:"plan_ended"`
	}
	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/cancel", c.AccessToken, nil), http.StatusOK).decode(t, &res)
	if res.PlanEnded {
		t.Error("cancelling one visit ended the plan")
	}
	e.travelTo(time.Now().Add(24 * time.Hour))
	if n := e.runPlans(); n != 1 {
		t.Errorf("scheduler created %d bookings, want the next visit", n)
	}

	r := e.do("POST", "/bookings/"+b.ID.String()+"/cancel", c.AccessToken, map[string]string{"scope": "forever"})
	if r.status != http.StatusBadRequest {
		t.Errorf("unknown scope: got %d %s, want 400", r.status, r.body)
	}
}

func TestDeletePlan(t *testing.T) {
	e := newEnv(t)
	cl := e.cleaner("+447700901003", 51.5200, -0.1550, true)
	c := e.client("+447700901103")
	first := e.bookEvery(c, tomorrowAt(10), domain.FrequencyWeekly)
	e.expect(e.do("POST", "/cleaner/offers/"+first.ID.String()+"/accept", cl.AccessToken, nil), http.StatusOK)

	e.travelTo(time.Now().Add(24 * time.Hour))
	if n := e.runPlans(); n != 1 {
		t.Fatalf("scheduler created %d bookings, want 1", n)
	}
	plans := e.plans(c)
	wantNext := tomorrowAt(10).AddDate(0, 0, 14).Format(time.DateOnly)
	if len(plans) != 1 || plans[0].NextRunOn != wantNext || plans[0].StartTime != "10:00" ||
		plans[0].ServiceTitle != "Standard clean" || plans[0].Frequency != "weekly" || plans[0].AddressID != c.AddressID {
		t.Fatalf("plans = %+v, want one weekly plan next on %s at 10:00", plans, wantNext)
	}
	var second uuid.UUID
	err := e.store.Pool().QueryRow(t.Context(),
		`SELECT id FROM bookings WHERE client_id = $1 AND id <> $2`, c.User.ID, first.ID).Scan(&second)
	if err != nil {
		t.Fatal(err)
	}

	other := e.client("+447700901104")
	e.expect(e.do("DELETE", "/plans/"+plans[0].ID.String(), other.AccessToken, nil), http.StatusForbidden)
	e.expect(e.do("DELETE", "/plans/"+uuid.NewString(), c.AccessToken, nil), http.StatusNotFound)
	e.expect(e.do("DELETE", "/plans/"+plans[0].ID.String(), c.AccessToken, nil), http.StatusNoContent)

	if status, _ := e.bookingStatus(second); status != domain.StatusCancelled {
		t.Errorf("future visit without a cleaner is %s, want cancelled", status)
	}
	if status, _ := e.bookingStatus(first.ID); status != domain.StatusAssigned {
		t.Errorf("visit with a cleaner is %s, want it kept", status)
	}
	if got := e.plans(c); len(got) != 0 {
		t.Errorf("plans after delete = %+v", got)
	}
	e.travelTo(time.Now().Add(9 * 24 * time.Hour))
	if n := e.runPlans(); n != 0 {
		t.Errorf("scheduler created %d bookings after the plan was deleted", n)
	}
	// Deleting twice is fine.
	e.expect(e.do("DELETE", "/plans/"+plans[0].ID.String(), c.AccessToken, nil), http.StatusNoContent)
}

func TestSchedulerSkipsUnusablePlans(t *testing.T) {
	e := newEnv(t)
	e.cleaner("+447700901005", 51.5200, -0.1550, true)
	admin := e.admin("+447700901006")

	gone := e.client("+447700901105")
	e.bookEvery(gone, tomorrowAt(10), domain.FrequencyWeekly)
	e.expect(e.do("DELETE", "/me/addresses/"+gone.AddressID.String(), gone.AccessToken, nil), http.StatusNoContent)

	paused := e.client("+447700901106")
	e.bookEvery(paused, tomorrowAt(14), domain.FrequencyFortnightly)
	e.expect(e.do("PUT", "/admin/services/"+e.serviceID("standard").String(), admin.AccessToken, map[string]any{
		"title": "Standard clean", "base_price": 4500, "per_bedroom": 1500, "per_bathroom": 1000,
		"base_minutes": 120, "minutes_per_room": 30, "is_active": false,
	}), http.StatusOK)

	e.travelTo(time.Now().Add(8 * 24 * time.Hour))
	if n := e.runPlans(); n != 0 {
		t.Fatalf("scheduler created %d bookings from unusable plans", n)
	}
	if got := e.plans(gone); len(got) != 0 {
		t.Errorf("plan with a deleted address is still active: %+v", got)
	}
	// A switched off service only skips the visit; the plan stays.
	if got := e.plans(paused); len(got) != 1 {
		t.Errorf("plan of a paused service = %+v, want it kept", got)
	}
}
