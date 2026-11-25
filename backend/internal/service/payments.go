package service

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

const (
	// authorizeBatch bounds one sweep; the next sweep picks up the rest.
	authorizeBatch = 50
	// authorizeRetry is the wait after the provider could not be reached.
	authorizeRetry = 10 * time.Minute
	// PaymentTimeout is how long a pending booking waits for the client to
	// pay before it is cancelled.
	PaymentTimeout = 30 * time.Minute
)

// Payments keeps the money side of a booking in step with its status: hold
// (or save the card) on create, capture on completed, refund or release on
// cancel.
type Payments struct {
	store    PaymentStore
	provider PaymentProvider
	dispatch *Dispatcher
	events   Events
	push     *Pusher
	clock    Clock
	log      *slog.Logger
}

func NewPayments(store PaymentStore, provider PaymentProvider, dispatch *Dispatcher, events Events, push *Pusher, clock Clock, log *slog.Logger) *Payments {
	return &Payments{store: store, provider: provider, dispatch: dispatch, events: events, push: push, clock: clock, log: log}
}

// PaymentStart tells the app which payment sheet to open.
type PaymentStart struct {
	Kind         domain.PaymentKind `json:"kind"`
	ClientSecret string             `json:"client_secret"`
}

// Start begins paying for a booking the client just made: a hold for a
// visit within DirectPaymentWindow, otherwise a saved card that is charged
// AuthorizeAhead before the visit. If the provider succeeds straight away
// (mock), the booking moves on at once.
func (p *Payments) Start(ctx context.Context, b domain.Booking) (PaymentStart, error) {
	start, err := p.begin(ctx, b, domain.PaymentKindFor(b.Start, p.clock.now()))
	if err != nil {
		// Without a payment the booking can never be confirmed.
		if _, cerr := p.store.SetBookingStatus(ctx, b.ID, domain.StatusPending, domain.StatusCancelled, nil); cerr != nil {
			p.log.Error("cancel booking after failed payment start", "booking_id", b.ID, "err", cerr)
		}
		return PaymentStart{}, err
	}
	return start, nil
}

// ScheduleSaved is for visits the scheduler books from a plan: the card
// saved with the first visit is charged AuthorizeAhead before this one.
func (p *Payments) ScheduleSaved(ctx context.Context, b domain.Booking) error {
	at := b.Start.Add(-domain.AuthorizeAhead)
	if now := p.clock.now(); at.Before(now) {
		at = now
	}
	return p.store.ScheduleAuthorization(ctx, b.ID, &at)
}

// Pay starts a new card payment for a pending booking, e.g. after the saved
// card was declined. The previous unpaid intent is released.
func (p *Payments) Pay(ctx context.Context, b domain.Booking) (PaymentStart, error) {
	prev, err := p.store.PaymentForBooking(ctx, b.ID)
	if err != nil && !errors.Is(err, domain.ErrNotFound) {
		return PaymentStart{}, err
	}
	hadPrev := err == nil
	// The client pays now, so the scheduler must not charge the saved card too.
	if err := p.store.ScheduleAuthorization(ctx, b.ID, nil); err != nil {
		return PaymentStart{}, err
	}
	start, err := p.begin(ctx, b, domain.PaymentKindPayment)
	if err != nil {
		return PaymentStart{}, err
	}
	// Released after the new intent exists, so the old intent's canceled
	// webhook can't be mistaken for the booking's current payment.
	if hadPrev && prev.Kind == domain.PaymentKindPayment &&
		(prev.Status == domain.PaymentRequiresAction || prev.Status == domain.PaymentFailed) {
		if err := p.release(ctx, prev); err != nil {
			p.log.Error("release replaced payment", "booking_id", b.ID, "err", err)
		}
	}
	return start, nil
}

func (p *Payments) begin(ctx context.Context, b domain.Booking, kind domain.PaymentKind) (PaymentStart, error) {
	req, err := p.chargeRequest(ctx, b)
	if err != nil {
		return PaymentStart{}, err
	}
	// Cleared again when the payment or card setup goes through.
	if err := p.setDue(ctx, b.ID); err != nil {
		return PaymentStart{}, err
	}
	var intent domain.PaymentIntent
	if kind == domain.PaymentKindSetup {
		intent, err = p.provider.CreateSetup(ctx, req)
	} else {
		intent, err = p.provider.CreateIntent(ctx, req)
	}
	if err != nil {
		return PaymentStart{}, fmt.Errorf("create %s intent: %w", kind, err)
	}
	if err := p.record(ctx, b, kind, intent.Ref); err != nil {
		return PaymentStart{}, err
	}
	if err := p.applyImmediate(ctx, intent); err != nil {
		return PaymentStart{}, err
	}
	return PaymentStart{Kind: kind, ClientSecret: intent.ClientSecret}, nil
}

