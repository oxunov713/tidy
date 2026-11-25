package domain

import (
	"fmt"

	"github.com/google/uuid"
)

// Service is a type of clean from the catalogue. Prices are in pence;
// BasePrice and BaseMinutes cover one bedroom and one bathroom.
type Service struct {
	ID             uuid.UUID `json:"id"`
	Slug           string    `json:"slug"`
	Title          string    `json:"title"`
	BasePrice      int       `json:"base_price"`
	PerBedroom     int       `json:"per_bedroom"`
	PerBathroom    int       `json:"per_bathroom"`
	BaseMinutes    int       `json:"base_minutes"`
	MinutesPerRoom int       `json:"minutes_per_room"`
	IsActive       bool      `json:"is_active"`
	SortOrder      int       `json:"sort_order"`
}

// Limits for catalogue prices (pence) and durations (minutes). They also
// keep every booking total far inside the database's int range.
const (
	MaxServiceTitle = 80
	MaxPrice        = 1_000_000
	MaxMinutes      = 24 * 60
)

func (s Service) Validate() error {
	fe := FieldErrors{}
	fe.CheckLength(s.Title, true, MaxServiceTitle, "title")
	price := fmt.Sprintf("must be between 1 and %d pence", MaxPrice)
	fe.Check(s.BasePrice >= 1 && s.BasePrice <= MaxPrice, "base_price", price)
	fe.Check(s.PerBedroom >= 1 && s.PerBedroom <= MaxPrice, "per_bedroom", price)
	fe.Check(s.PerBathroom >= 1 && s.PerBathroom <= MaxPrice, "per_bathroom", price)
	minutes := fmt.Sprintf("must be between 1 and %d minutes", MaxMinutes)
	fe.Check(s.BaseMinutes >= 1 && s.BaseMinutes <= MaxMinutes, "base_minutes", minutes)
	fe.Check(s.MinutesPerRoom >= 1 && s.MinutesPerRoom <= MaxMinutes, "minutes_per_room", minutes)
	return fe.Err()
}

type Extra struct {
	ID      uuid.UUID `json:"id"`
	Slug    string    `json:"slug"`
	Title   string    `json:"title"`
	Price   int       `json:"price"`
	Minutes int       `json:"minutes"`
}

type Frequency string

const (
	FrequencyOnce        Frequency = "once"
	FrequencyWeekly      Frequency = "weekly"
	FrequencyFortnightly Frequency = "fortnightly"
)

func (f Frequency) Valid() bool {
	switch f {
	case FrequencyOnce, FrequencyWeekly, FrequencyFortnightly:
		return true
	}
	return false
}

// DiscountPercent is the reward for booking a regular clean.
func (f Frequency) DiscountPercent() int {
	switch f {
	case FrequencyWeekly:
		return 15
	case FrequencyFortnightly:
		return 10
	}
	return 0
}

// IntervalDays is the gap between two visits of a recurring plan.
func (f Frequency) IntervalDays() int {
	switch f {
	case FrequencyWeekly:
		return 7
	case FrequencyFortnightly:
		return 14
	}
	return 0
}

func (f Frequency) label() string {
	switch f {
	case FrequencyWeekly:
		return "Weekly"
	case FrequencyFortnightly:
		return "Fortnightly"
	}
	return ""
}

const (
	MinRooms = 1
	MaxRooms = 10

	// CleanerSharePercent is the part of the booking total paid out to the
	// cleaner. Tips go to the cleaner in full.
	CleanerSharePercent = 75
)

type QuoteInput struct {
	Service   Service
	Bedrooms  int
	Bathrooms int
	Extras    []Extra
	Frequency Frequency
}

type QuoteLine struct {
	Label  string `json:"label"`
	Amount int    `json:"amount"`
}

type Quote struct {
	Subtotal int         `json:"subtotal"`
	Discount int         `json:"discount"`
	Total    int         `json:"total"`
	Minutes  int         `json:"minutes"`
	Lines    []QuoteLine `json:"lines"`
}

func ValidateRooms(fe FieldErrors, bedrooms, bathrooms int) {
	msg := fmt.Sprintf("must be between %d and %d", MinRooms, MaxRooms)
	fe.Check(bedrooms >= MinRooms && bedrooms <= MaxRooms, "bedrooms", msg)
	fe.Check(bathrooms >= MinRooms && bathrooms <= MaxRooms, "bathrooms", msg)
}

// Price is the only place where a booking price is calculated. The apps
// show what this returns and never compute prices themselves.
func Price(in QuoteInput) (Quote, error) {
	fe := FieldErrors{}
	ValidateRooms(fe, in.Bedrooms, in.Bathrooms)
	fe.Check(in.Frequency.Valid(), "frequency", "must be once, weekly or fortnightly")
	fe.Check(in.Service.IsActive, "service_id", "is not available")
	// Rows written before the limits existed could still overflow below.
	fe.Check(in.Service.BasePrice <= MaxPrice && in.Service.PerBedroom <= MaxPrice &&
		in.Service.PerBathroom <= MaxPrice, "service_id", "has an invalid price")
	if err := fe.Err(); err != nil {
		return Quote{}, err
	}

	s := in.Service
	extraBedrooms, extraBathrooms := in.Bedrooms-1, in.Bathrooms-1
	base := s.BasePrice + extraBedrooms*s.PerBedroom + extraBathrooms*s.PerBathroom

	q := Quote{
		Subtotal: base,
		Minutes:  s.BaseMinutes + (extraBedrooms+extraBathrooms)*s.MinutesPerRoom,
		Lines: []QuoteLine{{
			Label:  fmt.Sprintf("%s · %d bed, %d bath", s.Title, in.Bedrooms, in.Bathrooms),
			Amount: base,
		}},
	}
	for _, e := range in.Extras {
		q.Subtotal += e.Price
		q.Minutes += e.Minutes
		q.Lines = append(q.Lines, QuoteLine{Label: e.Title, Amount: e.Price})
	}

	if pct := in.Frequency.DiscountPercent(); pct > 0 {
		q.Discount = percentOf(q.Subtotal, pct)
		q.Lines = append(q.Lines, QuoteLine{
			Label:  fmt.Sprintf("%s discount (%d%%)", in.Frequency.label(), pct),
			Amount: -q.Discount,
		})
	}
	q.Total = q.Subtotal - q.Discount
	return q, nil
}

// CleanerPayout is what the cleaner earns for a booking, before tips.
func CleanerPayout(total int) int { return percentOf(total, CleanerSharePercent) }

// percentOf rounds half up, in whole pence.
func percentOf(amount, pct int) int { return (amount*pct + 50) / 100 }
