package service

import (
	"context"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// The interfaces below are what the use cases need from the outside world.
// Postgres, Stripe, FCM and the WebSocket hub implement them; tests can swap
// any of them out.

type OTPState struct {
	CodeHash  string
	ExpiresAt time.Time
	Attempts  int
}

type AuthStore interface {
	CountOTPRequests(ctx context.Context, phone string, since time.Time) (int, error)
	// SaveOTP replaces any previous code for the phone and records the request.
	SaveOTP(ctx context.Context, phone, codeHash string, expiresAt time.Time) error
	// TouchOTP counts one more attempt and returns the code state after it.
	TouchOTP(ctx context.Context, phone string) (OTPState, error)
	// ConsumeOTP deletes the code if it still matches, so it works only once.
	ConsumeOTP(ctx context.Context, phone, codeHash string) (bool, error)
	DeleteOTP(ctx context.Context, phone string) error

	GetUserByPhone(ctx context.Context, phone string) (domain.User, error)
	// CreateUser signs a phone number up. If the number signed up in the
	// meantime, it returns that account unchanged.
	CreateUser(ctx context.Context, phone string, role domain.Role) (domain.User, error)
	GetUser(ctx context.Context, id uuid.UUID) (domain.User, error)

	SaveRefreshToken(ctx context.Context, userID uuid.UUID, tokenHash string, expiresAt time.Time) error
	// RotateRefreshToken revokes oldHash and stores newHash, and returns when
	// the rotation happened. Presenting oldHash again within grace of its
	// rotation, with the same newHash, returns that first rotation. Any other
	// reuse revokes every token of the user.
	RotateRefreshToken(ctx context.Context, r RefreshRotation) (uuid.UUID, time.Time, error)
	RevokeRefreshToken(ctx context.Context, tokenHash string) error
}

type RefreshRotation struct {
	OldHash, NewHash string
	ExpiresAt        time.Time
	Now              time.Time
	Grace            time.Duration
}

type UserStore interface {
	GetUser(ctx context.Context, id uuid.UUID) (domain.User, error)
	GetUsers(ctx context.Context, ids []uuid.UUID) (map[uuid.UUID]domain.User, error)
	UpdateUser(ctx context.Context, id uuid.UUID, fullName, email *string) (domain.User, error)
	GetCleaner(ctx context.Context, id uuid.UUID) (domain.Cleaner, error)

	UpsertDevice(ctx context.Context, userID uuid.UUID, token string, platform domain.DevicePlatform) error
	// DeleteUserDevice removes the token only if it belongs to the user.
	DeleteUserDevice(ctx context.Context, userID uuid.UUID, token string) error

	ListAddresses(ctx context.Context, userID uuid.UUID) ([]domain.Address, error)
	CreateAddress(ctx context.Context, a domain.Address) (domain.Address, error)
	// GetAddress returns deleted addresses too; old bookings still show them.
	GetAddress(ctx context.Context, id uuid.UUID) (domain.Address, error)
	DeleteAddress(ctx context.Context, userID, id uuid.UUID) error
}

type DeviceStore interface {
	DeviceTokens(ctx context.Context, userID uuid.UUID) ([]string, error)
	DeleteDevice(ctx context.Context, token string) error
}

type CatalogueStore interface {
	ListServices(ctx context.Context, activeOnly bool) ([]domain.Service, error)
	GetService(ctx context.Context, id uuid.UUID) (domain.Service, error)
	UpdateService(ctx context.Context, s domain.Service) (domain.Service, error)
	ListExtras(ctx context.Context) ([]domain.Extra, error)
	// GetExtras fails with invalid_request if any id is unknown.
	GetExtras(ctx context.Context, ids []uuid.UUID) ([]domain.Extra, error)
}

type CleanerStore interface {
	GetCleaner(ctx context.Context, id uuid.UUID) (domain.Cleaner, error)
	// ListApprovedCleaners returns every approved cleaner, or with
	// onlineSince only those online and seen since then.
	ListApprovedCleaners(ctx context.Context, onlineSince *time.Time) ([]domain.Cleaner, error)
	AvailabilityFor(ctx context.Context, cleanerIDs []uuid.UUID, weekday int) (map[uuid.UUID]domain.Availability, error)
	// BusyPeriods returns visits of each cleaner that overlap [from, to),
	// cancelled ones excluded.
	BusyPeriods(ctx context.Context, cleanerIDs []uuid.UUID, from, to time.Time) (map[uuid.UUID][]domain.Period, error)
	// SetCleanerOnline and TouchCleaner also record the cleaner as seen at now.
	SetCleanerOnline(ctx context.Context, id uuid.UUID, online bool, lat, lng *float64, now time.Time) error
	TouchCleaner(ctx context.Context, id uuid.UUID, now time.Time) error
	GetAvailability(ctx context.Context, id uuid.UUID) ([]domain.Availability, error)
	ReplaceAvailability(ctx context.Context, id uuid.UUID, list []domain.Availability) error
	CompletedJobs(ctx context.Context, cleanerID uuid.UUID, from, to time.Time) ([]EarningJob, error)
}

type ListBookingsFilter struct {
	ClientID *uuid.UUID
	// Upcoming selects visits that haven't finished; otherwise past ones.
	Upcoming *bool
	Status   *domain.BookingStatus
	// Query matches the booking code or the client's name or phone.
	Query  string
	Now    time.Time
	Cursor string
	Limit  int
}

type BookingStore interface {
	CreateBooking(ctx context.Context, nb domain.NewBooking) (domain.Booking, error)
	GetBooking(ctx context.Context, id uuid.UUID) (domain.Booking, error)
	ListBookings(ctx context.Context, f ListBookingsFilter) ([]domain.Booking, string, error)
	ListCleanerJobs(ctx context.Context, cleanerID uuid.UUID, from, to time.Time) ([]domain.Booking, error)
	// SetBookingStatus moves the booking from one status to another. It fails
	// with invalid_transition if the booking is no longer in from.
	SetBookingStatus(ctx context.Context, id uuid.UUID, from, to domain.BookingStatus, actor *uuid.UUID) (domain.Booking, error)
	// CancelStuck cancels pending bookings whose payment was due by now and
	// confirmed bookings still without a cleaner that start by unassignedBy.
	CancelStuck(ctx context.Context, now, unassignedBy time.Time) (StuckBookings, error)
	// CancelBooking also withdraws open offers and returns whose they were.
	CancelBooking(ctx context.Context, id uuid.UUID, from domain.BookingStatus, actor *uuid.UUID) (domain.Booking, []uuid.UUID, error)
	// AssignCleaner sets the cleaner directly (admin). The database rejects
	// it with slot_taken if the cleaner is busy then.
	AssignCleaner(ctx context.Context, bookingID, cleanerID uuid.UUID, actor *uuid.UUID) (domain.Booking, []uuid.UUID, error)
	BookingEvents(ctx context.Context, id uuid.UUID) ([]domain.BookingEvent, error)
	LastLocation(ctx context.Context, bookingID uuid.UUID) (*domain.Location, error)
	SaveLocation(ctx context.Context, bookingID, cleanerID uuid.UUID, lat, lng float64, now time.Time) error

	CreateReview(ctx context.Context, r domain.Review) (domain.Review, error)
	GetReview(ctx context.Context, bookingID uuid.UUID) (*domain.Review, error)
	ListMessages(ctx context.Context, bookingID uuid.UUID) ([]domain.Message, error)
	CreateMessage(ctx context.Context, m domain.Message) (domain.Message, error)

	GetPlan(ctx context.Context, id uuid.UUID) (domain.Plan, error)
	ListPlans(ctx context.Context, clientID uuid.UUID) ([]PlanSummary, error)
	DuePlans(ctx context.Context, until time.Time) ([]domain.Plan, error)
	// AdvancePlan moves an active plan to its next date.
	AdvancePlan(ctx context.Context, id uuid.UUID, next time.Time) error
	// EndPlan deactivates the plan and cancels its future visits that have
	// no cleaner yet. Ending a plan twice is not an error.
	EndPlan(ctx context.Context, id uuid.UUID, now time.Time, actor *uuid.UUID) (EndedPlan, error)

	StatsBetween(ctx context.Context, from, to time.Time) (Stats, error)
}

type OfferStore interface {
	// CreateOffer adds an open offer unless the booking already has one or
	// is no longer confirmed. It reports whether an offer was created.
	CreateOffer(ctx context.Context, o domain.Offer) (bool, error)
	OfferedCleaners(ctx context.Context, bookingID uuid.UUID) (map[uuid.UUID]bool, error)
	// AcceptOffer assigns the cleaner with one conditional update and returns
	// the cleaners whose offers were withdrawn.
	AcceptOffer(ctx context.Context, bookingID, cleanerID uuid.UUID, now time.Time) (domain.Booking, []uuid.UUID, error)
	// CloseOffer moves an open offer to status and reports whether it was open.
	CloseOffer(ctx context.Context, bookingID, cleanerID uuid.UUID, status domain.OfferStatus) (bool, error)
	ExpireOffers(ctx context.Context, now time.Time) ([]domain.OfferRef, error)
	// BookingsAwaitingOffer lists confirmed future bookings with no open offer.
	BookingsAwaitingOffer(ctx context.Context, now time.Time) ([]uuid.UUID, error)
	OpenOffers(ctx context.Context, cleanerID uuid.UUID, now time.Time) ([]domain.Offer, error)
}

type PaymentStore interface {
	CreatePayment(ctx context.Context, p domain.Payment) error
	// PaymentForBooking returns the booking's latest payment.
	PaymentForBooking(ctx context.Context, bookingID uuid.UUID) (domain.Payment, error)
	CountPayments(ctx context.Context, bookingID uuid.UUID) (int, error)
	SetPaymentStatus(ctx context.Context, id uuid.UUID, status domain.PaymentStatus) error
	// ApplyPaymentEvent records the event id and updates payment and booking
	// in one transaction. Booking is set when the booking's status changed;
	// a repeated event changes nothing.
	ApplyPaymentEvent(ctx context.Context, provider string, ev domain.PaymentEvent) (AppliedPayment, error)
	SetBookingStatus(ctx context.Context, id uuid.UUID, from, to domain.BookingStatus, actor *uuid.UUID) (domain.Booking, error)

	GetUser(ctx context.Context, id uuid.UUID) (domain.User, error)
	// PaymentCustomer fails with not_found if the user has no customer yet.
	PaymentCustomer(ctx context.Context, userID uuid.UUID, provider string) (string, error)
	// SavePaymentCustomer keeps the first customer stored for the user and
	// returns it.
	SavePaymentCustomer(ctx context.Context, userID uuid.UUID, provider, ref string) (string, error)

	// SetPaymentDue sets when an unpaid pending booking is cancelled; nil
	// means the client owes nothing right now.
	SetPaymentDue(ctx context.Context, bookingID uuid.UUID, at *time.Time) error
	// ScheduleAuthorization sets when the saved card is charged; nil clears it.
	ScheduleAuthorization(ctx context.Context, bookingID uuid.UUID, at *time.Time) error
	// ClaimAuthorizations clears and returns pending bookings whose saved
	// card is due to be charged, so two sweeps never charge one twice.
	ClaimAuthorizations(ctx context.Context, now time.Time, limit int) ([]domain.Booking, error)
}

type StuckBookings struct {
	Unpaid     []CancelledBooking
	Unassigned []CancelledBooking
}

type AppliedPayment struct {
	Booking *domain.Booking
	// Withdrawn are cleaners whose offers went away with a cancelled booking.
	Withdrawn []uuid.UUID
}

type AdminStore interface {
	ListCleanerProfiles(ctx context.Context, status *domain.CleanerStatus) ([]domain.CleanerProfile, error)
	SetCleanerStatus(ctx context.Context, id uuid.UUID, status domain.CleanerStatus) error
	// SuspendCleaner takes the cleaner offline, moves their jobs that haven't
	// started back to confirmed and withdraws their open offers.
	SuspendCleaner(ctx context.Context, id uuid.UUID, actor *uuid.UUID) (ReleasedJobs, error)
}

type ReleasedJobs struct {
	// Released are the bookings that lost their cleaner.
	Released []domain.Booking
	// WithdrawnOffers are bookings whose open offer to the cleaner was withdrawn.
	WithdrawnOffers []uuid.UUID
}

// PaymentProvider holds money for a booking and charges it once the clean is done.
type PaymentProvider interface {
	Name() string
	// CreateCustomer registers the user, so a card can be saved for them.
	CreateCustomer(ctx context.Context, u domain.User) (string, error)
	// CreateIntent holds the booking total with manual capture. The app
	// confirms it with the client secret.
	CreateIntent(ctx context.Context, req domain.ChargeRequest) (domain.PaymentIntent, error)
	// CreateSetup saves a card for charging later without the client.
	CreateSetup(ctx context.Context, req domain.ChargeRequest) (domain.PaymentIntent, error)
	// AuthorizeSaved holds the total on the customer's saved card while the
	// client is away. A declined card is not an error: the intent comes back
	// with PaymentFailed, and with an empty Ref if no intent was created.
	AuthorizeSaved(ctx context.Context, req domain.ChargeRequest) (domain.PaymentIntent, error)
	Capture(ctx context.Context, ref string) error
	// Refund gives the money back, or releases it if it was never captured.
	Refund(ctx context.Context, ref string) error
	ParseWebhook(payload []byte, signature string) (domain.PaymentEvent, error)
}

// Notifier sends one push notification to one device.
type Notifier interface {
	Send(ctx context.Context, deviceToken string, n domain.Notification) error
}

// CodeSender delivers the login code, by SMS in a real deployment.
type CodeSender interface {
	SendCode(ctx context.Context, phone, code string) error
}

// Events pushes changes to apps connected over the WebSocket.
type Events interface {
	BookingStatus(b domain.Booking, at time.Time)
	OfferNew(cleanerID uuid.UUID, b domain.Booking, expiresAt time.Time)
	OfferGone(cleanerID, bookingID uuid.UUID)
	MessageNew(bookingID uuid.UUID, m domain.Message)
	// BookingAccessRevoked removes the user from the booking's room, e.g.
	// the old cleaner after a reassign.
	BookingAccessRevoked(bookingID, userID uuid.UUID)
	// UserAccessRevoked removes the user from every booking room.
	UserAccessRevoked(userID uuid.UUID)
}

// NopEvents is used where nobody listens, e.g. in a one-off command.
type NopEvents struct{}

func (NopEvents) BookingStatus(domain.Booking, time.Time)       {}
func (NopEvents) OfferNew(uuid.UUID, domain.Booking, time.Time) {}
func (NopEvents) OfferGone(uuid.UUID, uuid.UUID)                {}
func (NopEvents) MessageNew(uuid.UUID, domain.Message)          {}
func (NopEvents) BookingAccessRevoked(uuid.UUID, uuid.UUID)     {}
func (NopEvents) UserAccessRevoked(uuid.UUID)                   {}
