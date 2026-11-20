package httpapi_test

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"os"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/httpapi"
	"github.com/oxunov713/tidy/backend/internal/payment"
	"github.com/oxunov713/tidy/backend/internal/push"
	"github.com/oxunov713/tidy/backend/internal/realtime"
	"github.com/oxunov713/tidy/backend/internal/service"
	"github.com/oxunov713/tidy/backend/internal/store/postgres"
)

// These tests run the real HTTP API against a real Postgres. They are
// skipped unless TEST_DATABASE_URL points at a database they may wipe.

var london = mustLoadLocation("Europe/London")

func mustLoadLocation(name string) *time.Location {
	loc, err := time.LoadLocation(name)
	if err != nil {
		panic(err)
	}
	return loc
}

func TestMain(m *testing.M) {
	if url := os.Getenv("TEST_DATABASE_URL"); url != "" {
		if err := postgres.Migrate(url); err != nil {
			fmt.Fprintln(os.Stderr, "migrate test database:", err)
			os.Exit(1)
		}
	}
	os.Exit(m.Run())
}

// codeBook catches login codes instead of sending SMS.
type codeBook struct {
	mu    sync.Mutex
	codes map[string]string
}

func (c *codeBook) SendCode(_ context.Context, phone, code string) error {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.codes[phone] = code
	return nil
}

func (c *codeBook) last(phone string) string {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.codes[phone]
}

// recordingProvider is the mock provider that remembers what it was asked to do.
type recordingProvider struct {
	payment.Mock
	mu       sync.Mutex
	captured []string
	refunded []string
}

func (p *recordingProvider) Capture(_ context.Context, ref string) error {
	p.mu.Lock()
	defer p.mu.Unlock()
	p.captured = append(p.captured, ref)
	return nil
}

func (p *recordingProvider) Refund(_ context.Context, ref string) error {
	p.mu.Lock()
	defer p.mu.Unlock()
	p.refunded = append(p.refunded, ref)
	return nil
}

type testEnv struct {
	t        *testing.T
	url      string
	store    *postgres.Store
	codes    *codeBook
	payments *recordingProvider
	dispatch *service.Dispatcher

	mu     sync.Mutex
	offset time.Duration
}

func (e *testEnv) now() time.Time {
	e.mu.Lock()
	defer e.mu.Unlock()
	return time.Now().Add(e.offset)
}

// travelTo moves the service clock so that it reads t.
func (e *testEnv) travelTo(t time.Time) {
	e.mu.Lock()
	defer e.mu.Unlock()
	e.offset = time.Until(t)
}

func newEnv(t *testing.T) *testEnv {
	t.Helper()
	url := os.Getenv("TEST_DATABASE_URL")
	if url == "" {
		t.Skip("TEST_DATABASE_URL is not set")
	}
	ctx := context.Background()
	store, err := postgres.Open(ctx, url)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(store.Close)
	// Everything but the catalogue, which comes from the seed migration.
	_, err = store.Pool().Exec(ctx, `TRUNCATE users, otp_codes, otp_requests, processed_webhooks CASCADE`)
	if err != nil {
		t.Fatal(err)
	}

	log := slog.New(slog.NewTextHandler(io.Discard, nil))
	e := &testEnv{t: t, store: store, codes: &codeBook{codes: map[string]string{}}, payments: &recordingProvider{}}
	clock := service.Clock(e.now)

	auth := service.NewAuth(store, e.codes, service.AuthConfig{
		// Long enough to survive the clock jumps some tests make.
		Secret: []byte("test-secret-test-secret-test-secret"), AccessTTL: 72 * time.Hour, RefreshTTL: time.Hour,
	}, clock)
	hub := realtime.NewHub(auth.ParseAccessToken, realtime.Options{}, log)
	pusher := service.NewPusher(store, push.Log{Log: log}, log)
	e.dispatch = service.NewDispatcher(store, store, hub, pusher, london, 15, clock, log)
	payments := service.NewPayments(store, e.payments, e.dispatch, hub, clock, log)
	bookings := service.NewBookings(store, store, payments, hub, pusher, london, 15, clock, log)

	api := httpapi.New(httpapi.Deps{
		Auth:      auth,
		Users:     service.NewUsers(store),
		Catalogue: service.NewCatalogue(store),
		Bookings:  bookings,
		Dispatch:  e.dispatch,
		Cleaners:  service.NewCleaners(store, payments, hub, pusher, london, clock, log),
		Admin:     service.NewAdmin(store, bookings, hub, pusher, london, clock),
		Payments:  payments,
		WebSocket: hub.Handler(bookings),
		Health:    store.Ping,
		Log:       log,
	})
	srv := httptest.NewServer(api.Routes())
	t.Cleanup(func() {
		hub.Close()
		srv.Close()
		pusher.Wait()
	})
	e.url = srv.URL + "/api/v1"
	return e
}

