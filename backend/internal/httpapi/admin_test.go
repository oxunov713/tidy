package httpapi_test

import (
	"context"
	"net/http"
	"testing"
	"time"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

func (e *testEnv) admin(phone string) session {
	e.t.Helper()
	s := e.login(phone, domain.RoleClient)
	if _, err := e.store.Pool().Exec(context.Background(),
		`UPDATE users SET role = 'admin' WHERE id = $1`, s.User.ID); err != nil {
		e.t.Fatal(err)
	}
	// Log in again so the new role ends up in the token.
	return e.login(phone, "")
}

func TestAdminApprovesAndSuspendsCleaner(t *testing.T) {
	e := newEnv(t)
	admin := e.admin("+447700900900")
	c := e.login("+447700900901", domain.RoleCleaner)

	status := func() (string, bool) {
		t.Helper()
		var st string
		var online bool
		err := e.store.Pool().QueryRow(context.Background(),
			`SELECT status, is_online FROM cleaners WHERE user_id = $1`, c.User.ID).Scan(&st, &online)
		if err != nil {
			t.Fatal(err)
		}
		return st, online
	}

	e.expect(e.do("POST", "/admin/cleaners/"+c.User.ID.String()+"/approve", admin.AccessToken, nil), http.StatusNoContent)
	if st, _ := status(); st != "approved" {
		t.Fatalf("status = %s, want approved", st)
	}

	if _, err := e.store.Pool().Exec(context.Background(),
		`UPDATE cleaners SET is_online = true WHERE user_id = $1`, c.User.ID); err != nil {
		t.Fatal(err)
	}
	e.expect(e.do("POST", "/admin/cleaners/"+c.User.ID.String()+"/suspend", admin.AccessToken, nil), http.StatusNoContent)
	if st, online := status(); st != "suspended" || online {
		t.Fatalf("got status=%s online=%v, want suspended and offline", st, online)
	}
}

func TestServiceUpdateNeedsActiveFlag(t *testing.T) {
	e := newEnv(t)
	admin := e.admin("+447700900902")
	id := e.serviceID("standard")

	body := map[string]any{
		"title": "Standard clean", "base_price": 4500, "per_bedroom": 1500, "per_bathroom": 1000,
		"base_minutes": 120, "minutes_per_room": 30,
	}
	r := e.expect(e.do("PUT", "/admin/services/"+id.String(), admin.AccessToken, body), http.StatusBadRequest)
	if code := r.errorCode(t); code != "invalid_request" {
		t.Fatalf("code = %s, want invalid_request", code)
	}

	body["is_active"] = false
	e.expect(e.do("PUT", "/admin/services/"+id.String(), admin.AccessToken, body), http.StatusOK)
}

func TestSuspendReleasesJobs(t *testing.T) {
	e := newEnv(t)
	admin := e.admin("+447700901401")
	suspended := e.cleaner("+447700901402", 51.5200, -0.1550, true)
	other := e.cleaner("+447700901403", 51.5000, -0.1000, true)
	c := e.client("+447700901501")

	assigned := e.book(c, tomorrowAt(10))
	e.expect(e.do("POST", "/cleaner/offers/"+assigned.ID.String()+"/accept", suspended.AccessToken, nil), http.StatusOK)
	offered := e.book(c, tomorrowAt(14))
	if got := e.openOfferFor(offered.ID); got == nil || *got != suspended.ID {
		t.Fatalf("second job offered to %v, want %s", got, suspended.ID)
	}
	cleanerWS := e.ws(suspended.AccessToken)
	cleanerWS.join(assigned.ID)

	e.expect(e.do("POST", "/admin/cleaners/"+suspended.ID.String()+"/suspend", admin.AccessToken, nil), http.StatusNoContent)

	if status, cleanerID := e.bookingStatus(assigned.ID); status != domain.StatusConfirmed || cleanerID != nil {
		t.Errorf("assigned job is %s with %v, want confirmed without a cleaner", status, cleanerID)
	}
	for _, b := range []domain.Booking{assigned, offered} {
		if got := e.openOfferFor(b.ID); got == nil || *got != other.ID {
			t.Errorf("job %s offered to %v after the suspension, want %s", b.Code, got, other.ID)
		}
	}
	wantRevoked(t, cleanerWS.receiveType("unsubscribed"), assigned.ID)

	path := "/bookings/" + assigned.ID.String()
	e.expect(e.do("POST", "/cleaner/jobs/"+assigned.ID.String()+"/status", suspended.AccessToken, map[string]string{"status": "on_the_way"}), http.StatusForbidden)
	e.expect(e.do("POST", path+"/messages", suspended.AccessToken, map[string]string{"body": "hi"}), http.StatusForbidden)
}

func TestUnapprovedCleanerCantActOnJob(t *testing.T) {
	e := newEnv(t)
	cl := e.cleaner("+447700901404", 51.5200, -0.1550, true)
	c := e.client("+447700901502")
	start := tomorrowAt(10)
	b := e.book(c, start)
	e.expect(e.do("POST", "/cleaner/offers/"+b.ID.String()+"/accept", cl.AccessToken, nil), http.StatusOK)

	// Suspended behind the API's back, so the job is still theirs.
	if _, err := e.store.Pool().Exec(t.Context(), `UPDATE cleaners SET status = 'suspended' WHERE user_id = $1`, cl.ID); err != nil {
		t.Fatal(err)
	}
	e.travelTo(start.Add(-time.Hour))
	for _, r := range []response{
		e.do("POST", "/cleaner/jobs/"+b.ID.String()+"/status", cl.AccessToken, map[string]string{"status": "on_the_way"}),
		e.do("POST", "/bookings/"+b.ID.String()+"/messages", cl.AccessToken, map[string]string{"body": "on my way"}),
		e.do("GET", "/bookings/"+b.ID.String()+"/messages", cl.AccessToken, nil),
	} {
		if r.status != http.StatusForbidden || r.errorCode(t) != "forbidden" {
			t.Errorf("got %d %s, want 403 forbidden", r.status, r.body)
		}
	}

	ws := e.ws(cl.AccessToken)
	ws.send(map[string]any{"type": "location", "booking_id": b.ID, "lat": 51.52, "lng": -0.15})
	if got := ws.receive(); got["type"] != "error" || got["code"] != "forbidden" {
		t.Errorf("location from a suspended cleaner: got %v, want forbidden", got)
	}
	ws.send(map[string]any{"type": "subscribe", "room": "booking:" + b.ID.String()})
	if got := ws.receive(); got["type"] != "error" || got["code"] != "forbidden" {
		t.Errorf("suspended cleaner joining the room: got %v, want forbidden", got)
	}
}
