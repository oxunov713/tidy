package httpapi_test

import (
	"context"
	"net/http"
	"testing"

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
