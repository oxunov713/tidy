package httpapi_test

import (
	"net/http"
	"testing"

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
