package service

import (
	"context"
	"net/mail"
	"strings"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

type Users struct {
	store UserStore
}

func NewUsers(store UserStore) *Users { return &Users{store: store} }

// Me is the signed-in user, with the cleaner profile for cleaners.
type Me struct {
	domain.User
	Cleaner *domain.Cleaner `json:"cleaner,omitempty"`
}

func (u *Users) Me(ctx context.Context, p Principal) (Me, error) {
	user, err := u.store.GetUser(ctx, p.UserID)
	if err != nil {
		return Me{}, err
	}
	me := Me{User: user}
	if user.Role == domain.RoleCleaner {
		c, err := u.store.GetCleaner(ctx, user.ID)
		if err != nil {
			return Me{}, err
		}
		me.Cleaner = &c
	}
	return me, nil
}

type ProfileUpdate struct {
	FullName *string
	Email    *string
}

func (u *Users) UpdateMe(ctx context.Context, p Principal, in ProfileUpdate) (Me, error) {
	fe := domain.FieldErrors{}
	if in.FullName != nil {
		name := strings.TrimSpace(*in.FullName)
		fe.Check(len(name) <= 100, "full_name", "is too long")
		in.FullName = &name
	}
	if in.Email != nil {
		// An empty email clears it.
		email := strings.TrimSpace(*in.Email)
		if email != "" {
			addr, err := mail.ParseAddress(email)
			fe.Check(err == nil && addr.Address == email, "email", "is not a valid email address")
		}
		in.Email = &email
	}
	if err := fe.Err(); err != nil {
		return Me{}, err
	}
	if _, err := u.store.UpdateUser(ctx, p.UserID, in.FullName, in.Email); err != nil {
		return Me{}, err
	}
	return u.Me(ctx, p)
}

func (u *Users) RegisterDevice(ctx context.Context, p Principal, token string, platform domain.DevicePlatform) error {
	fe := domain.FieldErrors{}
	fe.Check(token != "" && len(token) <= 4096, "token", "is required")
	fe.Check(platform.Valid(), "platform", "must be android, ios or web")
	if err := fe.Err(); err != nil {
		return err
	}
	return u.store.UpsertDevice(ctx, p.UserID, token, platform)
}

func (u *Users) Addresses(ctx context.Context, p Principal) ([]domain.Address, error) {
	return u.store.ListAddresses(ctx, p.UserID)
}

func (u *Users) AddAddress(ctx context.Context, p Principal, a domain.Address) (domain.Address, error) {
	a.UserID = p.UserID
	a.Line1, a.Line2 = strings.TrimSpace(a.Line1), strings.TrimSpace(a.Line2)
	a.City, a.Postcode = strings.TrimSpace(a.City), strings.ToUpper(strings.TrimSpace(a.Postcode))
	if err := a.Validate(); err != nil {
		return domain.Address{}, err
	}
	return u.store.CreateAddress(ctx, a)
}

func (u *Users) DeleteAddress(ctx context.Context, p Principal, id uuid.UUID) error {
	return u.store.DeleteAddress(ctx, p.UserID, id)
}

// Catalogue is the public list of services and extras.
type Catalogue struct {
	store CatalogueStore
}

func NewCatalogue(store CatalogueStore) *Catalogue { return &Catalogue{store: store} }

func (c *Catalogue) Services(ctx context.Context) ([]domain.Service, error) {
	return c.store.ListServices(ctx, true)
}

func (c *Catalogue) Extras(ctx context.Context) ([]domain.Extra, error) {
	return c.store.ListExtras(ctx)
}

type ServiceUpdate struct {
	Title          string
	BasePrice      int
	PerBedroom     int
	PerBathroom    int
	BaseMinutes    int
	MinutesPerRoom int
	IsActive       bool
}

// UpdateService changes prices and duration. Existing bookings keep the
// price they were made with.
func (c *Catalogue) UpdateService(ctx context.Context, id uuid.UUID, in ServiceUpdate) (domain.Service, error) {
	s, err := c.store.GetService(ctx, id)
	if err != nil {
		return domain.Service{}, err
	}
	s.Title = strings.TrimSpace(in.Title)
	s.BasePrice, s.PerBedroom, s.PerBathroom = in.BasePrice, in.PerBedroom, in.PerBathroom
	s.BaseMinutes, s.MinutesPerRoom, s.IsActive = in.BaseMinutes, in.MinutesPerRoom, in.IsActive
	if err := s.Validate(); err != nil {
		return domain.Service{}, err
	}
	return c.store.UpdateService(ctx, s)
}
