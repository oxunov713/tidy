package service

import (
	"context"
	"errors"
	"log/slog"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

type DispatchStore interface {
	OfferStore
	GetBooking(ctx context.Context, id uuid.UUID) (domain.Booking, error)
	GetAddress(ctx context.Context, id uuid.UUID) (domain.Address, error)
	GetCleaner(ctx context.Context, id uuid.UUID) (domain.Cleaner, error)
}

// Dispatcher offers confirmed bookings to the nearest free cleaner, one
// cleaner at a time. An unanswered offer expires and moves on.
type Dispatcher struct {
	store   DispatchStore
	matcher *matcher
	events  Events
	push    *Pusher
	clock   Clock
	log     *slog.Logger
}

func NewDispatcher(store DispatchStore, cleaners CleanerStore, events Events, push *Pusher, loc *time.Location, radiusKm float64, clock Clock, log *slog.Logger) *Dispatcher {
	return &Dispatcher{
		store:   store,
		matcher: &matcher{store: cleaners, loc: loc, radiusKm: radiusKm},
		events:  events,
		push:    push,
		clock:   clock,
		log:     log,
	}
}

// Dispatch sends the booking to the next cleaner who hasn't seen it yet. It
// does nothing if the booking isn't waiting for a cleaner or already has an
// open offer.
func (d *Dispatcher) Dispatch(ctx context.Context, bookingID uuid.UUID) error {
	b, err := d.store.GetBooking(ctx, bookingID)
	if err != nil {
		return err
	}
	if b.Status != domain.StatusConfirmed {
		return nil
	}
	addr, err := d.store.GetAddress(ctx, b.AddressID)
	if err != nil {
		return err
	}
	offered, err := d.store.OfferedCleaners(ctx, b.ID)
	if err != nil {
		return err
	}

	next, err := d.nextCandidate(ctx, b, addr, offered)
	if err != nil || next == nil {
		return err
	}
	return d.Offer(ctx, b, next.cleaner.UserID, next.distanceKm)
}

func (d *Dispatcher) nextCandidate(ctx context.Context, b domain.Booking, addr domain.Address, offered map[uuid.UUID]bool) (*candidate, error) {
	visit := domain.Period{Start: b.Start, End: b.End}
	q := matchQuery{lat: addr.Lat, lng: addr.Lng, day: b.Start}

	// A cleaner the client asked for gets the first chance even if offline:
	// the push notification can bring them online.
	if b.RequestedCleanerID != nil && !offered[*b.RequestedCleanerID] {
		q.only = b.RequestedCleanerID
		cands, err := d.matcher.candidates(ctx, q)
		if err != nil {
			return nil, err
		}
		if len(cands) == 1 && cands[0].freeFor(visit, d.matcher.loc) {
			return &cands[0], nil
		}
		q.only = nil
	}

	q.onlineOnly = true
	cands, err := d.matcher.candidates(ctx, q)
	if err != nil {
		return nil, err
	}
	for i, c := range cands {
		if !offered[c.cleaner.UserID] && c.freeFor(visit, d.matcher.loc) {
			return &cands[i], nil
		}
	}
	d.log.Info("no cleaner available for booking", "booking_id", b.ID, "already_offered", len(offered))
	return nil, nil
}

// Offer gives one cleaner OfferTTL to accept the booking.
func (d *Dispatcher) Offer(ctx context.Context, b domain.Booking, cleanerID uuid.UUID, distanceKm float64) error {
	expires := d.clock.now().Add(domain.OfferTTL)
	created, err := d.store.CreateOffer(ctx, domain.Offer{
		BookingID:  b.ID,
		CleanerID:  cleanerID,
		DistanceKm: distanceKm,
		ExpiresAt:  expires,
	})
	if err != nil || !created {
		return err
	}
	d.events.OfferNew(cleanerID, b, expires)
	d.push.Notify(cleanerID, domain.Notification{
		Title: "New job nearby",
		Body:  b.ServiceTitle + " · " + b.Start.In(d.matcher.loc).Format("Mon 2 Jan 15:04"),
		Data:  map[string]string{"type": "offer.new", "booking_id": b.ID.String()},
	})
	return nil
}

// Accept assigns the booking to the cleaner. Exactly one cleaner can win:
// the update is conditional on the booking still being confirmed, and the
// database rejects it if the cleaner is already busy at that time.
func (d *Dispatcher) Accept(ctx context.Context, p Principal, bookingID uuid.UUID) (domain.Booking, error) {
	if err := d.requireApproved(ctx, p.UserID); err != nil {
		return domain.Booking{}, err
	}
	b, withdrawn, err := d.store.AcceptOffer(ctx, bookingID, p.UserID, d.clock.now())
	if errors.Is(err, domain.ErrSlotTaken) {
		// The cleaner can't take it, so the next one should get the chance.
		if _, cerr := d.store.CloseOffer(ctx, bookingID, p.UserID, domain.OfferDeclined); cerr != nil {
			d.log.Error("close offer after slot_taken", "booking_id", bookingID, "err", cerr)
		}
		d.dispatchLogged(ctx, bookingID)
		return domain.Booking{}, err
	}
	if err != nil {
		return domain.Booking{}, err
	}

	for _, cleanerID := range withdrawn {
		d.events.OfferGone(cleanerID, b.ID)
	}
	d.events.BookingStatus(b, d.clock.now())
	d.push.Notify(b.ClientID, domain.Notification{
		Title: "Your cleaner is booked",
		Body:  "We found a cleaner for " + b.Start.In(d.matcher.loc).Format("Mon 2 Jan 15:04") + ".",
		Data:  map[string]string{"type": "booking.status", "booking_id": b.ID.String()},
	})
	return b, nil
}

func (d *Dispatcher) Decline(ctx context.Context, p Principal, bookingID uuid.UUID) error {
	closed, err := d.store.CloseOffer(ctx, bookingID, p.UserID, domain.OfferDeclined)
	if err != nil {
		return err
	}
	if !closed {
		return domain.ErrOfferGone
	}
	d.dispatchLogged(ctx, bookingID)
	return nil
}

// OfferView is an open offer as the cleaner app shows it. The exact address
// is only shared once the job is accepted.
type OfferView struct {
	Booking    domain.Booking `json:"booking"`
	ExpiresAt  time.Time      `json:"expires_at"`
	DistanceKm float64        `json:"distance_km"`
	Postcode   string         `json:"postcode"`
	City       string         `json:"city"`
}

func (d *Dispatcher) OpenOffers(ctx context.Context, p Principal) ([]OfferView, error) {
	offers, err := d.store.OpenOffers(ctx, p.UserID, d.clock.now())
	if err != nil {
		return nil, err
	}
	views := make([]OfferView, 0, len(offers))
	for _, o := range offers {
		b, err := d.store.GetBooking(ctx, o.BookingID)
		if err != nil {
			return nil, err
		}
		addr, err := d.store.GetAddress(ctx, b.AddressID)
		if err != nil {
			return nil, err
		}
		views = append(views, OfferView{
			Booking: b, ExpiresAt: o.ExpiresAt, DistanceKm: o.DistanceKm,
			Postcode: addr.Postcode, City: addr.City,
		})
	}
	return views, nil
}

// Sweep expires unanswered offers and dispatches bookings that are waiting
// for a cleaner, e.g. because someone new came online. The scheduler calls
// it every few seconds.
func (d *Dispatcher) Sweep(ctx context.Context) error {
	now := d.clock.now()
	expired, err := d.store.ExpireOffers(ctx, now)
	if err != nil {
		return err
	}
	for _, o := range expired {
		d.events.OfferGone(o.CleanerID, o.BookingID)
	}

	waiting, err := d.store.BookingsAwaitingOffer(ctx, now)
	if err != nil {
		return err
	}
	for _, id := range waiting {
		if err := ctx.Err(); err != nil {
			return err
		}
		d.dispatchLogged(ctx, id)
	}
	return nil
}

func (d *Dispatcher) dispatchLogged(ctx context.Context, bookingID uuid.UUID) {
	if err := d.Dispatch(ctx, bookingID); err != nil {
		d.log.Error("dispatch booking", "booking_id", bookingID, "err", err)
	}
}

func (d *Dispatcher) requireApproved(ctx context.Context, cleanerID uuid.UUID) error {
	c, err := d.store.GetCleaner(ctx, cleanerID)
	if errors.Is(err, domain.ErrNotFound) {
		return domain.Forbidden("Only cleaners can do that.")
	}
	if err != nil {
		return err
	}
	if c.Status != domain.CleanerApproved {
		return domain.Forbidden("Your profile isn't approved yet.")
	}
	return nil
}