// AuthorizeDue holds the money on saved cards for visits that start within
// AuthorizeAhead. The scheduler calls it.
func (p *Payments) AuthorizeDue(ctx context.Context) error {
	due, err := p.store.ClaimAuthorizations(ctx, p.clock.now(), authorizeBatch)
	if err != nil {
		return err
	}
	for _, b := range due {
		if err := ctx.Err(); err != nil {
			return err
		}
		if err := p.authorizeSaved(ctx, b); err != nil {
			p.log.Error("authorise saved card", "booking_id", b.ID, "err", err)
			retry := p.clock.now().Add(authorizeRetry)
			if err := p.store.ScheduleAuthorization(ctx, b.ID, &retry); err != nil {
				p.log.Error("schedule authorisation retry", "booking_id", b.ID, "err", err)
			}
		}
	}
	return nil
}

// authorizeSaved returns an error only when it is worth trying again later.
// A declined card asks the client to pay instead.
func (p *Payments) authorizeSaved(ctx context.Context, b domain.Booking) error {
	customer, err := p.store.PaymentCustomer(ctx, b.ClientID, p.provider.Name())
	if errors.Is(err, domain.ErrNotFound) {
		return p.askToPay(ctx, b)
	}
	if err != nil {
		return err
	}
	req, err := p.request(ctx, b, customer)
	if err != nil {
		return err
	}
	intent, err := p.provider.AuthorizeSaved(ctx, req)
	if err != nil {
		return err
	}
	if intent.Ref != "" {
		if err := p.record(ctx, b, domain.PaymentKindPayment, intent.Ref); err != nil {
			return err
		}
	}
	if intent.Status != domain.PaymentAuthorized {
		if intent.Ref != "" {
			if _, err := p.store.ApplyPaymentEvent(ctx, p.provider.Name(),
				domain.PaymentEvent{Kind: domain.PaymentEventFailed, Ref: intent.Ref}); err != nil {
				return err
			}
		}
		return p.askToPay(ctx, b)
	}
	return p.applyImmediate(ctx, intent)
}

// askToPay tells the client their saved card didn't work. The booking stays
// pending until they pay with POST /bookings/{id}/payment, for
// PaymentTimeout like a new booking.
func (p *Payments) askToPay(ctx context.Context, b domain.Booking) error {
	if err := p.setDue(ctx, b.ID); err != nil {
		return err
	}
	p.log.Info("saved card declined", "booking_id", b.ID)
	p.events.BookingStatus(b, p.clock.now())
	p.push.Notify(b.ClientID, domain.Notification{
		Title: "Payment needed",
		Body:  "We couldn't charge your card for booking " + b.Code + ". Open the app to pay.",
		Data:  map[string]string{"type": "booking.status", "booking_id": b.ID.String(), "status": string(b.Status)},
	})
	return nil
}

func (p *Payments) setDue(ctx context.Context, bookingID uuid.UUID) error {
	due := p.clock.now().Add(PaymentTimeout)
	return p.store.SetPaymentDue(ctx, bookingID, &due)
}

func (p *Payments) chargeRequest(ctx context.Context, b domain.Booking) (domain.ChargeRequest, error) {
	customer, err := p.customer(ctx, b.ClientID)
	if err != nil {
		return domain.ChargeRequest{}, err
	}
	return p.request(ctx, b, customer)
}

func (p *Payments) request(ctx context.Context, b domain.Booking, customer string) (domain.ChargeRequest, error) {
	n, err := p.store.CountPayments(ctx, b.ID)
	if err != nil {
		return domain.ChargeRequest{}, err
	}
	return domain.ChargeRequest{
		Booking:        b,
		Customer:       customer,
		SaveCard:       b.PlanID != nil,
		IdempotencyKey: fmt.Sprintf("booking-%s-%d", b.ID, n+1),
	}, nil
}

// customer returns the user's customer with the provider, creating it the
// first time.
func (p *Payments) customer(ctx context.Context, userID uuid.UUID) (string, error) {
	ref, err := p.store.PaymentCustomer(ctx, userID, p.provider.Name())
	if !errors.Is(err, domain.ErrNotFound) {
		return ref, err
	}
	user, err := p.store.GetUser(ctx, userID)
	if err != nil {
		return "", err
	}
	if ref, err = p.provider.CreateCustomer(ctx, user); err != nil {
		return "", fmt.Errorf("create payment customer: %w", err)
	}
	return p.store.SavePaymentCustomer(ctx, userID, p.provider.Name(), ref)
}

func (p *Payments) record(ctx context.Context, b domain.Booking, kind domain.PaymentKind, ref string) error {
	return p.store.CreatePayment(ctx, domain.Payment{
		BookingID: b.ID,
		Provider:  p.provider.Name(),
		Kind:      kind,
		Ref:       ref,
		Amount:    b.Total,
		Status:    domain.PaymentRequiresAction,
	})
}

// applyImmediate handles a provider that finished without the client (the
// mock, or an off-session charge) as if its webhook had arrived.
func (p *Payments) applyImmediate(ctx context.Context, intent domain.PaymentIntent) error {
	switch intent.Status {
	case domain.PaymentAuthorized:
		return p.apply(ctx, domain.PaymentEvent{Kind: domain.PaymentEventAuthorized, Ref: intent.Ref})
	case domain.PaymentSaved:
		return p.apply(ctx, domain.PaymentEvent{Kind: domain.PaymentEventSaved, Ref: intent.Ref})
	}
	return nil
}