type response struct {
	status int
	body   []byte
}

func (r response) decode(t *testing.T, v any) {
	t.Helper()
	if err := json.Unmarshal(r.body, v); err != nil {
		t.Fatalf("decode %s: %v", r.body, err)
	}
}

func (r response) errorCode(t *testing.T) string {
	t.Helper()
	var body struct {
		Error struct {
			Code string `json:"code"`
		} `json:"error"`
	}
	r.decode(t, &body)
	return body.Error.Code
}

func (e *testEnv) do(method, path, token string, body any) response {
	e.t.Helper()
	var reader io.Reader
	if body != nil {
		b, err := json.Marshal(body)
		if err != nil {
			e.t.Fatal(err)
		}
		reader = bytes.NewReader(b)
	}
	req, err := http.NewRequest(method, e.url+path, reader)
	if err != nil {
		e.t.Fatal(err)
	}
	req.Header.Set("Content-Type", "application/json")
	if token != "" {
		req.Header.Set("Authorization", "Bearer "+token)
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		e.t.Fatal(err)
	}
	defer resp.Body.Close()
	b, _ := io.ReadAll(resp.Body)
	return response{status: resp.StatusCode, body: b}
}

// expect fails the test unless the response has the given status.
func (e *testEnv) expect(r response, status int) response {
	e.t.Helper()
	if r.status != status {
		e.t.Fatalf("status %d, want %d: %s", r.status, status, r.body)
	}
	return r
}

type session struct {
	AccessToken  string      `json:"access_token"`
	RefreshToken string      `json:"refresh_token"`
	User         domain.User `json:"user"`
}

func (e *testEnv) login(phone string, role domain.Role) session {
	e.t.Helper()
	e.expect(e.do("POST", "/auth/otp", "", map[string]string{"phone": phone}), http.StatusNoContent)
	r := e.expect(e.do("POST", "/auth/verify", "", map[string]string{
		"phone": phone, "code": e.codes.last(phone), "role": string(role),
	}), http.StatusOK)
	var s session
	r.decode(e.t, &s)
	return s
}

type cleaner struct {
	session
	ID uuid.UUID
}

// cleaner signs up a cleaner and approves them at (lat, lng), working every
// day from 08:00 to 18:00.
func (e *testEnv) cleaner(phone string, lat, lng float64, online bool) cleaner {
	e.t.Helper()
	s := e.login(phone, domain.RoleCleaner)
	ctx := context.Background()
	_, err := e.store.Pool().Exec(ctx, `
		UPDATE cleaners SET status = 'approved', is_online = $2, last_lat = $3, last_lng = $4
		WHERE user_id = $1`, s.User.ID, online, lat, lng)
	if err != nil {
		e.t.Fatal(err)
	}
	_, err = e.store.Pool().Exec(ctx, `
		INSERT INTO cleaner_availability (cleaner_id, weekday, start_time, end_time)
		SELECT $1, d, '08:00', '18:00' FROM generate_series(0, 6) AS d`, s.User.ID)
	if err != nil {
		e.t.Fatal(err)
	}
	return cleaner{session: s, ID: s.User.ID}
}

type client struct {
	session
	AddressID uuid.UUID
}

