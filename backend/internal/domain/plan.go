package domain

import (
	"errors"
	"time"

	"github.com/google/uuid"
)

// PlanTemplate is what a recurring plan repeats. It is stored as JSON.
type PlanTemplate struct {
	ServiceID uuid.UUID   `json:"service_id"`
	AddressID uuid.UUID   `json:"address_id"`
	Bedrooms  int         `json:"bedrooms"`
	Bathrooms int         `json:"bathrooms"`
	ExtraIDs  []uuid.UUID `json:"extra_ids"`
	StartTime TimeOfDay   `json:"start_time"`
	CleanerID *uuid.UUID  `json:"cleaner_id,omitempty"`
}

type Plan struct {
	ID        uuid.UUID
	ClientID  uuid.UUID
	Frequency Frequency
	Template  PlanTemplate
	// NextRunOn is the local date of the next visit the scheduler creates.
	NextRunOn time.Time
	IsActive  bool
}

// ErrPlanEnded means the plan was ended while a visit was being created.
var ErrPlanEnded = errors.New("plan has ended")

type NewPlan struct {
	Frequency Frequency
	Template  PlanTemplate
	NextRunOn time.Time
}

// PlanRun links a booking to its plan and moves the plan forward in the
// same transaction, so a crash can't create the same visit twice.
type PlanRun struct {
	PlanID    uuid.UUID
	NextRunOn time.Time
}
