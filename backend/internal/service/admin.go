package service

import (
	"context"
	"errors"
	"strings"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

type AdminDeps interface {
	AdminStore
	BookingStore
	UserStore
}

type Admin struct {
	store    AdminDeps
	bookings *Bookings
	events   Events
	push     *Pusher
	loc      *time.Location
	clock    Clock
}

func NewAdmin(store AdminDeps, bookings *Bookings, events Events, push *Pusher, loc *time.Location, clock Clock) *Admin {
	return &Admin{store: store, bookings: bookings, events: events, push: push, loc: loc, clock: clock}
}

type Stats struct {
	Bookings         int `json:"bookings"`
	Revenue          int `json:"revenue"`
	CleanersOnline   int `json:"cleaners_online"`
	PendingApprovals int `json:"pending_approvals"`
}

// StatsToday counts bookings that start today (local time) and the revenue
// of those already completed.
func (a *Admin) StatsToday(ctx context.Context) (Stats, error) {
	today := dateOf(a.clock.now().In(a.loc))
	return a.store.StatsBetween(ctx, today, today.AddDate(0, 0, 1))
}

// AdminBooking adds the names the admin table shows.
type AdminBooking struct {
	domain.Booking
	ClientName  string `json:"client_name"`
	ClientPhone string `json:"client_phone"`
	CleanerName string `json:"cleaner_name"`
}

func (a *Admin) Bookings(ctx context.Context, status *domain.BookingStatus, query, cursor string, limit int) (Page[AdminBooking], error) {
	if status != nil && !status.Valid() {
		return Page[AdminBooking]{}, domain.Invalid("status", "unknown status")
	}
	items, next, err := a.store.ListBookings(ctx, ListBookingsFilter{
		Status: status,
		Query:  strings.TrimSpace(query),
		Now:    a.clock.now(),
		Cursor: cursor,
		Limit:  pageSize(limit),
	})
	if err != nil {
		return Page[AdminBooking]{}, err
	}

	var ids []uuid.UUID
	for _, b := range items {
		ids = append(ids, b.ClientID)
		if b.CleanerID != nil {
			ids = append(ids, *b.CleanerID)
		}
	}
	users, err := a.store.GetUsers(ctx, ids)
	if err != nil {
		return Page[AdminBooking]{}, err
	}
	page := Page[AdminBooking]{Items: make([]AdminBooking, 0, len(items)), NextCursor: next}
	for _, b := range items {
		row := AdminBooking{Booking: b, ClientName: users[b.ClientID].FullName, ClientPhone: users[b.ClientID].Phone}
		if b.CleanerID != nil {
			row.CleanerName = users[*b.CleanerID].FullName
		}
		page.Items = append(page.Items, row)
	}
	return page, nil
}

type BookingPatch struct {
	CleanerID *uuid.UUID
	Status    *domain.BookingStatus
}

// PatchBooking either reassigns the cleaner or cancels the booking.
func (a *Admin) PatchBooking(ctx context.Context, p Principal, id uuid.UUID, in BookingPatch) (domain.Booking, error) {
	switch {
	case in.CleanerID != nil && in.Status != nil:
		return domain.Booking{}, domain.Invalid("cleaner_id", "send either cleaner_id or status, not both")
	case in.Status != nil:
		if *in.Status != domain.StatusCancelled {
			return domain.Booking{}, domain.Invalid("status", "only cancelled can be set here")
		}
		c, err := a.bookings.CancelByAdmin(ctx, p, id)
		return c.Booking, err
	case in.CleanerID != nil:
		return a.reassign(ctx, p, id, *in.CleanerID)
	}
	return domain.Booking{}, domain.Invalid("cleaner_id", "send cleaner_id or status")
}

func (a *Admin) reassign(ctx context.Context, p Principal, id, cleanerID uuid.UUID) (domain.Booking, error) {
	c, err := a.store.GetCleaner(ctx, cleanerID)
	if errors.Is(err, domain.ErrNotFound) || (err == nil && c.Status != domain.CleanerApproved) {
		return domain.Booking{}, domain.Invalid("cleaner_id", "must be an approved cleaner")
	}
	if err != nil {
		return domain.Booking{}, err
	}
	before, err := a.store.GetBooking(ctx, id)
	if err != nil {
		return domain.Booking{}, err
	}
	b, withdrawn, err := a.store.AssignCleaner(ctx, id, cleanerID, &p.UserID)
	if err != nil {
		return domain.Booking{}, err
	}

	for _, other := range withdrawn {
		a.events.OfferGone(other, b.ID)
	}
	a.events.BookingStatus(b, a.clock.now())
	if before.CleanerID != nil && *before.CleanerID != cleanerID {
		a.push.Notify(*before.CleanerID, domain.Notification{
			Title: "Job reassigned",
			Body:  "Booking " + b.Code + " was given to another cleaner.",
			Data:  map[string]string{"type": "booking.status", "booking_id": b.ID.String()},
		})
	}
	a.push.Notify(cleanerID, domain.Notification{
		Title: "New job assigned",
		Body:  b.ServiceTitle + " · " + b.Start.In(a.loc).Format("Mon 2 Jan 15:04"),
		Data:  map[string]string{"type": "booking.status", "booking_id": b.ID.String()},
	})
	return b, nil
}

func (a *Admin) Cleaners(ctx context.Context, status *domain.CleanerStatus) ([]domain.CleanerProfile, error) {
	if status != nil && !status.Valid() {
		return nil, domain.Invalid("status", "must be pending, approved or suspended")
	}
	return a.store.ListCleanerProfiles(ctx, status)
}

func (a *Admin) SetCleanerStatus(ctx context.Context, id uuid.UUID, status domain.CleanerStatus) error {
	if err := a.store.SetCleanerStatus(ctx, id, status); err != nil {
		return err
	}
	msg := map[domain.CleanerStatus]string{
		domain.CleanerApproved:  "Your profile is approved. You can go online now.",
		domain.CleanerSuspended: "Your profile is suspended. Contact support for details.",
	}[status]
	if msg != "" {
		a.push.Notify(id, domain.Notification{Title: "Tidy", Body: msg, Data: map[string]string{"type": "cleaner.status"}})
	}
	return nil
}
