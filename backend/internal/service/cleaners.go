package service

import (
	"context"
	"errors"
	"log/slog"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

type CleanersStore interface {
	CleanerStore
	GetBooking(ctx context.Context, id uuid.UUID) (domain.Booking, error)
	ListCleanerJobs(ctx context.Context, cleanerID uuid.UUID, from, to time.Time) ([]domain.Booking, error)
	SetBookingStatus(ctx context.Context, id uuid.UUID, from, to domain.BookingStatus, actor *uuid.UUID) (domain.Booking, error)
	GetAddress(ctx context.Context, id uuid.UUID) (domain.Address, error)
	GetUsers(ctx context.Context, ids []uuid.UUID) (map[uuid.UUID]domain.User, error)
}

// Cleaners is everything the cleaner app does apart from offers.
type Cleaners struct {
	store    CleanersStore
	payments *Payments
	events   Events
	push     *Pusher
	loc      *time.Location
	clock    Clock
	log      *slog.Logger
}

func NewCleaners(store CleanersStore, payments *Payments, events Events, push *Pusher, loc *time.Location, clock Clock, log *slog.Logger) *Cleaners {
	return &Cleaners{store: store, payments: payments, events: events, push: push, loc: loc, clock: clock, log: log}
}

func (s *Cleaners) SetOnline(ctx context.Context, p Principal, online bool, lat, lng *float64) error {
	c, err := s.store.GetCleaner(ctx, p.UserID)
	if err != nil {
		return err
	}
	if online {
		if c.Status != domain.CleanerApproved {
			return domain.Forbidden("Your profile isn't approved yet.")
		}
		if lat == nil || lng == nil || !domain.ValidCoordinates(*lat, *lng) {
			return domain.Invalid("lat", "lat and lng are required to go online")
		}
	}
	return s.store.SetCleanerOnline(ctx, p.UserID, online, lat, lng, s.clock.now())
}

// Job is a booking as the cleaner sees it: with the address and client name.
type Job struct {
	domain.Booking
	Address    domain.Address `json:"address"`
	ClientName string         `json:"client_name"`
}

// Jobs lists the cleaner's bookings between from and to. Without a range it
// shows yesterday to two weeks ahead.
func (s *Cleaners) Jobs(ctx context.Context, p Principal, from, to *time.Time) ([]Job, error) {
	now := s.clock.now()
	f, t := now.AddDate(0, 0, -1), now.AddDate(0, 0, 14)
	if from != nil {
		f = *from
	}
	if to != nil {
		t = *to
	}
	if !t.After(f) || t.Sub(f) > 93*24*time.Hour {
		return nil, domain.Invalid("to", "must be after from and at most 93 days later")
	}

	bookings, err := s.store.ListCleanerJobs(ctx, p.UserID, f, t)
	if err != nil {
		return nil, err
	}
	clientIDs := make([]uuid.UUID, len(bookings))
	for i, b := range bookings {
		clientIDs[i] = b.ClientID
	}
	clients, err := s.store.GetUsers(ctx, clientIDs)
	if err != nil {
		return nil, err
	}

	jobs := make([]Job, 0, len(bookings))
	for _, b := range bookings {
		addr, err := s.store.GetAddress(ctx, b.AddressID)
		if err != nil {
			return nil, err
		}
		jobs = append(jobs, Job{Booking: b, Address: addr, ClientName: clients[b.ClientID].FullName})
	}
	return jobs, nil
}

var cleanerStatuses = map[domain.BookingStatus]string{
	domain.StatusOnTheWay:   "Your cleaner is on the way",
	domain.StatusInProgress: "Your clean has started",
	domain.StatusCompleted:  "Your clean is done",
}

// UpdateJobStatus moves a job along. Completing it captures the payment.
func (s *Cleaners) UpdateJobStatus(ctx context.Context, p Principal, bookingID uuid.UUID, status domain.BookingStatus) (domain.Booking, error) {
	title, ok := cleanerStatuses[status]
	if !ok {
		return domain.Booking{}, domain.Invalid("status", "must be on_the_way, in_progress or completed")
	}
	b, err := s.store.GetBooking(ctx, bookingID)
	if err != nil {
		return domain.Booking{}, err
	}
	if b.CleanerID == nil || *b.CleanerID != p.UserID {
		return domain.Booking{}, domain.Forbidden("This isn't your job.")
	}
	if err := requireApproved(ctx, s.store, p.UserID); err != nil {
		return domain.Booking{}, err
	}
	if !b.Status.CanTransitionTo(status) {
		return domain.Booking{}, domain.InvalidTransition("A job that is " + string(b.Status) + " can't become " + string(status) + ".")
	}
	if status == domain.StatusOnTheWay && s.clock.now().Before(b.Start.Add(-domain.EarliestDeparture)) {
		return domain.Booking{}, domain.InvalidTransition("You can set off at most 3 hours before the visit.")
	}
	b, err = s.store.SetBookingStatus(ctx, bookingID, b.Status, status, &p.UserID)
	if err != nil {
		return domain.Booking{}, err
	}

	if status == domain.StatusCompleted {
		if err := s.payments.Capture(ctx, b.ID); err != nil {
			// The clean happened; a failed capture is retried by hand, not by the cleaner.
			s.log.Error("capture payment", "booking_id", b.ID, "err", err)
		}
	}
	s.events.BookingStatus(b, s.clock.now())
	s.push.Notify(b.ClientID, domain.Notification{
		Title: title,
		Body:  "Booking " + b.Code,
		Data:  map[string]string{"type": "booking.status", "booking_id": b.ID.String(), "status": string(status)},
	})
	return b, nil
}

func (s *Cleaners) Availability(ctx context.Context, p Principal) ([]domain.Availability, error) {
	return s.store.GetAvailability(ctx, p.UserID)
}

func (s *Cleaners) SetAvailability(ctx context.Context, p Principal, list []domain.Availability) ([]domain.Availability, error) {
	if err := domain.ValidateAvailability(list); err != nil {
		return nil, err
	}
	if _, err := s.store.GetCleaner(ctx, p.UserID); err != nil {
		if errors.Is(err, domain.ErrNotFound) {
			return nil, domain.Forbidden("Only cleaners have working hours.")
		}
		return nil, err
	}
	if err := s.store.ReplaceAvailability(ctx, p.UserID, list); err != nil {
		return nil, err
	}
	return s.store.GetAvailability(ctx, p.UserID)
}

// EarningJob is one completed job with what the cleaner earned from it.
type EarningJob struct {
	BookingID    uuid.UUID `json:"booking_id"`
	Code         string    `json:"code"`
	ServiceTitle string    `json:"service_title"`
	Start        time.Time `json:"start"`
	Minutes      int       `json:"minutes"`
	Amount       int       `json:"amount"`
	Tip          int       `json:"tip"`
}

type EarningDay struct {
	Date   string `json:"date"`
	Amount int    `json:"amount"`
}

type Earnings struct {
	Period  string       `json:"period"`
	From    string       `json:"from"`
	To      string       `json:"to"`
	Total   int          `json:"total"`
	Tips    int          `json:"tips"`
	Jobs    int          `json:"jobs"`
	Minutes int          `json:"minutes"`
	Days    []EarningDay `json:"days"`
	Recent  []EarningJob `json:"recent"`
}

const recentJobs = 10

// Earnings sums completed jobs in the current week (Monday to Sunday) or
// month. Days are per local calendar day and include tips.
func (s *Cleaners) Earnings(ctx context.Context, p Principal, period string) (Earnings, error) {
	today := dateOf(s.clock.now().In(s.loc))
	var from, to time.Time
	switch period {
	case "", "week":
		period = "week"
		from = today.AddDate(0, 0, -domain.MondayIndex(today))
		to = from.AddDate(0, 0, 7)
	case "month":
		from = time.Date(today.Year(), today.Month(), 1, 0, 0, 0, 0, s.loc)
		to = from.AddDate(0, 1, 0)
	default:
		return Earnings{}, domain.Invalid("period", "must be week or month")
	}

	jobs, err := s.store.CompletedJobs(ctx, p.UserID, from, to)
	if err != nil {
		return Earnings{}, err
	}

	e := Earnings{
		Period: period,
		From:   from.Format(time.DateOnly),
		To:     to.AddDate(0, 0, -1).Format(time.DateOnly),
		Recent: []EarningJob{},
	}
	index := map[string]int{}
	for d := from; d.Before(to); d = d.AddDate(0, 0, 1) {
		index[d.Format(time.DateOnly)] = len(e.Days)
		e.Days = append(e.Days, EarningDay{Date: d.Format(time.DateOnly)})
	}
	for _, j := range jobs {
		e.Total += j.Amount
		e.Tips += j.Tip
		e.Jobs++
		e.Minutes += j.Minutes
		if i, ok := index[j.Start.In(s.loc).Format(time.DateOnly)]; ok {
			e.Days[i].Amount += j.Amount + j.Tip
		}
	}
	// CompletedJobs is newest first.
	e.Recent = append(e.Recent, jobs[:min(len(jobs), recentJobs)]...)
	return e, nil
}
