package domain

import (
	"strings"
	"time"

	"github.com/google/uuid"
)

type BookingStatus string

const (
	StatusPending    BookingStatus = "pending"
	StatusConfirmed  BookingStatus = "confirmed"
	StatusAssigned   BookingStatus = "assigned"
	StatusOnTheWay   BookingStatus = "on_the_way"
	StatusInProgress BookingStatus = "in_progress"
	StatusCompleted  BookingStatus = "completed"
	StatusCancelled  BookingStatus = "cancelled"
)

// transitions is the booking lifecycle:
//
//	pending -> confirmed -> assigned -> on_the_way -> in_progress -> completed
//	pending, confirmed, assigned -> cancelled
var transitions = map[BookingStatus][]BookingStatus{
	StatusPending:    {StatusConfirmed, StatusCancelled},
	StatusConfirmed:  {StatusAssigned, StatusCancelled},
	StatusAssigned:   {StatusOnTheWay, StatusCancelled},
	StatusOnTheWay:   {StatusInProgress},
	StatusInProgress: {StatusCompleted},
}

func (s BookingStatus) Valid() bool {
	switch s {
	case StatusPending, StatusConfirmed, StatusAssigned, StatusOnTheWay,
		StatusInProgress, StatusCompleted, StatusCancelled:
		return true
	}
	return false
}

func (s BookingStatus) CanTransitionTo(next BookingStatus) bool {
	for _, allowed := range transitions[s] {
		if allowed == next {
			return true
		}
	}
	return false
}

// IsFinal reports whether nothing can happen to the booking any more.
func (s BookingStatus) IsFinal() bool { return len(transitions[s]) == 0 }

// FreeCancellationWindow: cancelling later than this before the start is
// charged in full.
const FreeCancellationWindow = 24 * time.Hour

type Booking struct {
	ID            uuid.UUID      `json:"id"`
	Code          string         `json:"code"`
	ClientID      uuid.UUID      `json:"client_id"`
	CleanerID     *uuid.UUID     `json:"cleaner_id"`
	ServiceID     uuid.UUID      `json:"service_id"`
	ServiceTitle  string         `json:"service_title"`
	AddressID     uuid.UUID      `json:"address_id"`
	PlanID        *uuid.UUID     `json:"plan_id"`
	Bedrooms      int            `json:"bedrooms"`
	Bathrooms     int            `json:"bathrooms"`
	Frequency     Frequency      `json:"frequency"`
	Start         time.Time      `json:"start"`
	End           time.Time      `json:"end"`
	Status        BookingStatus  `json:"status"`
	Subtotal      int            `json:"subtotal"`
	Discount      int            `json:"discount"`
	Total         int            `json:"total"`
	CleanerPayout int            `json:"cleaner_payout"`
	Extras        []BookingExtra `json:"extras"`
	CreatedAt     time.Time      `json:"created_at"`
	UpdatedAt     time.Time      `json:"updated_at"`
}

// IsParticipant reports whether the user is the client or the assigned cleaner.
func (b Booking) IsParticipant(userID uuid.UUID) bool {
	return b.ClientID == userID || (b.CleanerID != nil && *b.CleanerID == userID)
}

// CancellationIsFree reports whether a cancellation now gets a full refund.
func (b Booking) CancellationIsFree(now time.Time) bool {
	return b.Start.Sub(now) >= FreeCancellationWindow
}

type BookingExtra struct {
	ExtraID uuid.UUID `json:"id"`
	Title   string    `json:"title"`
	Price   int       `json:"price"`
}

// NewBooking is everything needed to store a booking in pending state.
type NewBooking struct {
	ClientID           uuid.UUID
	ServiceID          uuid.UUID
	AddressID          uuid.UUID
	RequestedCleanerID *uuid.UUID
	Bedrooms           int
	Bathrooms          int
	Frequency          Frequency
	Start              time.Time
	End                time.Time
	Quote              Quote
	Extras             []Extra
	// Plan is set for the first booking of a recurring series.
	Plan *NewPlan
	// FromPlan is set when the scheduler creates a booking from a plan.
	FromPlan *PlanRun
}

type BookingEvent struct {
	Status  BookingStatus `json:"status"`
	ActorID *uuid.UUID    `json:"actor_id"`
	At      time.Time     `json:"at"`
}

type Location struct {
	Lat float64   `json:"lat"`
	Lng float64   `json:"lng"`
	At  time.Time `json:"at"`
}

type Message struct {
	ID        int64     `json:"id"`
	BookingID uuid.UUID `json:"booking_id"`
	SenderID  uuid.UUID `json:"sender_id"`
	Body      string    `json:"body"`
	CreatedAt time.Time `json:"created_at"`
}

const MaxMessageLength = 2000

func ValidateMessageBody(body string) (string, error) {
	body = strings.TrimSpace(body)
	if body == "" || len(body) > MaxMessageLength {
		return "", Invalid("body", "must be 1 to 2000 characters")
	}
	return body, nil
}

type Review struct {
	BookingID uuid.UUID `json:"booking_id"`
	CleanerID uuid.UUID `json:"cleaner_id"`
	Rating    int       `json:"rating"`
	Tags      []string  `json:"tags"`
	Comment   string    `json:"comment"`
	Tip       int       `json:"tip"`
	CreatedAt time.Time `json:"created_at"`
}

func (r Review) Validate() error {
	fe := FieldErrors{}
	fe.Check(r.Rating >= 1 && r.Rating <= 5, "rating", "must be 1 to 5")
	fe.Check(len(r.Tags) <= 10, "tags", "at most 10 tags")
	fe.Check(len(r.Comment) <= 2000, "comment", "is too long")
	fe.Check(r.Tip >= 0 && r.Tip <= 100_00, "tip", "must be between 0 and 10000 pence")
	return fe.Err()
}

type OfferStatus string

const (
	OfferOpen      OfferStatus = "open"
	OfferAccepted  OfferStatus = "accepted"
	OfferDeclined  OfferStatus = "declined"
	OfferExpired   OfferStatus = "expired"
	OfferWithdrawn OfferStatus = "withdrawn"
)

// OfferTTL is how long a cleaner has to answer before the job goes to the
// next cleaner.
const OfferTTL = 60 * time.Second

type Offer struct {
	BookingID  uuid.UUID   `json:"booking_id"`
	CleanerID  uuid.UUID   `json:"cleaner_id"`
	Status     OfferStatus `json:"status"`
	DistanceKm float64     `json:"distance_km"`
	ExpiresAt  time.Time   `json:"expires_at"`
}

// OfferRef names one offer that changed, e.g. after expiry.
type OfferRef struct {
	BookingID uuid.UUID
	CleanerID uuid.UUID
}
