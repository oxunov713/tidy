package domain

import (
	"errors"
	"time"

	"github.com/google/uuid"
)

type PaymentStatus string

const (
	PaymentRequiresAction PaymentStatus = "requires_action"
	PaymentAuthorized     PaymentStatus = "authorized"
	PaymentCaptured       PaymentStatus = "captured"
	PaymentRefunded       PaymentStatus = "refunded"
	PaymentFailed         PaymentStatus = "failed"
	// PaymentCanceled is an authorisation that was released before any
	// money moved.
	PaymentCanceled PaymentStatus = "canceled"
	// PaymentSaved is a card saved for later; nothing is held yet.
	PaymentSaved PaymentStatus = "saved"
)

// PaymentKind tells the app which Stripe sheet to open with the secret.
type PaymentKind string

const (
	// PaymentKindPayment holds the money now (manual-capture PaymentIntent).
	PaymentKindPayment PaymentKind = "payment"
	// PaymentKindSetup only saves the card (SetupIntent); the money is held
	// AuthorizeAhead before the visit.
	PaymentKindSetup PaymentKind = "setup"
)

const (
	// DirectPaymentWindow: a card hold lasts about a week, so only visits
	// this close are paid straight away. Later ones save the card.
	DirectPaymentWindow = 5 * 24 * time.Hour
	// AuthorizeAhead is when the saved card is charged (held) off-session.
	AuthorizeAhead = 48 * time.Hour
)

// PaymentKindFor picks how a new booking starting at start is paid.
func PaymentKindFor(start, now time.Time) PaymentKind {
	if start.Sub(now) <= DirectPaymentWindow {
		return PaymentKindPayment
	}
	return PaymentKindSetup
}

type Payment struct {
	ID        uuid.UUID
	BookingID uuid.UUID
	Provider  string
	Kind      PaymentKind
	Ref       string
	Amount    int
	Status    PaymentStatus
}

// PaymentIntent is the provider's handle for a payment or a card setup.
type PaymentIntent struct {
	Ref          string
	ClientSecret string
	Status       PaymentStatus
}

// ChargeRequest is what a provider needs to take money for one booking.
type ChargeRequest struct {
	Booking Booking
	// Customer is the provider's customer id; empty if the user has none.
	Customer string
	// SaveCard keeps the card on the customer for later visits of a plan.
	SaveCard bool
	// IdempotencyKey makes a retried call return the same intent.
	IdempotencyKey string
}

type PaymentEventKind string

const (
	PaymentEventAuthorized PaymentEventKind = "authorized"
	// PaymentEventFailed is a declined attempt. The client can try again
	// with the same intent, so the booking stays pending.
	PaymentEventFailed PaymentEventKind = "failed"
	// PaymentEventCanceled means the intent can never be paid any more.
	PaymentEventCanceled PaymentEventKind = "canceled"
	// PaymentEventSaved is a SetupIntent that saved the card.
	PaymentEventSaved PaymentEventKind = "saved"
	// PaymentEventIgnored is any provider event we don't act on.
	PaymentEventIgnored PaymentEventKind = "ignored"
)

// PaymentEvent is a verified webhook from the payment provider.
type PaymentEvent struct {
	ID   string
	Kind PaymentEventKind
	Ref  string
}

type Notification struct {
	Title string
	Body  string
	Data  map[string]string
}

// ErrDeviceTokenGone means the push provider no longer knows the device
// token, so it should be deleted.
var ErrDeviceTokenGone = errors.New("device token is no longer registered")
