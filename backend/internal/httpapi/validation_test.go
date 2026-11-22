package httpapi_test

import (
	"net/http"
	"strings"
	"testing"
)

func TestOversizedBodyIs413(t *testing.T) {
	e := newEnv(t)
	c := e.client("+447700902301")
	r := e.do("POST", "/me/addresses", c.AccessToken, map[string]any{
		"line1": "1 High Street", "city": "London", "postcode": "N1 1AA", "lat": 51.5, "lng": -0.1,
		"access_notes": strings.Repeat("x", 70<<10),
	})
	if r.status != http.StatusRequestEntityTooLarge || r.errorCode(t) != "payload_too_large" {
		t.Errorf("70 KB body: got %d %s, want 413 payload_too_large", r.status, r.body)
	}
	r = e.doWithHeaders("POST", "/webhooks/stripe", "", map[string]string{"pad": strings.Repeat("x", 70<<10)},
		map[string]string{"Stripe-Signature": "valid"})
	if r.status != http.StatusRequestEntityTooLarge {
		t.Errorf("70 KB webhook: got %d, want 413", r.status)
	}
}

func TestServiceUpdateValidation(t *testing.T) {
	e := newEnv(t)
	admin := e.admin("+447700902302")
	path := "/admin/services/" + e.serviceID("standard").String()
	valid := func() map[string]any {
		return map[string]any{
			"title": "Standard clean", "base_price": 4500, "per_bedroom": 1500, "per_bathroom": 1000,
			"base_minutes": 120, "minutes_per_room": 30, "is_active": true,
		}
	}
	tests := []struct {
		name  string
		field string
		value any // nil removes the field
	}{
		{"missing per_bedroom", "per_bedroom", nil},
		{"missing title", "title", nil},
		{"price that overflows the database", "base_price", 3_000_000_000},
		{"price over the limit", "per_bathroom", 1_000_001},
		{"zero price", "per_bedroom", 0},
		{"more than a day", "base_minutes", 1441},
		{"title too long", "title", strings.Repeat("a", 81)},
		{"number too big for an int", "base_price", 1e20},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			body := valid()
			if tt.value == nil {
				delete(body, tt.field)
			} else {
				body[tt.field] = tt.value
			}
			r := e.do("PUT", path, admin.AccessToken, body)
			if r.status != http.StatusBadRequest || r.errorCode(t) != "invalid_request" {
				t.Errorf("got %d %s, want 400 invalid_request", r.status, r.body)
			}
		})
	}
	e.expect(e.do("PUT", path, admin.AccessToken, valid()), http.StatusOK)
}

func TestStringLimits(t *testing.T) {
	e := newEnv(t)
	c := e.client("+447700902303")
	address := func(field string, n int) map[string]any {
		a := map[string]any{"line1": "1 High Street", "city": "London", "postcode": "N1 1AA", "lat": 51.5, "lng": -0.1}
		a[field] = strings.Repeat("a", n)
		return a
	}
	for field, limit := range map[string]int{"line1": 200, "line2": 200, "city": 80, "postcode": 12, "access_notes": 500} {
		e.expect(e.do("POST", "/me/addresses", c.AccessToken, address(field, limit+1)), http.StatusBadRequest)
		e.expect(e.do("POST", "/me/addresses", c.AccessToken, address(field, limit)), http.StatusCreated)
	}
	e.expect(e.do("PATCH", "/me", c.AccessToken, map[string]string{"full_name": strings.Repeat("é", 81)}), http.StatusBadRequest)
	// Limits count characters, not bytes.
	e.expect(e.do("PATCH", "/me", c.AccessToken, map[string]string{"full_name": strings.Repeat("é", 80)}), http.StatusOK)
	e.expect(e.do("POST", "/quotes", "", map[string]any{
		"service_id": e.serviceID("standard"), "bedrooms": 1e20, "bathrooms": 1,
	}), http.StatusBadRequest)
}
