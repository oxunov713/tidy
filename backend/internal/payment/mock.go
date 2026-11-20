// Package payment has the PaymentProvider implementations.
package payment

import (
	"context"
	"errors"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// Mock succeeds at everything instantly, so the whole booking flow works
// without a Stripe account. Its secrets have the same shape as Stripe's.
type Mock struct{}

func (Mock) Name() string { return "mock" }

func (Mock) CreateCustomer(context.Context, domain.User) (string, error) {
	return "mock_cus_" + uuid.NewString(), nil
}

func (Mock) CreateIntent(context.Context, domain.ChargeRequest) (domain.PaymentIntent, error) {
	return mockIntent("mock_pi_", domain.PaymentAuthorized), nil
}

func (Mock) CreateSetup(context.Context, domain.ChargeRequest) (domain.PaymentIntent, error) {
	return mockIntent("mock_seti_", domain.PaymentSaved), nil
}

func (Mock) AuthorizeSaved(context.Context, domain.ChargeRequest) (domain.PaymentIntent, error) {
	return mockIntent("mock_pi_", domain.PaymentAuthorized), nil
}

func (Mock) Capture(context.Context, string) error { return nil }

func (Mock) Refund(context.Context, string) error { return nil }

func (Mock) ParseWebhook([]byte, string) (domain.PaymentEvent, error) {
	return domain.PaymentEvent{}, errors.New("mock provider has no webhooks")
}

func mockIntent(prefix string, status domain.PaymentStatus) domain.PaymentIntent {
	ref := prefix + uuid.NewString()
	return domain.PaymentIntent{Ref: ref, ClientSecret: ref + "_secret_mock", Status: status}
}
