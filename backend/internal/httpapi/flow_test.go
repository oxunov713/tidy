package httpapi_test

import (
	"net/http"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

func TestOTPLogin(t *testing.T) {
	e := newEnv(t)
	const phone = "+447700900500"

	e.expect(e.do("POST", "/auth/otp", "", map[string]string{"phone": "07700"}), http.StatusBadRequest)
	e.expect(e.do("POST", "/auth/otp", "", map[string]string{"phone": phone}), http.StatusNoContent)

	wrong := e.do("POST", "/auth/verify", "", map[string]string{"phone": phone, "code": "000000"})
	if wrong.status != http.StatusUnauthorized || wrong.errorCode(t) != "unauthorized" {
		t.Fatalf("wrong code: got %d %s", wrong.status, wrong.body)
	}

	r := e.expect(e.do("POST", "/auth/verify", "", map[string]string{
		"phone": phone, "code": e.codes.last(phone), "role": "cleaner",
	}), http.StatusOK)
	var s session
	r.decode(t, &s)
	if s.AccessToken == "" || s.RefreshToken == "" || s.User.Role != domain.RoleCleaner {
		t.Fatalf("bad session: %s", r.body)
	}

	// A code works once.
	e.expect(e.do("POST", "/auth/verify", "", map[string]string{"phone": phone, "code": e.codes.last(phone)}), http.StatusUnauthorized)

	var me struct {
		domain.User
		Cleaner *domain.Cleaner `json:"cleaner"`
	}
	e.expect(e.do("GET", "/me", s.AccessToken, nil), http.StatusOK).decode(t, &me)
	if me.Phone != phone || me.Cleaner == nil || me.Cleaner.Status != domain.CleanerPending {
		t.Errorf("GET /me = %+v, want a pending cleaner", me)
	}
	e.expect(e.do("GET", "/me", "not-a-token", nil), http.StatusUnauthorized)
	e.expect(e.do("GET", "/bookings", s.AccessToken, nil), http.StatusForbidden)

	// Refresh rotates; after the grace window the old refresh token stops
	// working, and using it again signs the user out everywhere.
	var next session
	e.expect(e.do("POST", "/auth/refresh", "", map[string]string{"refresh_token": s.RefreshToken}), http.StatusOK).decode(t, &next)
	if next.RefreshToken == s.RefreshToken {
		t.Fatal("refresh token was not rotated")
	}
	e.travelTo(time.Now().Add(11 * time.Second))
	e.expect(e.do("POST", "/auth/refresh", "", map[string]string{"refresh_token": s.RefreshToken}), http.StatusUnauthorized)
	e.expect(e.do("POST", "/auth/refresh", "", map[string]string{"refresh_token": next.RefreshToken}), http.StatusUnauthorized)

	// Logout revokes the refresh token. Leaving the role out signs in as
	// whatever the account is.
	again := e.login(phone, "")
	if again.User.Role != domain.RoleCleaner {
		t.Errorf("existing user kept role %s, want cleaner", again.User.Role)
	}
	e.expect(e.do("POST", "/auth/logout", "", map[string]string{"refresh_token": again.RefreshToken}), http.StatusNoContent)
	e.expect(e.do("POST", "/auth/refresh", "", map[string]string{"refresh_token": again.RefreshToken}), http.StatusUnauthorized)
}

func TestOTPLimits(t *testing.T) {
	e := newEnv(t)
	const phone = "+447700900501"

	for i := 0; i < 3; i++ {
		e.expect(e.do("POST", "/auth/otp", "", map[string]string{"phone": phone}), http.StatusNoContent)
	}
	r := e.do("POST", "/auth/otp", "", map[string]string{"phone": phone})
	if r.status != http.StatusTooManyRequests || r.errorCode(t) != "too_many_requests" {
		t.Fatalf("4th code request: got %d %s", r.status, r.body)
	}

	// Five wrong guesses burn the code, even the right one fails after that.
	for i := 0; i < 5; i++ {
		e.expect(e.do("POST", "/auth/verify", "", map[string]string{"phone": phone, "code": "000000"}), http.StatusUnauthorized)
	}
	e.expect(e.do("POST", "/auth/verify", "", map[string]string{"phone": phone, "code": e.codes.last(phone)}), http.StatusTooManyRequests)
}

func TestBookingFlow(t *testing.T) {
	e := newEnv(t)
	near := e.cleaner("+447700900601", 51.5200, -0.1550, true)
	e.cleaner("+447700900602", 51.5000, -0.1000, true)
	c := e.client("+447700900701")
	start := tomorrowAt(10)

	var quote domain.Quote
	e.expect(e.do("POST", "/quotes", "", map[string]any{
		"service_id": e.serviceID("standard"), "bedrooms": 2, "bathrooms": 1, "frequency": "weekly",
	}), http.StatusOK).decode(t, &quote)
	if quote.Total != 5100 || quote.Discount != 900 {
		t.Errorf("weekly quote = %+v, want total 5100 with 900 off", quote)
	}

	var day struct {
		Slots []struct {
			Start     time.Time `json:"start"`
			Available bool      `json:"available"`
		} `json:"slots"`
	}
	path := "/slots?service_id=" + e.serviceID("standard").String() + "&bedrooms=2&bathrooms=1&date=" +
		start.Format(time.DateOnly) + "&address_id=" + c.AddressID.String()
	e.expect(e.do("GET", path, c.AccessToken, nil), http.StatusOK).decode(t, &day)
	free := map[string]bool{}
	for _, s := range day.Slots {
		free[s.Start.In(london).Format("15:04")] = s.Available
	}
	if !free["10:00"] || free["07:30"] || free["16:00"] {
		t.Errorf("slots = %v; want 10:00 free, 07:30 and 16:00 (ends after 18:00) not", free)
	}

	// The mock provider authorises at once, so the booking is confirmed and
	// offered to the nearest cleaner straight away.
	b := e.book(c, start)
	if b.Status != domain.StatusConfirmed || b.Total != 6000 {
		t.Fatalf("new booking = %s / %d, want confirmed / 6000", b.Status, b.Total)
	}
	if got, _ := e.paymentStatus(b.ID); got != domain.PaymentAuthorized {
		t.Fatalf("payment = %s, want authorized", got)
	}
	if offered := e.openOfferFor(b.ID); offered == nil || *offered != near.ID {
		t.Fatalf("offer went to %v, want the nearest cleaner %s", offered, near.ID)
	}

	var offers []struct {
		Booking  domain.Booking `json:"booking"`
		Postcode string         `json:"postcode"`
	}
	e.expect(e.do("GET", "/cleaner/offers", near.AccessToken, nil), http.StatusOK).decode(t, &offers)
	if len(offers) != 1 || offers[0].Booking.ID != b.ID || offers[0].Postcode != "NW1 6XE" {
		t.Fatalf("offers = %+v", offers)
	}

	e.expect(e.do("POST", "/cleaner/offers/"+b.ID.String()+"/accept", near.AccessToken, nil), http.StatusOK)
	if status, assigned := e.bookingStatus(b.ID); status != domain.StatusAssigned || *assigned != near.ID {
		t.Fatalf("after accept: %s %v", status, assigned)
	}

	// Too early to set off.
	r := e.do("POST", "/cleaner/jobs/"+b.ID.String()+"/status", near.AccessToken, map[string]string{"status": "on_the_way"})
	if r.status != http.StatusConflict || r.errorCode(t) != "invalid_transition" {
		t.Fatalf("early on_the_way: %d %s", r.status, r.body)
	}
	e.travelTo(start.Add(-time.Hour))
	for _, status := range []string{"on_the_way", "in_progress", "completed"} {
		e.expect(e.do("POST", "/cleaner/jobs/"+b.ID.String()+"/status", near.AccessToken, map[string]string{"status": status}), http.StatusOK)
	}
	if got, ref := e.paymentStatus(b.ID); got != domain.PaymentCaptured || len(e.payments.captured) != 1 || e.payments.captured[0] != ref {
		t.Fatalf("payment = %s, captured %v; want captured once", got, e.payments.captured)
	}

	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/review", c.AccessToken, map[string]any{"rating": 5, "tip": 300}), http.StatusCreated)
	var details struct {
		domain.Booking
		Cleaner struct {
			Rating float64 `json:"rating"`
		} `json:"cleaner"`
		Events []domain.BookingEvent `json:"events"`
	}
	e.expect(e.do("GET", "/bookings/"+b.ID.String(), c.AccessToken, nil), http.StatusOK).decode(t, &details)
	if details.Status != domain.StatusCompleted || details.Cleaner.Rating != 5 || len(details.Events) != 6 {
		t.Errorf("details: status %s, rating %v, %d events", details.Status, details.Cleaner.Rating, len(details.Events))
	}

	var past struct {
		Items []domain.Booking `json:"items"`
	}
	e.expect(e.do("GET", "/bookings?scope=past", c.AccessToken, nil), http.StatusOK).decode(t, &past)
	if len(past.Items) != 1 || past.Items[0].ID != b.ID {
		t.Errorf("past bookings = %+v", past.Items)
	}
}

func TestConcurrentAcceptOnlyOneWins(t *testing.T) {
	e := newEnv(t)
	a := e.cleaner("+447700900611", 51.5200, -0.1550, true)
	b := e.cleaner("+447700900612", 51.5210, -0.1560, true)
	c := e.client("+447700900711")

	booking := e.book(c, tomorrowAt(11))
	e.forceOffer(booking.ID, a.ID)
	e.forceOffer(booking.ID, b.ID)

	statuses := make([]int, 2)
	codes := make([]string, 2)
	var ready, done sync.WaitGroup
	ready.Add(1)
	for i, cl := range []cleaner{a, b} {
		done.Add(1)
		go func() {
			defer done.Done()
			ready.Wait()
			r := e.do("POST", "/cleaner/offers/"+booking.ID.String()+"/accept", cl.AccessToken, nil)
			statuses[i] = r.status
			if r.status != http.StatusOK {
				codes[i] = r.errorCode(t)
			}
		}()
	}
	ready.Done()
	done.Wait()

	winners := 0
	var winner uuid.UUID
	for i, s := range statuses {
		switch {
		case s == http.StatusOK:
			winners++
			winner = []cleaner{a, b}[i].ID
		case s != http.StatusConflict || codes[i] != "offer_gone":
			t.Errorf("loser got %d %s, want 409 offer_gone", s, codes[i])
		}
	}
	if winners != 1 {
		t.Fatalf("%d cleaners won, want exactly 1 (statuses %v)", winners, statuses)
	}
	if status, assigned := e.bookingStatus(booking.ID); status != domain.StatusAssigned || *assigned != winner {
		t.Errorf("booking is %s with %v, want assigned to %s", status, assigned, winner)
	}
}

func TestOverlappingAcceptIsSlotTaken(t *testing.T) {
	e := newEnv(t)
	busy := e.cleaner("+447700900621", 51.5200, -0.1550, true)
	// Offline, so the dispatcher can't use them, but the slot still shows as free.
	e.cleaner("+447700900622", 51.5210, -0.1560, false)
	c := e.client("+447700900721")

	first := e.book(c, tomorrowAt(10))
	e.expect(e.do("POST", "/cleaner/offers/"+first.ID.String()+"/accept", busy.AccessToken, nil), http.StatusOK)

	// 11:00 overlaps the first visit (10:00-12:30).
	second := e.book(c, tomorrowAt(11))
	if offered := e.openOfferFor(second.ID); offered != nil {
		t.Fatalf("dispatcher offered an overlapping job to %s", offered)
	}
	e.forceOffer(second.ID, busy.ID)

	r := e.do("POST", "/cleaner/offers/"+second.ID.String()+"/accept", busy.AccessToken, nil)
	if r.status != http.StatusConflict || r.errorCode(t) != "slot_taken" {
		t.Fatalf("overlapping accept: got %d %s, want 409 slot_taken", r.status, r.body)
	}
	if status, assigned := e.bookingStatus(second.ID); status != domain.StatusConfirmed || assigned != nil {
		t.Errorf("second booking is %s with %v, want still confirmed and unassigned", status, assigned)
	}
}

func TestCancelRefunds(t *testing.T) {
	e := newEnv(t)
	cl := e.cleaner("+447700900631", 51.5200, -0.1550, true)
	c := e.client("+447700900731")
	start := tomorrowAt(14)

	b := e.book(c, start)
	if offered := e.openOfferFor(b.ID); offered == nil || *offered != cl.ID {
		t.Fatalf("expected an open offer for the cleaner, got %v", offered)
	}
	_, ref := e.paymentStatus(b.ID)

	// Someone else's booking can't be cancelled.
	other := e.client("+447700900732")
	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/cancel", other.AccessToken, nil), http.StatusForbidden)

	e.travelTo(start.Add(-25 * time.Hour))
	var res struct {
		Booking  domain.Booking `json:"booking"`
		Refunded bool           `json:"refunded"`
	}
	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/cancel", c.AccessToken, nil), http.StatusOK).decode(t, &res)
	if !res.Refunded || res.Booking.Status != domain.StatusCancelled {
		t.Fatalf("cancel = %+v, want cancelled and refunded", res)
	}
	if got, _ := e.paymentStatus(b.ID); got != domain.PaymentRefunded {
		t.Errorf("payment = %s, want refunded", got)
	}
	if len(e.payments.refunded) != 1 || e.payments.refunded[0] != ref {
		t.Errorf("provider refunds = %v, want [%s]", e.payments.refunded, ref)
	}
	if offered := e.openOfferFor(b.ID); offered != nil {
		t.Errorf("offer for %s still open after cancel", offered)
	}
	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/cancel", c.AccessToken, nil), http.StatusConflict)
}

func TestLateCancelIsCharged(t *testing.T) {
	e := newEnv(t)
	e.cleaner("+447700900641", 51.5200, -0.1550, true)
	c := e.client("+447700900741")
	start := tomorrowAt(15)
	b := e.book(c, start)

	e.travelTo(start.Add(-5 * time.Hour))
	var res struct {
		Refunded bool `json:"refunded"`
	}
	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/cancel", c.AccessToken, nil), http.StatusOK).decode(t, &res)
	if res.Refunded {
		t.Error("late cancellation was refunded")
	}
	if got, _ := e.paymentStatus(b.ID); got != domain.PaymentCaptured {
		t.Errorf("payment = %s, want captured as a late cancellation fee", got)
	}
}

func TestOfferExpiresAndMovesOn(t *testing.T) {
	e := newEnv(t)
	first := e.cleaner("+447700900651", 51.5200, -0.1550, true)
	second := e.cleaner("+447700900652", 51.5000, -0.1000, true)
	c := e.client("+447700900751")

	b := e.book(c, tomorrowAt(9))
	if offered := e.openOfferFor(b.ID); offered == nil || *offered != first.ID {
		t.Fatalf("first offer went to %v, want %s", offered, first.ID)
	}

	e.travelTo(time.Now().Add(domain.OfferTTL + time.Second))
	if err := e.dispatch.Sweep(t.Context()); err != nil {
		t.Fatal(err)
	}
	if offered := e.openOfferFor(b.ID); offered == nil || *offered != second.ID {
		t.Fatalf("after expiry the offer went to %v, want %s", offered, second.ID)
	}
	r := e.do("POST", "/cleaner/offers/"+b.ID.String()+"/accept", first.AccessToken, nil)
	if r.status != http.StatusConflict || r.errorCode(t) != "offer_gone" {
		t.Errorf("accepting an expired offer: got %d %s", r.status, r.body)
	}
}

func TestErrorShape(t *testing.T) {
	e := newEnv(t)
	c := e.client("+447700900761")
	r := e.do("POST", "/quotes", c.AccessToken, map[string]any{"service_id": uuid.New(), "bedrooms": 0, "bathrooms": 1})
	var body struct {
		Error struct {
			Code    string            `json:"code"`
			Message string            `json:"message"`
			Details map[string]string `json:"details"`
		} `json:"error"`
	}
	r.decode(t, &body)
	if r.status != http.StatusBadRequest || body.Error.Code != "invalid_request" || body.Error.Message == "" || body.Error.Details["service_id"] == "" {
		t.Errorf("got %d %s", r.status, r.body)
	}
	e.expect(e.do("GET", "/bookings/"+uuid.NewString(), c.AccessToken, nil), http.StatusNotFound)
	e.expect(e.do("GET", "/admin/stats/today", c.AccessToken, nil), http.StatusForbidden)
}

func TestWebhookIsIdempotent(t *testing.T) {
	e := newEnv(t)
	e.payments.hold = true
	cl := e.cleaner("+447700900661", 51.5200, -0.1550, true)
	c := e.client("+447700900771")

	b := e.book(c, tomorrowAt(12))
	if b.Status != domain.StatusPending {
		t.Fatalf("booking is %s before the webhook, want pending", b.Status)
	}
	_, ref := e.paymentStatus(b.ID)
	event := map[string]string{"id": "evt_1", "ref": ref}

	e.expect(e.doWithHeaders("POST", "/webhooks/stripe", "", event, map[string]string{"Stripe-Signature": "forged"}), http.StatusBadRequest)
	for i := 0; i < 2; i++ {
		e.expect(e.doWithHeaders("POST", "/webhooks/stripe", "", event, map[string]string{"Stripe-Signature": "valid"}), http.StatusOK)
	}

	if status, _ := e.bookingStatus(b.ID); status != domain.StatusConfirmed {
		t.Fatalf("booking is %s after the webhook, want confirmed", status)
	}
	if got, _ := e.paymentStatus(b.ID); got != domain.PaymentAuthorized {
		t.Errorf("payment = %s, want authorized", got)
	}
	var confirmations int
	err := e.store.Pool().QueryRow(t.Context(),
		`SELECT count(*) FROM booking_events WHERE booking_id = $1 AND status = 'confirmed'`, b.ID).Scan(&confirmations)
	if err != nil || confirmations != 1 {
		t.Errorf("confirmed events = %d (%v), want 1", confirmations, err)
	}
	if offered := e.openOfferFor(b.ID); offered == nil || *offered != cl.ID {
		t.Errorf("confirmed booking offered to %v, want %s", offered, cl.ID)
	}
}

func TestDispatchSkipsCleanersNotSeenLately(t *testing.T) {
	e := newEnv(t)
	ghost := e.cleaner("+447700902101", 51.5200, -0.1550, true)
	far := e.cleaner("+447700902102", 51.5000, -0.1000, true)
	c := e.client("+447700902201")
	if _, err := e.store.Pool().Exec(t.Context(),
		`UPDATE cleaners SET last_seen_at = $2 WHERE user_id = $1`, ghost.ID, e.now().Add(-11*time.Minute)); err != nil {
		t.Fatal(err)
	}

	b := e.book(c, tomorrowAt(10))
	if offered := e.openOfferFor(b.ID); offered == nil || *offered != far.ID {
		t.Fatalf("offer went to %v, want %s: the nearer cleaner hasn't been seen for 11 minutes", offered, far.ID)
	}

	// Going online again counts as being seen, on the service clock.
	e.travelTo(time.Now().Add(time.Hour))
	e.expect(e.do("POST", "/cleaner/online", ghost.AccessToken, map[string]any{"online": true, "lat": 51.52, "lng": -0.155}), http.StatusNoContent)
	var seen time.Time
	if err := e.store.Pool().QueryRow(t.Context(), `SELECT last_seen_at FROM cleaners WHERE user_id = $1`, ghost.ID).Scan(&seen); err != nil {
		t.Fatal(err)
	}
	if d := e.now().Sub(seen); d < 0 || d > time.Minute {
		t.Errorf("last_seen_at = %v, want about %v", seen, e.now())
	}
	second := e.book(c, tomorrowAt(14))
	if offered := e.openOfferFor(second.ID); offered == nil || *offered != ghost.ID {
		t.Errorf("offer went to %v, want the nearer cleaner %s now that they are back", offered, ghost.ID)
	}
}

func TestChatClosesAfterTheBooking(t *testing.T) {
	e := newEnv(t)
	cl := e.cleaner("+447700902701", 51.5200, -0.1550, true)
	c := e.client("+447700902801")
	start := tomorrowAt(10)
	done := e.book(c, start)
	e.expect(e.do("POST", "/cleaner/offers/"+done.ID.String()+"/accept", cl.AccessToken, nil), http.StatusOK)
	cancelled := e.book(c, tomorrowAt(14))
	e.expect(e.do("POST", "/bookings/"+cancelled.ID.String()+"/cancel", c.AccessToken, nil), http.StatusOK)

	post := func(id uuid.UUID) response {
		return e.do("POST", "/bookings/"+id.String()+"/messages", c.AccessToken, map[string]string{"body": "Thanks!"})
	}
	if r := post(cancelled.ID); r.status != http.StatusConflict || r.errorCode(t) != "invalid_transition" {
		t.Errorf("chat on a cancelled booking: got %d %s", r.status, r.body)
	}

	e.travelTo(start.Add(-time.Hour))
	for _, s := range []string{"on_the_way", "in_progress", "completed"} {
		e.expect(e.do("POST", "/cleaner/jobs/"+done.ID.String()+"/status", cl.AccessToken, map[string]string{"status": s}), http.StatusOK)
	}
	// The database stamps updated_at with its own clock; line it up with the
	// travelled service clock.
	if _, err := e.store.Pool().Exec(t.Context(), `UPDATE bookings SET updated_at = $2 WHERE id = $1`, done.ID, e.now()); err != nil {
		t.Fatal(err)
	}
	e.expect(post(done.ID), http.StatusCreated)
	e.travelTo(e.now().Add(25 * time.Hour))
	if r := post(done.ID); r.status != http.StatusConflict || r.errorCode(t) != "invalid_transition" {
		t.Errorf("chat 25 hours after completion: got %d %s", r.status, r.body)
	}
}
