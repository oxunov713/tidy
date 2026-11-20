package service

import (
	"context"
	"errors"
	"fmt"
	"log/slog"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// Payments keeps the money side of a booking in step with its status: hold
// on create, capture on completed, refund or release on cancel.
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

// Start creates the payment intent for a new booking and returns the client
// secret the app needs to confirm the card. If the provider authorises the
// payment straight away (mock), the booking is confirmed and dispatched.
func (p *Payments) Start(ctx context.Context, b domain.Booking) (string, error) {
	intent, err := p.provider.CreateIntent(ctx, b)
	if err != nil {
		// Without a payment the booking can never be confirmed.
		if _, cerr := p.store.SetBookingStatus(ctx, b.ID, domain.StatusPending, domain.StatusCancelled, nil); cerr != nil {
			p.log.Error("cancel booking after failed payment intent", "booking_id", b.ID, "err", cerr)
		}
		return "", fmt.Errorf("create payment intent: %w", err)
	}

	err = p.store.CreatePayment(ctx, domain.Payment{
		BookingID: b.ID,
		Provider:  p.provider.Name(),
		Ref:       intent.Ref,
		Amount:    b.Total,
		Status:    domain.PaymentRequiresAction,
	})
	if err != nil {
		return "", err
	}

	if intent.Status == domain.PaymentAuthorized {
		ev := domain.PaymentEvent{Kind: domain.PaymentEventAuthorized, Ref: intent.Ref}
		if err := p.apply(ctx, ev); err != nil {
			return "", err
		}
	}
	return intent.ClientSecret, nil
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
	case pay.Status == domain.PaymentRequiresAction:
		// Nothing was authorised yet; release the intent so it can't be paid later.
		if err := p.provider.Refund(ctx, pay.Ref); err != nil {
			return false, fmt.Errorf("release %s: %w", pay.Ref, err)
		}
		return true, p.store.SetPaymentStatus(ctx, pay.ID, domain.PaymentCanceled)
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
