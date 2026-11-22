package domain

import (
	"strings"
	"time"
	"unicode/utf8"

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

var statusPhrases = map[BookingStatus]string{
	StatusPending:    "A pending booking",
	StatusConfirmed:  "A confirmed booking",
	StatusAssigned:   "An assigned booking",
	StatusOnTheWay:   "A booking whose cleaner is on the way",
	StatusInProgress: "A booking in progress",
	StatusCompleted:  "A completed booking",
	StatusCancelled:  "A cancelled booking",
}

// Phrase names a booking in this status at the start of a sentence, e.g.
// "A completed booking", for error messages.
func (s BookingStatus) Phrase() string {
	if p, ok := statusPhrases[s]; ok {
		return p
	}
	return "This booking"
}

// CanBeReassigned: an admin can only swap the cleaner before they set off.
func (s BookingStatus) CanBeReassigned() bool {
	return s == StatusConfirmed || s == StatusAssigned
}

// IsFinal reports whether nothing can happen to the booking any more.
func (s BookingStatus) IsFinal() bool { return len(transitions[s]) == 0 }

// EarliestDeparture is how long before the start a cleaner can set off.
const EarliestDeparture = 3 * time.Hour

// ChatOpenAfterCompleted is how long client and cleaner can still write
// after the clean, e.g. about a forgotten key.
const ChatOpenAfterCompleted = 24 * time.Hour

// FreeCancellationWindow: cancelling later than this before the start is
// charged in full.
const FreeCancellationWindow = 24 * time.Hour

type Booking struct {
	ID           uuid.UUID  `json:"id"`
	Code         string     `json:"code"`
	ClientID     uuid.UUID  `json:"client_id"`
	CleanerID    *uuid.UUID `json:"cleaner_id"`
	ServiceID    uuid.UUID  `json:"service_id"`
	ServiceTitle string     `json:"service_title"`
	AddressID    uuid.UUID  `json:"address_id"`
	// RequestedCleanerID is set when the client asked for a cleaner by name.
	RequestedCleanerID *uuid.UUID     `json:"requested_cleaner_id"`
	PlanID             *uuid.UUID     `json:"plan_id"`
	Bedrooms           int            `json:"bedrooms"`
	Bathrooms          int            `json:"bathrooms"`
	Frequency          Frequency      `json:"frequency"`
	Start              time.Time      `json:"start"`
	End                time.Time      `json:"end"`
	Status             BookingStatus  `json:"status"`
	Subtotal           int            `json:"subtotal"`
	Discount           int            `json:"discount"`
	Total              int            `json:"total"`
	CleanerPayout      int            `json:"cleaner_payout"`
	Extras             []BookingExtra `json:"extras"`
	CreatedAt          time.Time      `json:"created_at"`
	UpdatedAt          time.Time      `json:"updated_at"`
}

// IsParticipant reports whether the user is the client or the assigned cleaner.
func (b Booking) IsParticipant(userID uuid.UUID) bool {
	return b.ClientID == userID || (b.CleanerID != nil && *b.CleanerID == userID)
}

// ChatClosed explains why nobody can write in the booking's chat any more,
// or returns nil.
func (b Booking) ChatClosed(now time.Time) error {
	switch {
	case b.Status == StatusCancelled:
		return InvalidTransition("The chat is closed because the booking was cancelled.")
	case b.Status == StatusCompleted && now.Sub(b.UpdatedAt) > ChatOpenAfterCompleted:
		// A completed booking never changes again, so UpdatedAt is when it was completed.
		return InvalidTransition("The chat closed 24 hours after the clean.")
	}
	return nil
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
	if n := utf8.RuneCountInString(body); n == 0 || n > MaxMessageLength {
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

const (
	MaxReviewComment = 1000
	MaxReviewTags    = 10
	MaxTagLength     = 40
	MaxTip           = 100_00
)

func (r Review) Validate() error {
	fe := FieldErrors{}
	fe.Check(r.Rating >= 1 && r.Rating <= 5, "rating", "must be 1 to 5")
	fe.Check(len(r.Tags) <= MaxReviewTags, "tags", "at most 10 tags")
	for _, tag := range r.Tags {
		fe.CheckLength(tag, true, MaxTagLength, "tags")
	}
	fe.CheckLength(r.Comment, false, MaxReviewComment, "comment")
	fe.Check(r.Tip >= 0 && r.Tip <= MaxTip, "tip", "must be between 0 and 10000 pence")
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

// Period is a half-open time range [Start, End).
type Period struct {
	Start time.Time
	End   time.Time
}

func (p Period) Overlaps(o Period) bool { return p.Start.Before(o.End) && o.Start.Before(p.End) }

// OfferRef names one offer that changed, e.g. after expiry.
type OfferRef struct {
	BookingID uuid.UUID
	CleanerID uuid.UUID
}
