// Package payment has the PaymentProvider implementations.
package payment

import (
	"context"
	"errors"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// Mock authorises every payment instantly, so the whole booking flow works
// without a Stripe account.
type Mock struct{}

func (Mock) Name() string { return "mock" }

func (Mock) CreateIntent(_ context.Context, b domain.Booking) (domain.PaymentIntent, error) {
	ref := "mock_pi_" + uuid.NewString()
	return domain.PaymentIntent{
		Ref:          ref,
		ClientSecret: ref + "_secret",
		Status:       domain.PaymentAuthorized,
	}, nil
}

func (Mock) Capture(context.Context, string) error { return nil }

func (Mock) Refund(context.Context, string) error { return nil }

func (Mock) ParseWebhook([]byte, string) (domain.PaymentEvent, error) {
	return domain.PaymentEvent{}, errors.New("mock provider has no webhooks")
}
