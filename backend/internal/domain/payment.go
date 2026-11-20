package domain

import "github.com/google/uuid"

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
)

type Payment struct {
	ID        uuid.UUID
	BookingID uuid.UUID
	Provider  string
	Ref       string
	Amount    int
	Status    PaymentStatus
}

// PaymentIntent is the provider's handle for money held for a booking.
type PaymentIntent struct {
	Ref          string
	ClientSecret string
	Status       PaymentStatus
}

type PaymentEventKind string

const (
	PaymentEventAuthorized PaymentEventKind = "authorized"
	PaymentEventFailed     PaymentEventKind = "failed"
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
