package payment

import (
	"context"
	"errors"
	"fmt"

	"github.com/stripe/stripe-go/v83"
	"github.com/stripe/stripe-go/v83/webhook"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// Stripe holds the card payment with manual capture: the money is
// authorised before the visit and charged when the clean is done. Visits
// further ahead than a hold lasts save the card with a SetupIntent first.
type Stripe struct {
	client        *stripe.Client
	webhookSecret string
}

func NewStripe(secretKey, webhookSecret string) *Stripe {
	return &Stripe{client: stripe.NewClient(secretKey), webhookSecret: webhookSecret}
}

func (s *Stripe) Name() string { return "stripe" }

func (s *Stripe) CreateCustomer(ctx context.Context, u domain.User) (string, error) {
	params := &stripe.CustomerCreateParams{Phone: stripe.String(u.Phone)}
	if u.FullName != "" {
		params.Name = stripe.String(u.FullName)
	}
	if u.Email != nil {
		params.Email = u.Email
	}
	params.AddMetadata("user_id", u.ID.String())
	params.SetIdempotencyKey("customer-" + u.ID.String())
	c, err := s.client.V1Customers.Create(ctx, params)
	if err != nil {
		return "", err
	}
	return c.ID, nil
}

func (s *Stripe) CreateIntent(ctx context.Context, req domain.ChargeRequest) (domain.PaymentIntent, error) {
	params := s.intentParams(req)
	params.AutomaticPaymentMethods = &stripe.PaymentIntentCreateAutomaticPaymentMethodsParams{
		Enabled: stripe.Bool(true),
	}
	if req.SaveCard && req.Customer != "" {
		params.SetupFutureUsage = stripe.String(string(stripe.PaymentIntentSetupFutureUsageOffSession))
	}
	pi, err := s.client.V1PaymentIntents.Create(ctx, params)
	if err != nil {
		return domain.PaymentIntent{}, err
	}
	return domain.PaymentIntent{Ref: pi.ID, ClientSecret: pi.ClientSecret, Status: domain.PaymentRequiresAction}, nil
}

func (s *Stripe) CreateSetup(ctx context.Context, req domain.ChargeRequest) (domain.PaymentIntent, error) {
	if req.Customer == "" {
		return domain.PaymentIntent{}, errors.New("a card can only be saved for a customer")
	}
	params := &stripe.SetupIntentCreateParams{
		Customer: stripe.String(req.Customer),
		Usage:    stripe.String(string(stripe.SetupIntentUsageOffSession)),
		AutomaticPaymentMethods: &stripe.SetupIntentCreateAutomaticPaymentMethodsParams{
			Enabled: stripe.Bool(true),
		},
	}
	params.AddMetadata("booking_id", req.Booking.ID.String())
	params.SetIdempotencyKey(req.IdempotencyKey)
	si, err := s.client.V1SetupIntents.Create(ctx, params)
	if err != nil {
		return domain.PaymentIntent{}, err
	}
	return domain.PaymentIntent{Ref: si.ID, ClientSecret: si.ClientSecret, Status: domain.PaymentRequiresAction}, nil
}

func (s *Stripe) AuthorizeSaved(ctx context.Context, req domain.ChargeRequest) (domain.PaymentIntent, error) {
	card, err := s.savedCard(ctx, req.Customer)
	if err != nil {
		return domain.PaymentIntent{}, err
	}
	if card == "" {
		return domain.PaymentIntent{Status: domain.PaymentFailed}, nil
	}
	params := s.intentParams(req)
	params.PaymentMethod = stripe.String(card)
	params.OffSession = stripe.Bool(true)
	params.Confirm = stripe.Bool(true)

	pi, err := s.client.V1PaymentIntents.Create(ctx, params)
	var se *stripe.Error
	if errors.As(err, &se) && se.Type == stripe.ErrorTypeCard {
		// Declined or the bank wants the client present. The client pays
		// in the app instead.
		out := domain.PaymentIntent{Status: domain.PaymentFailed}
		if se.PaymentIntent != nil {
			out.Ref = se.PaymentIntent.ID
		}
		return out, nil
	}
	if err != nil {
		return domain.PaymentIntent{}, err
	}
	status := domain.PaymentFailed
	if pi.Status == stripe.PaymentIntentStatusRequiresCapture {
		status = domain.PaymentAuthorized
	}
	return domain.PaymentIntent{Ref: pi.ID, ClientSecret: pi.ClientSecret, Status: status}, nil
}

func (s *Stripe) intentParams(req domain.ChargeRequest) *stripe.PaymentIntentCreateParams {
	b := req.Booking
	params := &stripe.PaymentIntentCreateParams{
		Amount:        stripe.Int64(int64(b.Total)),
		Currency:      stripe.String(string(stripe.CurrencyGBP)),
		CaptureMethod: stripe.String(string(stripe.PaymentIntentCaptureMethodManual)),
		Description:   stripe.String("Tidy booking " + b.Code),
	}
	if req.Customer != "" {
		params.Customer = stripe.String(req.Customer)
	}
	params.AddMetadata("booking_id", b.ID.String())
	// A retried request must not create a second intent for the same attempt.
	params.SetIdempotencyKey(req.IdempotencyKey)
	return params
}

// savedCard is the customer's most recently saved card, or "" if none.
func (s *Stripe) savedCard(ctx context.Context, customer string) (string, error) {
	if customer == "" {
		return "", nil
	}
	params := &stripe.CustomerListPaymentMethodsParams{
		Customer: stripe.String(customer),
		Type:     stripe.String(string(stripe.PaymentMethodTypeCard)),
	}
	params.Limit = stripe.Int64(1)
	for pm, err := range s.client.V1Customers.ListPaymentMethods(ctx, params) {
		if err != nil {
			return "", err
		}
		return pm.ID, nil
	}
	return "", nil
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
	// signature and the object id matter here.
	ev, err := webhook.ConstructEventWithOptions(payload, signature, s.webhookSecret,
		webhook.ConstructEventOptions{IgnoreAPIVersionMismatch: true})
	if err != nil {
		return domain.PaymentEvent{}, err
	}

	out := domain.PaymentEvent{ID: ev.ID, Kind: domain.PaymentEventIgnored}
	setup := false
	switch ev.Type {
	case stripe.EventTypePaymentIntentAmountCapturableUpdated:
		out.Kind = domain.PaymentEventAuthorized
	case stripe.EventTypePaymentIntentPaymentFailed:
		out.Kind = domain.PaymentEventFailed
	case stripe.EventTypePaymentIntentCanceled:
		out.Kind = domain.PaymentEventCanceled
	case stripe.EventTypeSetupIntentSucceeded:
		out.Kind, setup = domain.PaymentEventSaved, true
	case stripe.EventTypeSetupIntentSetupFailed:
		out.Kind, setup = domain.PaymentEventFailed, true
	default:
		return out, nil
	}
	if setup {
		var si stripe.SetupIntent
		if err := si.UnmarshalJSON(ev.Data.Raw); err != nil {
			return domain.PaymentEvent{}, fmt.Errorf("decode setup intent: %w", err)
		}
		out.Ref = si.ID
		return out, nil
	}
	var pi stripe.PaymentIntent
	if err := pi.UnmarshalJSON(ev.Data.Raw); err != nil {
		return domain.PaymentEvent{}, fmt.Errorf("decode payment intent: %w", err)
	}
	out.Ref = pi.ID
	return out, nil
}
