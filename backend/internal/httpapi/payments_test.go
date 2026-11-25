package httpapi_test

import (
	"net/http"
	"testing"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

func (e *testEnv) webhook(id, ref string, kind domain.PaymentEventKind) {
	e.t.Helper()
	e.expect(e.doWithHeaders("POST", "/webhooks/stripe", "", map[string]string{"id": id, "ref": ref, "kind": string(kind)},
		map[string]string{"Stripe-Signature": "valid"}), http.StatusOK)
}

func TestDeclinedCardCanBeRetried(t *testing.T) {
	e := newEnv(t)
	e.payments.hold = true
	cl := e.cleaner("+447700901601", 51.5200, -0.1550, true)
	c := e.client("+447700901701")
	b := e.book(c, tomorrowAt(10))
	_, ref := e.paymentStatus(b.ID)

	e.webhook("evt_declined", ref, domain.PaymentEventFailed)
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusPending {
		t.Fatalf("booking is %s after a declined card, want still pending", status)
	}
	if got, _ := e.paymentStatus(b.ID); got != domain.PaymentFailed {
		t.Errorf("payment = %s, want failed", got)
	}

	// The client tries another card in the same sheet.
	e.webhook("evt_retry", ref, domain.PaymentEventAuthorized)
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusConfirmed {
		t.Fatalf("booking is %s after the retry, want confirmed", status)
	}
	if offered := e.openOfferFor(b.ID); offered == nil || *offered != cl.ID {
		t.Errorf("confirmed booking offered to %v, want %s", offered, cl.ID)
	}
}

func TestCanceledIntentCancelsBooking(t *testing.T) {
	e := newEnv(t)
	e.payments.hold = true
	e.cleaner("+447700901602", 51.5200, -0.1550, true)
	c := e.client("+447700901702")
	b := e.book(c, tomorrowAt(10))
	_, ref := e.paymentStatus(b.ID)

	e.webhook("evt_canceled", ref, domain.PaymentEventCanceled)
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusCancelled {
		t.Fatalf("booking is %s after payment_intent.canceled, want cancelled", status)
	}
	if got, _ := e.paymentStatus(b.ID); got != domain.PaymentCanceled {
		t.Errorf("payment = %s, want canceled", got)
	}
}

func (e *testEnv) authorizeDue() {
	e.t.Helper()
	if err := e.payment.AuthorizeDue(e.t.Context()); err != nil {
		e.t.Fatal(err)
	}
}

func (e *testEnv) authorizeAt(bookingID uuid.UUID) *time.Time {
	e.t.Helper()
	var at *time.Time
	if err := e.store.Pool().QueryRow(e.t.Context(), `SELECT authorize_at FROM bookings WHERE id = $1`, bookingID).Scan(&at); err != nil {
		e.t.Fatal(err)
	}
	return at
}

func (e *testEnv) latestPayment(bookingID uuid.UUID) (kind string, status domain.PaymentStatus) {
	e.t.Helper()
	err := e.store.Pool().QueryRow(e.t.Context(), `
		SELECT kind, status FROM payments WHERE booking_id = $1 ORDER BY created_at DESC LIMIT 1`, bookingID).Scan(&kind, &status)
	if err != nil {
		e.t.Fatal(err)
	}
	return kind, status
}

func TestFarAheadBookingSavesCardAndIsAuthorisedLater(t *testing.T) {
	e := newEnv(t)
	cl := e.cleaner("+447700901603", 51.5200, -0.1550, true)
	c := e.client("+447700901703")
	start := daysAheadAt(7, 10)

	cb := e.create(c, start, domain.FrequencyOnce)
	if cb.Payment.Kind != "setup" || cb.Booking.Status != domain.StatusPending {
		t.Fatalf("booking a week ahead: payment %q, status %s; want a setup and pending", cb.Payment.Kind, cb.Booking.Status)
	}
	if kind, status := e.latestPayment(cb.Booking.ID); kind != "setup" || status != domain.PaymentSaved {
		t.Errorf("payment = %s/%s, want a saved card", kind, status)
	}
	if at := e.authorizeAt(cb.Booking.ID); at == nil || !at.Equal(start.Add(-48*time.Hour)) {
		t.Errorf("authorize_at = %v, want 48 hours before %v", at, start)
	}

	e.authorizeDue()
	if status, _ := e.bookingStatus(cb.Booking.ID); status != domain.StatusPending {
		t.Fatalf("booking is %s before its authorisation time, want pending", status)
	}

	e.travelTo(start.Add(-48*time.Hour + time.Minute))
	e.expect(e.do("POST", "/cleaner/online", cl.AccessToken, map[string]any{"online": true, "lat": 51.52, "lng": -0.155}), http.StatusNoContent)
	e.authorizeDue()
	if status, _ := e.bookingStatus(cb.Booking.ID); status != domain.StatusConfirmed {
		t.Fatalf("booking is %s after the off-session authorisation, want confirmed", status)
	}
	if kind, status := e.latestPayment(cb.Booking.ID); kind != "payment" || status != domain.PaymentAuthorized {
		t.Errorf("payment = %s/%s, want an authorised payment", kind, status)
	}
	saved := e.payments.calls("saved")
	if len(saved) != 1 || saved[0].Customer == "" || saved[0].Customer != e.payments.calls("setup")[0].Customer {
		t.Errorf("off-session calls = %+v, want one on the customer the card was saved for", saved)
	}
	if offered := e.openOfferFor(cb.Booking.ID); offered == nil || *offered != cl.ID {
		t.Errorf("confirmed booking offered to %v, want %s", offered, cl.ID)
	}
	e.authorizeDue()
	if n := len(e.payments.calls("saved")); n != 1 {
		t.Errorf("saved card charged %d times, want once", n)
	}
}

func TestSetupWebhookSavesCard(t *testing.T) {
	e := newEnv(t)
	e.payments.hold = true
	e.cleaner("+447700901604", 51.5200, -0.1550, true)
	c := e.client("+447700901704")
	start := daysAheadAt(10, 11)
	cb := e.create(c, start, domain.FrequencyOnce)
	if cb.Payment.Kind != "setup" {
		t.Fatalf("payment kind %q, want setup", cb.Payment.Kind)
	}
	if at := e.authorizeAt(cb.Booking.ID); at != nil {
		t.Fatalf("authorisation scheduled at %v before the card was saved", at)
	}
	_, ref := e.paymentStatus(cb.Booking.ID)

	e.webhook("evt_setup_failed", ref, domain.PaymentEventFailed)
	e.webhook("evt_setup_ok", ref, domain.PaymentEventSaved)
	if _, status := e.latestPayment(cb.Booking.ID); status != domain.PaymentSaved {
		t.Errorf("payment = %s, want saved", status)
	}
	if at := e.authorizeAt(cb.Booking.ID); at == nil || !at.Equal(start.Add(-48*time.Hour)) {
		t.Errorf("authorize_at = %v, want 48 hours before the visit", at)
	}
	if status, _ := e.bookingStatus(cb.Booking.ID); status != domain.StatusPending {
		t.Errorf("booking is %s, want pending until the card is charged", status)
	}
}

func TestDeclinedSavedCardAsksClientToPay(t *testing.T) {
	e := newEnv(t)
	e.payments.declineSaved = true
	e.cleaner("+447700901605", 51.5200, -0.1550, true)
	c := e.client("+447700901705")
	start := daysAheadAt(8, 10)
	b := e.create(c, start, domain.FrequencyOnce).Booking

	watcher := e.ws(c.AccessToken)
	watcher.join(b.ID)
	e.travelTo(start.Add(-47 * time.Hour))
	e.authorizeDue()

	if status, _ := e.bookingStatus(b.ID); status != domain.StatusPending {
		t.Fatalf("booking is %s after a declined saved card, want pending", status)
	}
	if got := watcher.receiveType("booking.status"); got["status"] != "pending" {
		t.Errorf("client got %v, want a pending booking.status", got)
	}

	other := e.client("+447700901706")
	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/payment", other.AccessToken, nil), http.StatusForbidden)

	var pay struct {
		Kind         string `json:"kind"`
		ClientSecret string `json:"client_secret"`
	}
	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/payment", c.AccessToken, nil), http.StatusOK).decode(t, &pay)
	if pay.Kind != "payment" || pay.ClientSecret == "" {
		t.Fatalf("pay = %+v, want a payment with a client secret", pay)
	}
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusConfirmed {
		t.Fatalf("booking is %s after paying, want confirmed", status)
	}
	r := e.do("POST", "/bookings/"+b.ID.String()+"/payment", c.AccessToken, nil)
	if r.status != http.StatusConflict || r.errorCode(t) != "invalid_transition" {
		t.Errorf("paying a confirmed booking: got %d %s, want 409 invalid_transition", r.status, r.body)
	}
}

func TestPayReplacesUnpaidIntent(t *testing.T) {
	e := newEnv(t)
	e.payments.hold = true
	e.cleaner("+447700901606", 51.5200, -0.1550, true)
	c := e.client("+447700901707")
	b := e.book(c, tomorrowAt(10))
	_, first := e.paymentStatus(b.ID)

	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/payment", c.AccessToken, nil), http.StatusOK)
	_, second := e.paymentStatus(b.ID)
	if second == first {
		t.Fatal("pay did not create a new intent")
	}
	// Releasing the old intent sends its canceled webhook; the booking stays.
	e.webhook("evt_old_canceled", first, domain.PaymentEventCanceled)
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusPending {
		t.Fatalf("booking is %s after the replaced intent was canceled, want pending", status)
	}
	e.webhook("evt_new_ok", second, domain.PaymentEventAuthorized)
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusConfirmed {
		t.Errorf("booking is %s, want confirmed", status)
	}
}

func TestRecurringVisitsUseSavedCard(t *testing.T) {
	e := newEnv(t)
	e.cleaner("+447700901607", 51.5200, -0.1550, true)
	c := e.client("+447700901708")
	first := e.create(c, tomorrowAt(10), domain.FrequencyWeekly)
	if first.Payment.Kind != "payment" {
		t.Fatalf("first visit payment kind %q, want payment", first.Payment.Kind)
	}
	intents := e.payments.calls("intent")
	if len(intents) != 1 || !intents[0].SaveCard || intents[0].Customer == "" {
		t.Fatalf("first intent = %+v, want it to save the card on a customer", intents)
	}

	e.travelTo(time.Now().Add(24 * time.Hour))
	if n := e.runPlans(); n != 1 {
		t.Fatalf("scheduler created %d visits, want 1", n)
	}
	var next domain.Booking
	err := e.store.Pool().QueryRow(t.Context(), `
		SELECT id, lower(period) FROM bookings WHERE client_id = $1 AND id <> $2`, c.User.ID, first.Booking.ID).Scan(&next.ID, &next.Start)
	if err != nil {
		t.Fatal(err)
	}
	if at := e.authorizeAt(next.ID); at == nil || !at.Equal(next.Start.Add(-48*time.Hour)) {
		t.Fatalf("authorize_at = %v, want 48 hours before %v", at, next.Start)
	}
	e.travelTo(next.Start.Add(-48*time.Hour + time.Minute))
	e.authorizeDue()
	if status, _ := e.bookingStatus(next.ID); status != domain.StatusConfirmed {
		t.Fatalf("recurring visit is %s, want confirmed with the saved card", status)
	}
	if saved := e.payments.calls("saved"); len(saved) != 1 || saved[0].Customer != intents[0].Customer {
		t.Errorf("off-session calls = %+v, want one on the first visit's customer", saved)
	}
}
