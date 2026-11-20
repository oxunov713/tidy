package service

import (
	"context"
	"errors"
	"log/slog"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

const (
	// minLeadTime keeps the dispatcher enough time to find a cleaner.
	minLeadTime = 2 * time.Hour
	// maxBookingAhead limits how far ahead a single visit can be booked.
	maxBookingAhead = 60 * 24 * time.Hour

	slotStep      = 30 * time.Minute
	firstSlotAt   = domain.TimeOfDay(7 * 60)
	lastSlotAt    = domain.TimeOfDay(20 * 60)
	planLookahead = 7 * 24 * time.Hour
)

type BookingsStore interface {
	BookingStore
	UserStore
	CatalogueStore
}

type Bookings struct {
	store    BookingsStore
	matcher  *matcher
	payments *Payments
	events   Events
	push     *Pusher
	clock    Clock
	log      *slog.Logger
}

func NewBookings(store BookingsStore, cleaners CleanerStore, payments *Payments, events Events, push *Pusher, loc *time.Location, radiusKm float64, clock Clock, log *slog.Logger) *Bookings {
	return &Bookings{
		store:    store,
		matcher:  &matcher{store: cleaners, loc: loc, radiusKm: radiusKm},
		payments: payments,
		events:   events,
		push:     push,
		clock:    clock,
		log:      log,
	}
}

func (s *Bookings) loc() *time.Location { return s.matcher.loc }

// QuoteRequest is what the client picks in the booking flow.
type QuoteRequest struct {
	ServiceID uuid.UUID
	Bedrooms  int
	Bathrooms int
	ExtraIDs  []uuid.UUID
	Frequency domain.Frequency
}

func (s *Bookings) Quote(ctx context.Context, in QuoteRequest) (domain.Quote, error) {
	q, _, err := s.quote(ctx, in)
	return q, err
}

func (s *Bookings) quote(ctx context.Context, in QuoteRequest) (domain.Quote, []domain.Extra, error) {
	if in.Frequency == "" {
		in.Frequency = domain.FrequencyOnce
	}
	svc, err := s.store.GetService(ctx, in.ServiceID)
	if errors.Is(err, domain.ErrNotFound) {
		return domain.Quote{}, nil, domain.Invalid("service_id", "unknown service")
	}
	if err != nil {
		return domain.Quote{}, nil, err
	}
	extras, err := s.store.GetExtras(ctx, uniqueIDs(in.ExtraIDs))
	if err != nil {
		return domain.Quote{}, nil, err
	}
	q, err := domain.Price(domain.QuoteInput{
		Service: svc, Bedrooms: in.Bedrooms, Bathrooms: in.Bathrooms,
		Extras: extras, Frequency: in.Frequency,
	})
	return q, extras, err
}

type SlotsRequest struct {
	QuoteRequest
	Date      string
	AddressID uuid.UUID
	CleanerID *uuid.UUID
}

type Slot struct {
	Start     time.Time `json:"start"`
	Available bool      `json:"available"`
}

type SlotDay struct {
	Date  string `json:"date"`
	Slots []Slot `json:"slots"`
}

// Slots lists start times on a day, marking those where at least one
// approved cleaner near the address is free for the whole visit.
func (s *Bookings) Slots(ctx context.Context, p Principal, in SlotsRequest) (SlotDay, error) {
	day, err := time.ParseInLocation(time.DateOnly, in.Date, s.loc())
	if err != nil {
		return SlotDay{}, domain.Invalid("date", "must be YYYY-MM-DD")
	}
	q, err := s.Quote(ctx, in.QuoteRequest)
	if err != nil {
		return SlotDay{}, err
	}
	addr, err := s.ownAddress(ctx, p, in.AddressID)
	if err != nil {
		return SlotDay{}, err
	}
	cands, err := s.matcher.candidates(ctx, matchQuery{lat: addr.Lat, lng: addr.Lng, day: day, only: in.CleanerID})
	if err != nil {
		return SlotDay{}, err
	}

	earliest := s.clock.now().Add(minLeadTime)
	length := time.Duration(q.Minutes) * time.Minute
	out := SlotDay{Date: in.Date, Slots: []Slot{}}
	for start := firstSlotAt.On(day, s.loc()); !start.After(lastSlotAt.On(day, s.loc())); start = start.Add(slotStep) {
		visit := domain.Period{Start: start, End: start.Add(length)}
		out.Slots = append(out.Slots, Slot{
			Start:     start.UTC(),
			Available: !start.Before(earliest) && anyFree(cands, visit, s.loc()),
		})
	}
	return out, nil
}

type CreateBookingRequest struct {
	QuoteRequest
	AddressID uuid.UUID
	Start     time.Time
	CleanerID *uuid.UUID
}

type CreatedBooking struct {
	Booking      domain.Booking
	ClientSecret string
}

// Create stores the booking in pending and starts the payment. The booking
// is confirmed when the payment is authorised.
func (s *Bookings) Create(ctx context.Context, p Principal, in CreateBookingRequest) (CreatedBooking, error) {
	if in.Frequency == "" {
		in.Frequency = domain.FrequencyOnce
	}
	q, extras, err := s.quote(ctx, in.QuoteRequest)
	if err != nil {
		return CreatedBooking{}, err
	}
	addr, err := s.ownAddress(ctx, p, in.AddressID)
	if err != nil {
		return CreatedBooking{}, err
	}

	now := s.clock.now()
	start := in.Start.UTC().Truncate(time.Minute)
	fe := domain.FieldErrors{}
	fe.Check(!start.Before(now.Add(minLeadTime)), "start", "must be at least 2 hours from now")
	fe.Check(start.Before(now.Add(maxBookingAhead)), "start", "must be within 60 days")
	if err := fe.Err(); err != nil {
		return CreatedBooking{}, err
	}
	visit := domain.Period{Start: start, End: start.Add(time.Duration(q.Minutes) * time.Minute)}

	cands, err := s.matcher.candidates(ctx, matchQuery{lat: addr.Lat, lng: addr.Lng, day: start, only: in.CleanerID})
	if err != nil {
		return CreatedBooking{}, err
	}
	if !anyFree(cands, visit, s.loc()) {
		return CreatedBooking{}, domain.ErrSlotTaken
	}

	nb := domain.NewBooking{
		ClientID:           p.UserID,
		ServiceID:          in.ServiceID,
		AddressID:          addr.ID,
		RequestedCleanerID: in.CleanerID,
		Bedrooms:           in.Bedrooms,
		Bathrooms:          in.Bathrooms,
		Frequency:          in.Frequency,
		Start:              visit.Start,
		End:                visit.End,
		Quote:              q,
		Extras:             extras,
	}
	if days := in.Frequency.IntervalDays(); days > 0 {
		local := start.In(s.loc())
		nb.Plan = &domain.NewPlan{
			Frequency: in.Frequency,
			NextRunOn: dateOf(local).AddDate(0, 0, days),
			Template: domain.PlanTemplate{
				ServiceID: in.ServiceID, AddressID: addr.ID,
				Bedrooms: in.Bedrooms, Bathrooms: in.Bathrooms,
				ExtraIDs:  uniqueIDs(in.ExtraIDs),
				StartTime: domain.TimeOfDay(local.Hour()*60 + local.Minute()),
				CleanerID: in.CleanerID,
			},
		}
	}

	b, err := s.store.CreateBooking(ctx, nb)
	if err != nil {
		return CreatedBooking{}, err
	}
	secret, err := s.payments.Start(ctx, b)
	if err != nil {
		return CreatedBooking{}, err
	}
	// The payment may have confirmed the booking already.
	b, err = s.store.GetBooking(ctx, b.ID)
	if err != nil {
		return CreatedBooking{}, err
	}
	return CreatedBooking{Booking: b, ClientSecret: secret}, nil
}

func (s *Bookings) List(ctx context.Context, p Principal, upcoming bool, cursor string, limit int) (Page[domain.Booking], error) {
	items, next, err := s.store.ListBookings(ctx, ListBookingsFilter{
		ClientID: &p.UserID,
		Upcoming: &upcoming,
		Now:      s.clock.now(),
		Cursor:   cursor,
		Limit:    pageSize(limit),
	})
	return Page[domain.Booking]{Items: items, NextCursor: next}, err
}

// CleanerCard is what the client sees about their cleaner.
type CleanerCard struct {
	ID          uuid.UUID `json:"id"`
	FullName    string    `json:"full_name"`
	AvatarURL   *string   `json:"avatar_url"`
	Rating      float64   `json:"rating"`
	RatingCount int       `json:"rating_count"`
}

type BookingDetails struct {
	domain.Booking
	Address      domain.Address        `json:"address"`
	Cleaner      *CleanerCard          `json:"cleaner"`
	LastLocation *domain.Location      `json:"last_location"`
	Events       []domain.BookingEvent `json:"events"`
	Review       *domain.Review        `json:"review"`
}

func (s *Bookings) Get(ctx context.Context, p Principal, id uuid.UUID) (BookingDetails, error) {
	b, err := s.accessible(ctx, p, id)
	if err != nil {
		return BookingDetails{}, err
	}
	d := BookingDetails{Booking: b}
	if d.Address, err = s.store.GetAddress(ctx, b.AddressID); err != nil {
		return BookingDetails{}, err
	}
	if b.CleanerID != nil {
		user, err := s.store.GetUser(ctx, *b.CleanerID)
		if err != nil {
			return BookingDetails{}, err
		}
		c, err := s.store.GetCleaner(ctx, *b.CleanerID)
		if err != nil {
			return BookingDetails{}, err
		}
		d.Cleaner = &CleanerCard{ID: user.ID, FullName: user.FullName, AvatarURL: user.AvatarURL, Rating: c.Rating, RatingCount: c.RatingCount}
	}
	if d.LastLocation, err = s.store.LastLocation(ctx, b.ID); err != nil {
		return BookingDetails{}, err
	}
	if d.Events, err = s.store.BookingEvents(ctx, b.ID); err != nil {
		return BookingDetails{}, err
	}
	if d.Review, err = s.store.GetReview(ctx, b.ID); err != nil {
		return BookingDetails{}, err
	}
	return d, nil
}

type Cancellation struct {
	Booking   domain.Booking `json:"booking"`
	Refunded  bool           `json:"refunded"`
	PlanEnded bool           `json:"plan_ended"`
}

// CancelScope says whether a cancellation also ends the recurring plan.
type CancelScope string

const (
	CancelVisit  CancelScope = "visit"
	CancelSeries CancelScope = "series"
)

// Cancel is free until FreeCancellationWindow before the start; later the
// held payment is charged. With CancelSeries the plan ends too.
func (s *Bookings) Cancel(ctx context.Context, p Principal, id uuid.UUID, scope CancelScope) (Cancellation, error) {
	if scope == "" {
		scope = CancelVisit
	}
	if scope != CancelVisit && scope != CancelSeries {
		return Cancellation{}, domain.Invalid("scope", "must be visit or series")
	}
	b, err := s.store.GetBooking(ctx, id)
	if err != nil {
		return Cancellation{}, err
	}
	if b.ClientID != p.UserID {
		return Cancellation{}, domain.Forbidden("This isn't your booking.")
	}
	c, err := s.cancel(ctx, b, p.UserID, b.CancellationIsFree(s.clock.now()))
	if err != nil {
		return Cancellation{}, err
	}
	if scope == CancelSeries && b.PlanID != nil {
		if c.PlanEnded, err = s.endPlan(ctx, *b.PlanID, &p.UserID); err != nil {
			return Cancellation{}, err
		}
	}
	return c, nil
}

// CancelByAdmin always refunds in full.
func (s *Bookings) CancelByAdmin(ctx context.Context, p Principal, id uuid.UUID) (Cancellation, error) {
	b, err := s.store.GetBooking(ctx, id)
	if err != nil {
		return Cancellation{}, err
	}
	return s.cancel(ctx, b, p.UserID, true)
}

func (s *Bookings) cancel(ctx context.Context, b domain.Booking, actor uuid.UUID, refund bool) (Cancellation, error) {
	if !b.Status.CanTransitionTo(domain.StatusCancelled) {
		return Cancellation{}, domain.InvalidTransition("This booking can't be cancelled any more.")
	}
	b, withdrawn, err := s.store.CancelBooking(ctx, b.ID, b.Status, &actor)
	if err != nil {
		return Cancellation{}, err
	}
	refunded := s.afterCancel(ctx, CancelledBooking{Booking: b, Withdrawn: withdrawn}, refund)
	return Cancellation{Booking: b, Refunded: refunded}, nil
}

// afterCancel settles the payment and tells everyone involved. It reports
// whether the client got their money back.
func (s *Bookings) afterCancel(ctx context.Context, c CancelledBooking, refund bool) bool {
	b := c.Booking
	refunded, err := s.payments.Settle(ctx, b.ID, refund)
	if err != nil {
		// The booking is cancelled either way; a failed refund is fixed by hand.
		s.log.Error("settle payment after cancel", "booking_id", b.ID, "err", err)
	}
	for _, cleanerID := range c.Withdrawn {
		s.events.OfferGone(cleanerID, b.ID)
	}
	s.events.BookingStatus(b, s.clock.now())
	if b.CleanerID != nil {
		s.events.BookingAccessRevoked(b.ID, *b.CleanerID)
		s.push.Notify(*b.CleanerID, domain.Notification{
			Title: "Job cancelled",
			Body:  "Booking " + b.Code + " was cancelled.",
			Data:  map[string]string{"type": "booking.status", "booking_id": b.ID.String()},
		})
	}
	return refunded
}

type ReviewRequest struct {
	Rating  int
	Tags    []string
	Comment string
	Tip     int
}

func (s *Bookings) Review(ctx context.Context, p Principal, id uuid.UUID, in ReviewRequest) (domain.Review, error) {
	b, err := s.store.GetBooking(ctx, id)
	if err != nil {
		return domain.Review{}, err
	}
	if b.ClientID != p.UserID {
		return domain.Review{}, domain.Forbidden("This isn't your booking.")
	}
	if b.Status != domain.StatusCompleted || b.CleanerID == nil {
		return domain.Review{}, domain.InvalidTransition("You can leave a review once the clean is completed.")
	}
	if in.Tags == nil {
		in.Tags = []string{}
	}
	r := domain.Review{
		BookingID: b.ID, CleanerID: *b.CleanerID,
		Rating: in.Rating, Tags: in.Tags, Comment: in.Comment, Tip: in.Tip,
	}
	if err := r.Validate(); err != nil {
		return domain.Review{}, err
	}
	return s.store.CreateReview(ctx, r)
}

func (s *Bookings) Messages(ctx context.Context, p Principal, id uuid.UUID) ([]domain.Message, error) {
	b, err := s.accessible(ctx, p, id)
	if err != nil {
		return nil, err
	}
	if err := s.requireApprovedCleaner(ctx, b, p.UserID); err != nil {
		return nil, err
	}
	return s.store.ListMessages(ctx, id)
}

// requireApprovedCleaner checks the cleaner's profile when the caller is
// the booking's cleaner.
func (s *Bookings) requireApprovedCleaner(ctx context.Context, b domain.Booking, userID uuid.UUID) error {
	if b.CleanerID == nil || *b.CleanerID != userID {
		return nil
	}
	return requireApproved(ctx, s.store, userID)
}

func (s *Bookings) PostMessage(ctx context.Context, p Principal, id uuid.UUID, body string) (domain.Message, error) {
	b, err := s.store.GetBooking(ctx, id)
	if err != nil {
		return domain.Message{}, err
	}
	if !b.IsParticipant(p.UserID) {
		return domain.Message{}, domain.Forbidden("Only the client and the cleaner can write here.")
	}
	if err := s.requireApprovedCleaner(ctx, b, p.UserID); err != nil {
		return domain.Message{}, err
	}
	body, err = domain.ValidateMessageBody(body)
	if err != nil {
		return domain.Message{}, err
	}
	m, err := s.store.CreateMessage(ctx, domain.Message{BookingID: id, SenderID: p.UserID, Body: body})
	if err != nil {
		return domain.Message{}, err
	}

	s.events.MessageNew(id, m)
	recipient := b.ClientID
	if recipient == p.UserID && b.CleanerID != nil {
		recipient = *b.CleanerID
	}
	if recipient != p.UserID {
		s.push.Notify(recipient, domain.Notification{
			Title: "New message",
			Body:  body,
			Data:  map[string]string{"type": "message.new", "booking_id": id.String()},
		})
	}
	return m, nil
}

// CanWatch tells the WebSocket hub who may be in booking:<id>: the client,
// and the assigned cleaner while approved and until the booking is cancelled.
func (s *Bookings) CanWatch(ctx context.Context, userID, bookingID uuid.UUID) (bool, error) {
	b, err := s.store.GetBooking(ctx, bookingID)
	if errors.Is(err, domain.ErrNotFound) {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	if b.ClientID == userID {
		return true, nil
	}
	if !b.IsParticipant(userID) || b.Status == domain.StatusCancelled {
		return false, nil
	}
	err = requireApproved(ctx, s.store, userID)
	if errors.Is(err, domain.ErrForbidden) {
		return false, nil
	}
	return err == nil, err
}

// RecordLocation stores the cleaner's latest position on the way to a job
// and returns a rough ETA in minutes.
func (s *Bookings) RecordLocation(ctx context.Context, cleanerID, bookingID uuid.UUID, lat, lng float64) (int, error) {
	if !domain.ValidCoordinates(lat, lng) {
		return 0, domain.Invalid("lat", "invalid coordinates")
	}
	b, err := s.store.GetBooking(ctx, bookingID)
	if err != nil {
		return 0, err
	}
	if b.CleanerID == nil || *b.CleanerID != cleanerID {
		return 0, domain.Forbidden("This isn't your job.")
	}
	if err := requireApproved(ctx, s.store, cleanerID); err != nil {
		return 0, err
	}
	if b.Status != domain.StatusAssigned && b.Status != domain.StatusOnTheWay {
		return 0, domain.InvalidTransition("Location is only shared on the way to a job.")
	}
	if err := s.store.SaveLocation(ctx, bookingID, cleanerID, lat, lng); err != nil {
		return 0, err
	}
	addr, err := s.store.GetAddress(ctx, b.AddressID)
	if err != nil {
		return 0, err
	}
	return domain.ETAMinutes(domain.DistanceKm(lat, lng, addr.Lat, addr.Lng)), nil
}

// accessible loads a booking the caller may see: its client, its cleaner or an admin.
func (s *Bookings) accessible(ctx context.Context, p Principal, id uuid.UUID) (domain.Booking, error) {
	b, err := s.store.GetBooking(ctx, id)
	if err != nil {
		return domain.Booking{}, err
	}
	if !p.IsAdmin() && !b.IsParticipant(p.UserID) {
		return domain.Booking{}, domain.Forbidden("This isn't your booking.")
	}
	return b, nil
}

func (s *Bookings) ownAddress(ctx context.Context, p Principal, id uuid.UUID) (domain.Address, error) {
	addr, err := s.store.GetAddress(ctx, id)
	if errors.Is(err, domain.ErrNotFound) || (err == nil && (addr.UserID != p.UserID || addr.Deleted)) {
		return domain.Address{}, domain.Invalid("address_id", "unknown address")
	}
	return addr, err
}

func dateOf(t time.Time) time.Time {
	y, m, d := t.Date()
	return time.Date(y, m, d, 0, 0, 0, 0, t.Location())
}

func uniqueIDs(ids []uuid.UUID) []uuid.UUID {
	seen := make(map[uuid.UUID]bool, len(ids))
	out := make([]uuid.UUID, 0, len(ids))
	for _, id := range ids {
		if !seen[id] {
			seen[id] = true
			out = append(out, id)
		}
	}
	return out
}
