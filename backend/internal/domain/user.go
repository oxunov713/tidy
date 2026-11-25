package domain

import (
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/google/uuid"
)

type Role string

const (
	RoleClient  Role = "client"
	RoleCleaner Role = "cleaner"
	RoleAdmin   Role = "admin"
)

func (r Role) Valid() bool {
	switch r {
	case RoleClient, RoleCleaner, RoleAdmin:
		return true
	}
	return false
}

type User struct {
	ID        uuid.UUID `json:"id"`
	Phone     string    `json:"phone"`
	FullName  string    `json:"full_name"`
	Email     *string   `json:"email"`
	Role      Role      `json:"role"`
	AvatarURL *string   `json:"avatar_url"`
	CreatedAt time.Time `json:"created_at"`
}

// NormalizePhone strips spaces and dashes and checks the E.164 shape
// (+ and 8 to 15 digits).
func NormalizePhone(raw string) (string, bool) {
	p := strings.NewReplacer(" ", "", "-", "", "(", "", ")", "").Replace(strings.TrimSpace(raw))
	if len(p) < 9 || len(p) > 16 || p[0] != '+' {
		return "", false
	}
	for _, c := range p[1:] {
		if c < '0' || c > '9' {
			return "", false
		}
	}
	return p, true
}

type CleanerStatus string

const (
	CleanerPending   CleanerStatus = "pending"
	CleanerApproved  CleanerStatus = "approved"
	CleanerSuspended CleanerStatus = "suspended"
)

func (s CleanerStatus) Valid() bool {
	switch s {
	case CleanerPending, CleanerApproved, CleanerSuspended:
		return true
	}
	return false
}

// CleanerSeenWithin: an online cleaner not heard from for longer (location,
// online toggle or WebSocket heartbeat) gets no offers.
const CleanerSeenWithin = 10 * time.Minute

type Cleaner struct {
	UserID      uuid.UUID     `json:"user_id"`
	Status      CleanerStatus `json:"status"`
	Bio         string        `json:"bio"`
	Rating      float64       `json:"rating"`
	RatingCount int           `json:"rating_count"`
	IsOnline    bool          `json:"is_online"`
	LastLat     *float64      `json:"last_lat"`
	LastLng     *float64      `json:"last_lng"`
	LastSeenAt  *time.Time    `json:"last_seen_at"`
}

// AverageRating rounds to one decimal place, the way the apps show it.
func AverageRating(sum, count int) float64 {
	if count == 0 {
		return 0
	}
	return math.Round(float64(sum)/float64(count)*10) / 10
}

// CleanerProfile is a cleaner together with their user record.
type CleanerProfile struct {
	User
	Cleaner Cleaner `json:"cleaner"`
}

// TimeOfDay is minutes since midnight in the service's local time zone.
type TimeOfDay int

func ParseTimeOfDay(s string) (TimeOfDay, error) {
	var h, m int
	if len(s) != 5 || s[2] != ':' {
		return 0, fmt.Errorf("time %q: want HH:MM", s)
	}
	if _, err := fmt.Sscanf(s, "%02d:%02d", &h, &m); err != nil || h > 23 || m > 59 {
		return 0, fmt.Errorf("time %q: want HH:MM", s)
	}
	return TimeOfDay(h*60 + m), nil
}

func (t TimeOfDay) String() string { return fmt.Sprintf("%02d:%02d", int(t)/60, int(t)%60) }

func (t TimeOfDay) MarshalText() ([]byte, error) { return []byte(t.String()), nil }

func (t *TimeOfDay) UnmarshalText(b []byte) error {
	v, err := ParseTimeOfDay(string(b))
	if err != nil {
		return err
	}
	*t = v
	return nil
}

// On returns the moment this time of day happens on the calendar date of
// date (as written in date's own location) in loc.
func (t TimeOfDay) On(date time.Time, loc *time.Location) time.Time {
	y, m, d := date.Date()
	return time.Date(y, m, d, int(t)/60, int(t)%60, 0, 0, loc)
}

// Availability is one weekly working window. Weekday 0 is Monday.
type Availability struct {
	Weekday   int       `json:"weekday"`
	StartTime TimeOfDay `json:"start_time"`
	EndTime   TimeOfDay `json:"end_time"`
}

// MondayIndex converts Go's Sunday-first weekday to the Monday-first index
// used in the database.
func MondayIndex(t time.Time) int { return (int(t.Weekday()) + 6) % 7 }

// Covers reports whether the visit [start, end) fits inside this window.
// The visit must not cross midnight.
func (a Availability) Covers(start, end time.Time, loc *time.Location) bool {
	start, end = start.In(loc), end.In(loc)
	if MondayIndex(start) != a.Weekday || !sameDay(start, end.Add(-time.Nanosecond)) {
		return false
	}
	return !start.Before(a.StartTime.On(start, loc)) && !end.After(a.EndTime.On(start, loc))
}

func sameDay(a, b time.Time) bool {
	ay, am, ad := a.Date()
	by, bm, bd := b.Date()
	return ay == by && am == bm && ad == bd
}

func ValidateAvailability(list []Availability) error {
	fe := FieldErrors{}
	seen := map[int]bool{}
	for i, a := range list {
		key := fmt.Sprintf("[%d]", i)
		fe.Check(a.Weekday >= 0 && a.Weekday <= 6, key+".weekday", "must be 0 (Monday) to 6 (Sunday)")
		fe.Check(!seen[a.Weekday], key+".weekday", "only one window per day")
		fe.Check(a.EndTime > a.StartTime, key+".end_time", "must be after start_time")
		seen[a.Weekday] = true
	}
	return fe.Err()
}

type Address struct {
	ID          uuid.UUID `json:"id"`
	UserID      uuid.UUID `json:"-"`
	Line1       string    `json:"line1"`
	Line2       string    `json:"line2"`
	City        string    `json:"city"`
	Postcode    string    `json:"postcode"`
	Lat         float64   `json:"lat"`
	Lng         float64   `json:"lng"`
	AccessNotes string    `json:"access_notes"`
	// Deleted addresses stay in the database because old bookings point to them.
	Deleted bool `json:"-"`
}

const (
	MaxAddressLine = 200
	MaxCity        = 80
	MaxPostcode    = 12
	MaxAccessNotes = 500
	MaxName        = 80
	MaxBio         = 500
	MaxEmail       = 254
)

// Validate expects fields already trimmed.
func (a Address) Validate() error {
	fe := FieldErrors{}
	fe.CheckLength(a.Line1, true, MaxAddressLine, "line1")
	fe.CheckLength(a.Line2, false, MaxAddressLine, "line2")
	fe.CheckLength(a.City, true, MaxCity, "city")
	fe.CheckLength(a.Postcode, true, MaxPostcode, "postcode")
	fe.CheckLength(a.AccessNotes, false, MaxAccessNotes, "access_notes")
	fe.Check(a.Lat >= -90 && a.Lat <= 90, "lat", "must be between -90 and 90")
	fe.Check(a.Lng >= -180 && a.Lng <= 180, "lng", "must be between -180 and 180")
	return fe.Err()
}

type DevicePlatform string

func (p DevicePlatform) Valid() bool {
	return p == "android" || p == "ios" || p == "web"
}
