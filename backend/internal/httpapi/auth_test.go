package httpapi_test

import (
	"net/http"
	"testing"
	"time"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

func (e *testEnv) refresh(token string, status int) session {
	e.t.Helper()
	var s session
	r := e.expect(e.do("POST", "/auth/refresh", "", map[string]string{"refresh_token": token}), status)
	if status == http.StatusOK {
		r.decode(e.t, &s)
	}
	return s
}

func TestRefreshRetryWithinGraceGetsSamePair(t *testing.T) {
	e := newEnv(t)
	s := e.login("+447700901801", domain.RoleClient)

	first := e.refresh(s.RefreshToken, http.StatusOK)
	e.travelTo(time.Now().Add(5 * time.Second))
	again := e.refresh(s.RefreshToken, http.StatusOK)
	if again.AccessToken != first.AccessToken || again.RefreshToken != first.RefreshToken {
		t.Fatalf("retry within the grace window got a different pair:\n first %+v\n again %+v", first, again)
	}
	// Nobody was signed out.
	e.expect(e.do("GET", "/me", again.AccessToken, nil), http.StatusOK)
	e.refresh(first.RefreshToken, http.StatusOK)
}

func TestRefreshReuseAfterGraceRevokesEverything(t *testing.T) {
	e := newEnv(t)
	s := e.login("+447700901802", domain.RoleClient)

	first := e.refresh(s.RefreshToken, http.StatusOK)
	e.travelTo(time.Now().Add(11 * time.Second))
	e.refresh(s.RefreshToken, http.StatusUnauthorized)
	e.refresh(first.RefreshToken, http.StatusUnauthorized)
}

func TestRefreshAfterLogoutIsNotGraced(t *testing.T) {
	e := newEnv(t)
	s := e.login("+447700901803", domain.RoleClient)

	first := e.refresh(s.RefreshToken, http.StatusOK)
	e.expect(e.do("POST", "/auth/logout", "", map[string]string{"refresh_token": first.RefreshToken}), http.StatusNoContent)
	e.refresh(s.RefreshToken, http.StatusUnauthorized)
}

func TestRefreshHasItsOwnRateLimit(t *testing.T) {
	e := newEnv(t)
	// More than the 30 sign-in requests a minute, fewer than the 60 refreshes.
	for i := 0; i < 40; i++ {
		e.refresh("not-a-token", http.StatusUnauthorized)
	}
	e.login("+447700901804", domain.RoleClient)

	var last response
	for i := 0; i < 30; i++ {
		last = e.do("POST", "/auth/refresh", "", map[string]string{"refresh_token": "not-a-token"})
	}
	if last.status != http.StatusTooManyRequests {
		t.Errorf("refresh 71: got %d, want 429", last.status)
	}
}

func TestRefreshTokenExpiresOnTheServiceClock(t *testing.T) {
	e := newEnv(t)
	s := e.login("+447700901805", domain.RoleClient)
	// The test refresh tokens live an hour.
	e.travelTo(time.Now().Add(61 * time.Minute))
	e.refresh(s.RefreshToken, http.StatusUnauthorized)
}

func (e *testEnv) verify(phone string, role domain.Role) response {
	e.t.Helper()
	e.expect(e.do("POST", "/auth/otp", "", map[string]string{"phone": phone}), http.StatusNoContent)
	return e.do("POST", "/auth/verify", "", map[string]string{"phone": phone, "code": e.codes.last(phone), "role": string(role)})
}

func wantForbidden(t *testing.T, r response, message string) {
	t.Helper()
	var body struct {
		Error struct{ Code, Message string } `json:"error"`
	}
	r.decode(t, &body)
	if r.status != http.StatusForbidden || body.Error.Code != "forbidden" || (message != "" && body.Error.Message != message) {
		t.Errorf("got %d %s, want 403 forbidden %q", r.status, r.body, message)
	}
}

func TestAdminVerifyNeverCreatesAnAccount(t *testing.T) {
	e := newEnv(t)
	const phone = "+447700902601"
	wantForbidden(t, e.verify(phone, domain.RoleAdmin), "")
	var n int
	if err := e.store.Pool().QueryRow(t.Context(), `SELECT count(*) FROM users WHERE phone = $1`, phone).Scan(&n); err != nil {
		t.Fatal(err)
	}
	if n != 0 {
		t.Errorf("admin sign-in with an unknown number created %d users", n)
	}

	// A client asking for admin is refused too.
	e.login(phone, domain.RoleClient)
	wantForbidden(t, e.verify(phone, domain.RoleAdmin), "This number is registered as a client.")

	admin := e.admin("+447700902602")
	r := e.expect(e.verify("+447700902602", domain.RoleAdmin), http.StatusOK)
	var s session
	r.decode(t, &s)
	if s.User.ID != admin.User.ID || s.User.Role != domain.RoleAdmin {
		t.Errorf("admin sign-in = %+v", s.User)
	}
}

func TestVerifyRefusesAnotherRole(t *testing.T) {
	e := newEnv(t)
	e.login("+447700902603", domain.RoleCleaner)
	wantForbidden(t, e.verify("+447700902603", domain.RoleClient), "This number is registered as a cleaner.")

	e.login("+447700902604", domain.RoleClient)
	wantForbidden(t, e.verify("+447700902604", domain.RoleCleaner), "This number is registered as a client.")

	e.admin("+447700902605")
	wantForbidden(t, e.verify("+447700902605", domain.RoleClient), "This number is registered as an admin.")

	// New numbers still sign up with the role they ask for, client by default.
	if s := e.login("+447700902606", ""); s.User.Role != domain.RoleClient {
		t.Errorf("new number without a role signed up as %s", s.User.Role)
	}
}

func TestDeleteDevice(t *testing.T) {
	e := newEnv(t)
	a := e.login("+447700902607", domain.RoleClient)
	b := e.login("+447700902608", domain.RoleClient)
	const token = "fcm:APA91b-token_1"
	e.expect(e.do("POST", "/me/devices", a.AccessToken, map[string]string{"token": token, "platform": "android"}), http.StatusNoContent)

	count := func() int {
		var n int
		if err := e.store.Pool().QueryRow(t.Context(), `SELECT count(*) FROM device_tokens WHERE token = $1`, token).Scan(&n); err != nil {
			t.Fatal(err)
		}
		return n
	}
	e.expect(e.do("DELETE", "/me/devices/"+token, b.AccessToken, nil), http.StatusNoContent)
	if count() != 1 {
		t.Fatal("another user removed the device")
	}
	e.expect(e.do("DELETE", "/me/devices/"+token, a.AccessToken, nil), http.StatusNoContent)
	if count() != 0 {
		t.Error("device token still stored after DELETE")
	}
	e.expect(e.do("DELETE", "/me/devices/"+token, a.AccessToken, nil), http.StatusNoContent)
}
