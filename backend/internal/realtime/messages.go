package realtime

import (
	"errors"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// inbound is any client -> server message; which fields are set depends on Type.
type inbound struct {
	Type      string    `json:"type"`
	Room      string    `json:"room"`
	BookingID uuid.UUID `json:"booking_id"`
	Lat       float64   `json:"lat"`
	Lng       float64   `json:"lng"`
}

type roomAck struct {
	Type string `json:"type"`
	Room string `json:"room"`
}

type bookingStatus struct {
	Type      string               `json:"type"`
	BookingID uuid.UUID            `json:"booking_id"`
	Status    domain.BookingStatus `json:"status"`
	At        time.Time            `json:"at"`
}

type cleanerLocation struct {
	Type       string    `json:"type"`
	BookingID  uuid.UUID `json:"booking_id"`
	Lat        float64   `json:"lat"`
	Lng        float64   `json:"lng"`
	ETAMinutes int       `json:"eta_minutes"`
}

type offerNew struct {
	Type      string         `json:"type"`
	Booking   domain.Booking `json:"booking"`
	ExpiresAt time.Time      `json:"expires_at"`
}

type offerGone struct {
	Type      string    `json:"type"`
	BookingID uuid.UUID `json:"booking_id"`
}

type messageNew struct {
	Type      string         `json:"type"`
	BookingID uuid.UUID      `json:"booking_id"`
	Message   domain.Message `json:"message"`
}

type errorReply struct {
	Type    string           `json:"type"`
	Code    domain.ErrorCode `json:"code"`
	Message string           `json:"message"`
}

func errorMessage(err error) errorReply {
	var de *domain.Error
	if errors.As(err, &de) {
		return errorReply{Type: "error", Code: de.Code, Message: de.Message}
	}
	return errorReply{Type: "error", Code: "internal", Message: "Something went wrong."}
}
