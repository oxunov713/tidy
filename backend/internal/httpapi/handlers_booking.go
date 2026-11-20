package httpapi

import (
	"io"
	"net/http"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

type quoteRequest struct {
	ServiceID uuid.UUID        `json:"service_id"`
	Bedrooms  int              `json:"bedrooms"`
	Bathrooms int              `json:"bathrooms"`
	ExtraIDs  []uuid.UUID      `json:"extra_ids"`
	Frequency domain.Frequency `json:"frequency"`
}

func (q quoteRequest) toService() service.QuoteRequest {
	return service.QuoteRequest{
		ServiceID: q.ServiceID, Bedrooms: q.Bedrooms, Bathrooms: q.Bathrooms,
		ExtraIDs: q.ExtraIDs, Frequency: q.Frequency,
	}
}

func (s *Server) quote(w http.ResponseWriter, r *http.Request) error {
	var in quoteRequest
	if err := decode(w, r, &in); err != nil {
		return err
	}
	q, err := s.bookings.Quote(r.Context(), in.toService())
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, q)
	return nil
}

func (s *Server) slots(w http.ResponseWriter, r *http.Request) error {
	q := newQuery(r)
	in := service.SlotsRequest{
		QuoteRequest: service.QuoteRequest{
			ServiceID: q.uuid("service_id"),
			Bedrooms:  q.int("bedrooms", 1),
			Bathrooms: q.int("bathrooms", 1),
			ExtraIDs:  q.uuids("extra_ids"),
			Frequency: domain.Frequency(q.str("frequency")),
		},
		Date:      q.str("date"),
		AddressID: q.uuid("address_id"),
		CleanerID: q.optionalUUID("cleaner_id"),
	}
	if err := q.err(); err != nil {
		return err
	}
	day, err := s.bookings.Slots(r.Context(), principal(r), in)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, day)
	return nil
}

func (s *Server) createBooking(w http.ResponseWriter, r *http.Request) error {
	var in struct {
		quoteRequest
		AddressID uuid.UUID  `json:"address_id"`
		Start     time.Time  `json:"start"`
		CleanerID *uuid.UUID `json:"cleaner_id"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	created, err := s.bookings.Create(r.Context(), principal(r), service.CreateBookingRequest{
		QuoteRequest: in.toService(),
		AddressID:    in.AddressID,
		Start:        in.Start,
		CleanerID:    in.CleanerID,
	})
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusCreated, created)
	return nil
}

func (s *Server) payBooking(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	pay, err := s.bookings.Pay(r.Context(), principal(r), id)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, pay)
	return nil
}

func (s *Server) listBookings(w http.ResponseWriter, r *http.Request) error {
	q := newQuery(r)
	scope := q.str("scope")
	if scope == "" {
		scope = "upcoming"
	}
	q.errs.Check(scope == "upcoming" || scope == "past", "scope", "must be upcoming or past")
	limit := q.int("limit", 0)
	if err := q.err(); err != nil {
		return err
	}
	page, err := s.bookings.List(r.Context(), principal(r), scope == "upcoming", q.str("cursor"), limit)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, page)
	return nil
}

func (s *Server) getBooking(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	d, err := s.bookings.Get(r.Context(), principal(r), id)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, d)
	return nil
}

func (s *Server) cancelBooking(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	var in struct {
		Scope service.CancelScope `json:"scope"`
	}
	if err := decodeOptional(w, r, &in); err != nil {
		return err
	}
	c, err := s.bookings.Cancel(r.Context(), principal(r), id, in.Scope)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, c)
	return nil
}

func (s *Server) listPlans(w http.ResponseWriter, r *http.Request) error {
	plans, err := s.bookings.Plans(r.Context(), principal(r))
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, plans)
	return nil
}

func (s *Server) endPlan(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	if err := s.bookings.EndPlan(r.Context(), principal(r), id); err != nil {
		return err
	}
	return noContent(w)
}

func (s *Server) reviewBooking(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	var in struct {
		Rating  int      `json:"rating"`
		Tags    []string `json:"tags"`
		Comment string   `json:"comment"`
		Tip     int      `json:"tip"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	review, err := s.bookings.Review(r.Context(), principal(r), id, service.ReviewRequest{
		Rating: in.Rating, Tags: in.Tags, Comment: in.Comment, Tip: in.Tip,
	})
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusCreated, review)
	return nil
}

func (s *Server) listMessages(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	list, err := s.bookings.Messages(r.Context(), principal(r), id)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, list)
	return nil
}

func (s *Server) postMessage(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	var in struct {
		Body string `json:"body"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	m, err := s.bookings.PostMessage(r.Context(), principal(r), id, in.Body)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusCreated, m)
	return nil
}

const maxWebhookBytes = 64 << 10

func (s *Server) stripeWebhook(w http.ResponseWriter, r *http.Request) error {
	payload, err := io.ReadAll(http.MaxBytesReader(w, r.Body, maxWebhookBytes))
	if err != nil {
		return domain.NewError(domain.CodeInvalidRequest, "Could not read the webhook body.")
	}
	if err := s.payments.HandleWebhook(r.Context(), payload, r.Header.Get("Stripe-Signature")); err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, map[string]bool{"received": true})
	return nil
}