// client signs up a client with an address near Baker Street.
func (e *testEnv) client(phone string) client {
	e.t.Helper()
	s := e.login(phone, domain.RoleClient)
	r := e.expect(e.do("POST", "/me/addresses", s.AccessToken, map[string]any{
		"line1": "221B Baker Street", "city": "London", "postcode": "nw1 6xe", "lat": 51.5238, "lng": -0.1586,
	}), http.StatusCreated)
	var a domain.Address
	r.decode(e.t, &a)
	return client{session: s, AddressID: a.ID}
}

func (e *testEnv) serviceID(slug string) uuid.UUID {
	e.t.Helper()
	var id uuid.UUID
	if err := e.store.Pool().QueryRow(context.Background(), `SELECT id FROM services WHERE slug = $1`, slug).Scan(&id); err != nil {
		e.t.Fatal(err)
	}
	return id
}

// tomorrowAt is a start time that is always far enough ahead to book.
func tomorrowAt(hour int) time.Time {
	d := time.Now().In(london).AddDate(0, 0, 1)
	return time.Date(d.Year(), d.Month(), d.Day(), hour, 0, 0, 0, london)
}

type createdBooking struct {
	Booking domain.Booking `json:"booking"`
	Payment struct {
		ClientSecret string `json:"client_secret"`
	} `json:"payment"`
}

// book creates a standard 2 bed, 1 bath clean (150 minutes).
func (e *testEnv) book(c client, start time.Time) domain.Booking {
	e.t.Helper()
	r := e.expect(e.do("POST", "/bookings", c.AccessToken, map[string]any{
		"service_id": e.serviceID("standard"), "bedrooms": 2, "bathrooms": 1,
		"frequency": "once", "address_id": c.AddressID, "start": start,
	}), http.StatusCreated)
	var cb createdBooking
	r.decode(e.t, &cb)
	if cb.Payment.ClientSecret == "" {
		e.t.Fatal("no client secret in booking response")
	}
	return cb.Booking
}

func (e *testEnv) bookingStatus(id uuid.UUID) (domain.BookingStatus, *uuid.UUID) {
	e.t.Helper()
	var status domain.BookingStatus
	var cleanerID *uuid.UUID
	err := e.store.Pool().QueryRow(context.Background(),
		`SELECT status, cleaner_id FROM bookings WHERE id = $1`, id).Scan(&status, &cleanerID)
	if err != nil {
		e.t.Fatal(err)
	}
	return status, cleanerID
}

func (e *testEnv) paymentStatus(bookingID uuid.UUID) (domain.PaymentStatus, string) {
	e.t.Helper()
	var status domain.PaymentStatus
	var ref string
	err := e.store.Pool().QueryRow(context.Background(),
		`SELECT status, provider_ref FROM payments WHERE booking_id = $1`, bookingID).Scan(&status, &ref)
	if err != nil {
		e.t.Fatal(err)
	}
	return status, ref
}

func (e *testEnv) openOfferFor(bookingID uuid.UUID) *uuid.UUID {
	e.t.Helper()
	var id uuid.UUID
	err := e.store.Pool().QueryRow(context.Background(),
		`SELECT cleaner_id FROM booking_offers WHERE booking_id = $1 AND status = 'open'`, bookingID).Scan(&id)
	if err != nil {
		return nil
	}
	return &id
}

// forceOffer gives a cleaner an open offer directly, to set up races the
// one-offer-at-a-time dispatcher would never create on its own.
func (e *testEnv) forceOffer(bookingID, cleanerID uuid.UUID) {
	e.t.Helper()
	_, err := e.store.Pool().Exec(context.Background(), `
		INSERT INTO booking_offers (booking_id, cleaner_id, expires_at) VALUES ($1, $2, now() + interval '1 minute')
		ON CONFLICT (booking_id, cleaner_id) DO UPDATE SET status = 'open', expires_at = now() + interval '1 minute'`,
		bookingID, cleanerID)
	if err != nil {
		e.t.Fatal(err)
	}
}