func (p *Payments) release(ctx context.Context, pay domain.Payment) error {
	if err := p.store.SetPaymentStatus(ctx, pay.ID, domain.PaymentCanceled); err != nil {
		return err
	}
	if err := p.provider.Refund(ctx, pay.Ref); err != nil {
		return fmt.Errorf("release %s: %w", pay.Ref, err)
	}
	return nil
}

// HandleWebhook verifies and applies a provider webhook. Repeated events
// are ignored.
func (p *Payments) HandleWebhook(ctx context.Context, payload []byte, signature string) error {
	ev, err := p.provider.ParseWebhook(payload, signature)
	if err != nil {
		p.log.Warn("rejected payment webhook", "err", err)
		return domain.NewError(domain.CodeInvalidRequest, "Invalid webhook signature or payload.")
	}
	return p.apply(ctx, ev)
}

func (p *Payments) apply(ctx context.Context, ev domain.PaymentEvent) error {
	res, err := p.store.ApplyPaymentEvent(ctx, p.provider.Name(), ev)
	if err != nil || res.Booking == nil {
		return err
	}
	b := *res.Booking
	p.events.BookingStatus(b, p.clock.now())
	switch b.Status {
	case domain.StatusConfirmed:
		if err := p.dispatch.Dispatch(ctx, b.ID); err != nil {
			// The scheduler retries dispatch, so the payment still counts.
			p.log.Error("dispatch confirmed booking", "booking_id", b.ID, "err", err)
		}
	case domain.StatusCancelled:
		p.cancelledByProvider(b, res.Withdrawn)
	}
	return nil
}

func (p *Payments) cancelledByProvider(b domain.Booking, withdrawn []uuid.UUID) {
	for _, cleanerID := range withdrawn {
		p.events.OfferGone(cleanerID, b.ID)
	}
	data := map[string]string{"type": "booking.status", "booking_id": b.ID.String()}
	p.push.Notify(b.ClientID, domain.Notification{
		Title: "Booking cancelled",
		Body:  "The payment for booking " + b.Code + " was cancelled, so the booking was too.",
		Data:  data,
	})
	if b.CleanerID != nil {
		p.events.BookingAccessRevoked(b.ID, *b.CleanerID)
		p.push.Notify(*b.CleanerID, domain.Notification{
			Title: "Job cancelled",
			Body:  "Booking " + b.Code + " was cancelled.",
			Data:  data,
		})
	}
}

// Capture charges the held money. Called when the clean is completed.
func (p *Payments) Capture(ctx context.Context, bookingID uuid.UUID) error {
	pay, err := p.store.PaymentForBooking(ctx, bookingID)
	if err != nil {
		return err
	}
	if pay.Status != domain.PaymentAuthorized {
		return nil
	}
	if err := p.provider.Capture(ctx, pay.Ref); err != nil {
		return fmt.Errorf("capture %s: %w", pay.Ref, err)
	}
	return p.store.SetPaymentStatus(ctx, pay.ID, domain.PaymentCaptured)
}

// Settle runs after a cancellation: refund gives the money back, otherwise
// the held amount is charged as a late cancellation fee. It reports whether
// the client got their money back.
func (p *Payments) Settle(ctx context.Context, bookingID uuid.UUID, refund bool) (bool, error) {
	pay, err := p.store.PaymentForBooking(ctx, bookingID)
	if errors.Is(err, domain.ErrNotFound) {
		return true, nil
	}
	if err != nil {
		return false, err
	}

	switch {
	case pay.Kind == domain.PaymentKindSetup:
		// Nothing was held. A saved card stays saved for the client's other visits.
		if pay.Status == domain.PaymentRequiresAction || pay.Status == domain.PaymentFailed {
			return true, p.store.SetPaymentStatus(ctx, pay.ID, domain.PaymentCanceled)
		}
		return true, nil
	case pay.Status == domain.PaymentRequiresAction || pay.Status == domain.PaymentFailed:
		// Nothing was authorised yet; release the intent so it can't be paid later.
		return true, p.release(ctx, pay)
	case !refund && pay.Status == domain.PaymentAuthorized:
		if err := p.provider.Capture(ctx, pay.Ref); err != nil {
			return false, fmt.Errorf("capture late cancellation %s: %w", pay.Ref, err)
		}
		return false, p.store.SetPaymentStatus(ctx, pay.ID, domain.PaymentCaptured)
	case refund && (pay.Status == domain.PaymentAuthorized || pay.Status == domain.PaymentCaptured):
		if err := p.provider.Refund(ctx, pay.Ref); err != nil {
			return false, fmt.Errorf("refund %s: %w", pay.Ref, err)
		}
		return true, p.store.SetPaymentStatus(ctx, pay.ID, domain.PaymentRefunded)
	}
	return pay.Status == domain.PaymentRefunded || pay.Status == domain.PaymentCanceled, nil
}
