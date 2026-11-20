package payment

import (
	"context"
	"fmt"

	"github.com/stripe/stripe-go/v83"
	"github.com/stripe/stripe-go/v83/webhook"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// Stripe holds the card payment with manual capture: the money is
// authorised when the booking is made and charged when the clean is done.
type Stripe struct {
	client        *stripe.Client
	webhookSecret string
}

func NewStripe(secretKey, webhookSecret string) *Stripe {
	return &Stripe{client: stripe.NewClient(secretKey), webhookSecret: webhookSecret}
}

func (s *Stripe) Name() string { return "stripe" }

func (s *Stripe) CreateIntent(ctx context.Context, b domain.Booking) (domain.PaymentIntent, error) {
	params := &stripe.PaymentIntentCreateParams{
		Amount:        stripe.Int64(int64(b.Total)),
		Currency:      stripe.String(string(stripe.CurrencyGBP)),
		CaptureMethod: stripe.String(string(stripe.PaymentIntentCaptureMethodManual)),
		Description:   stripe.String("Tidy booking " + b.Code),
		AutomaticPaymentMethods: &stripe.PaymentIntentCreateAutomaticPaymentMethodsParams{
			Enabled: stripe.Bool(true),
		},
	}
	params.AddMetadata("booking_id", b.ID.String())
	// A retried request must not create a second intent for the same booking.
	params.SetIdempotencyKey("booking-" + b.ID.String())

	pi, err := s.client.V1PaymentIntents.Create(ctx, params)
	if err != nil {
		return domain.PaymentIntent{}, err
	}
	return domain.PaymentIntent{Ref: pi.ID, ClientSecret: pi.ClientSecret, Status: domain.PaymentRequiresAction}, nil
}

func (s *Stripe) Capture(ctx context.Context, ref string) error {
	_, err := s.client.V1PaymentIntents.Capture(ctx, ref, &stripe.PaymentIntentCaptureParams{})
	return err
}

// Refund cancels an intent that was never captured (the hold is released)
// and refunds one that was.
func (s *Stripe) Refund(ctx context.Context, ref string) error {
	pi, err := s.client.V1PaymentIntents.Retrieve(ctx, ref, &stripe.PaymentIntentRetrieveParams{})
	if err != nil {
		return err
	}
	switch pi.Status {
	case stripe.PaymentIntentStatusSucceeded:
		_, err = s.client.V1Refunds.Create(ctx, &stripe.RefundCreateParams{PaymentIntent: stripe.String(ref)})
	case stripe.PaymentIntentStatusCanceled:
		return nil
	default:
		_, err = s.client.V1PaymentIntents.Cancel(ctx, ref, &stripe.PaymentIntentCancelParams{})
	}
	return err
}

func (s *Stripe) ParseWebhook(payload []byte, signature string) (domain.PaymentEvent, error) {
	// The account's API version may be newer than this library; only the
	// signature and the intent id matter here.
	ev, err := webhook.ConstructEventWithOptions(payload, signature, s.webhookSecret,
		webhook.ConstructEventOptions{IgnoreAPIVersionMismatch: true})
	if err != nil {
		return domain.PaymentEvent{}, err
	}

	out := domain.PaymentEvent{ID: ev.ID, Kind: domain.PaymentEventIgnored}
	switch ev.Type {
	case stripe.EventTypePaymentIntentAmountCapturableUpdated:
		out.Kind = domain.PaymentEventAuthorized
	case stripe.EventTypePaymentIntentPaymentFailed:
		out.Kind = domain.PaymentEventFailed
	case stripe.EventTypePaymentIntentCanceled:
		out.Kind = domain.PaymentEventCanceled
	default:
		return out, nil
	}
	var pi stripe.PaymentIntent
	if err := pi.UnmarshalJSON(ev.Data.Raw); err != nil {
		return domain.PaymentEvent{}, fmt.Errorf("decode payment intent: %w", err)
	}
	out.Ref = pi.ID
	return out, nil
}
