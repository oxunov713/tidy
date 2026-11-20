package httpapi_test

import (
	"net/http"
	"testing"
	"time"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

func (e *testEnv) sweepStuck() {
	e.t.Helper()
	if err := e.bookings.SweepStuck(e.t.Context()); err != nil {
		e.t.Fatal(err)
	}
}

func TestUnpaidBookingIsCancelledAfter30Minutes(t *testing.T) {
	e := newEnv(t)
	e.payments.hold = true
	e.cleaner("+447700901901", 51.5200, -0.1550, true)
	c := e.client("+447700902001")
	b := e.book(c, tomorrowAt(10))
	_, ref := e.paymentStatus(b.ID)
	watcher := e.ws(c.AccessToken)
	watcher.join(b.ID)

	e.travelTo(time.Now().Add(29 * time.Minute))
	e.sweepStuck()
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusPending {
		t.Fatalf("booking is %s after 29 minutes, want still pending", status)
	}

	e.travelTo(time.Now().Add(31 * time.Minute))
	e.sweepStuck()
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusCancelled {
		t.Fatalf("booking is %s after 31 minutes unpaid, want cancelled", status)
	}
	if got, _ := e.paymentStatus(b.ID); got != domain.PaymentCanceled {
		t.Errorf("payment = %s, want the intent released", got)
	}
	if len(e.payments.refunded) != 1 || e.payments.refunded[0] != ref {
		t.Errorf("provider releases = %v, want [%s]", e.payments.refunded, ref)
	}
	if got := watcher.receiveType("booking.status"); got["status"] != "cancelled" {
		t.Errorf("client got %v, want the cancelled status", got)
	}
}

func TestSavedCardBookingDoesNotTimeOut(t *testing.T) {
	e := newEnv(t)
	e.cleaner("+447700901902", 51.5200, -0.1550, true)
	c := e.client("+447700902002")
	b := e.create(c, daysAheadAt(9, 10), domain.FrequencyOnce).Booking

	e.travelTo(time.Now().Add(2 * time.Hour))
	e.sweepStuck()
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusPending {
		t.Errorf("booking with a saved card is %s, want pending until it is charged", status)
	}
}

func TestDeclinedSavedCardGetsThirtyMinutesToPay(t *testing.T) {
	e := newEnv(t)
	e.payments.declineSaved = true
	e.cleaner("+447700901903", 51.5200, -0.1550, true)
	c := e.client("+447700902003")
	start := daysAheadAt(8, 10)
	b := e.create(c, start, domain.FrequencyOnce).Booking

	declined := start.Add(-47 * time.Hour)
	e.travelTo(declined)
	e.authorizeDue()
	e.travelTo(declined.Add(20 * time.Minute))
	e.sweepStuck()
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusPending {
		t.Fatalf("booking is %s 20 minutes after the decline, want pending", status)
	}
	e.travelTo(declined.Add(31 * time.Minute))
	e.sweepStuck()
	if status, _ := e.bookingStatus(b.ID); status != domain.StatusCancelled {
		t.Errorf("booking is %s 31 minutes after the decline, want cancelled", status)
	}
}

func TestBookingWithoutCleanerIsCancelledTwoHoursBefore(t *testing.T) {
	e := newEnv(t)
	// Offline, so the slot is free but nobody gets the offer.
	e.cleaner("+447700901904", 51.5200, -0.1550, false)
	taker := e.cleaner("+447700901905", 51.5210, -0.1560, false)
	c := e.client("+447700902004")
	start := tomorrowAt(10)
	lonely := e.book(c, start)
	taken := e.book(c, start.Add(-90*time.Minute))
	e.forceOffer(taken.ID, taker.ID)
	e.expect(e.do("POST", "/cleaner/offers/"+taken.ID.String()+"/accept", taker.AccessToken, nil), http.StatusOK)
	if status, _ := e.bookingStatus(lonely.ID); status != domain.StatusConfirmed {
		t.Fatalf("booking is %s, want confirmed without a cleaner", status)
	}

	e.travelTo(start.Add(-2*time.Hour - time.Minute))
	e.sweepStuck()
	if status, _ := e.bookingStatus(lonely.ID); status != domain.StatusConfirmed {
		t.Fatalf("booking is %s more than 2 hours before the start, want confirmed", status)
	}

	e.travelTo(start.Add(-2*time.Hour + time.Minute))
	e.sweepStuck()
	if status, _ := e.bookingStatus(lonely.ID); status != domain.StatusCancelled {
		t.Fatalf("booking is %s with no cleaner 2 hours before, want cancelled", status)
	}
	if got, _ := e.paymentStatus(lonely.ID); got != domain.PaymentRefunded {
		t.Errorf("payment = %s, want refunded", got)
	}
	if status, _ := e.bookingStatus(taken.ID); status != domain.StatusAssigned {
		t.Errorf("booking with a cleaner is %s, want it kept", status)
	}
}
