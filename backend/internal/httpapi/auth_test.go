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
