package httpapi

import (
	"net/http"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

func (s *Server) statsToday(w http.ResponseWriter, r *http.Request) error {
	st, err := s.admin.StatsToday(r.Context())
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, st)
	return nil
}

func (s *Server) adminBookings(w http.ResponseWriter, r *http.Request) error {
	q := newQuery(r)
	var status *domain.BookingStatus
	if v := q.str("status"); v != "" {
		st := domain.BookingStatus(v)
		status = &st
	}
	limit := q.int("limit", 0)
	if err := q.err(); err != nil {
		return err
	}
	page, err := s.admin.Bookings(r.Context(), status, q.str("q"), q.str("cursor"), limit)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, page)
	return nil
}

func (s *Server) adminPatchBooking(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	var in struct {
		CleanerID *uuid.UUID            `json:"cleaner_id"`
		Status    *domain.BookingStatus `json:"status"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	b, err := s.admin.PatchBooking(r.Context(), principal(r), id, service.BookingPatch{CleanerID: in.CleanerID, Status: in.Status})
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, b)
	return nil
}

func (s *Server) adminCleaners(w http.ResponseWriter, r *http.Request) error {
	var status *domain.CleanerStatus
	if v := r.URL.Query().Get("status"); v != "" {
		st := domain.CleanerStatus(v)
		status = &st
	}
	list, err := s.admin.Cleaners(r.Context(), status)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, list)
	return nil
}

func (s *Server) setCleanerStatus(status domain.CleanerStatus) handlerFunc {
	return func(w http.ResponseWriter, r *http.Request) error {
		id, err := pathID(r, "id")
		if err != nil {
			return err
		}
		if err := s.admin.SetCleanerStatus(r.Context(), id, status); err != nil {
			return err
		}
		return noContent(w)
	}
}

func (s *Server) adminServices(w http.ResponseWriter, r *http.Request) error {
	list, err := s.catalogue.AllServices(r.Context())
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, list)
	return nil
}

func (s *Server) updateService(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	var in struct {
		Title          string `json:"title"`
		BasePrice      int    `json:"base_price"`
		PerBedroom     int    `json:"per_bedroom"`
		PerBathroom    int    `json:"per_bathroom"`
		BaseMinutes    int    `json:"base_minutes"`
		MinutesPerRoom int    `json:"minutes_per_room"`
		IsActive       *bool  `json:"is_active"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	// PUT replaces the whole service, so a missing flag must not quietly
	// switch a disabled service back on.
	if in.IsActive == nil {
		return domain.Invalid("is_active", "is required")
	}
	active := *in.IsActive
	svc, err := s.catalogue.UpdateService(r.Context(), id, service.ServiceUpdate{
		Title: in.Title, BasePrice: in.BasePrice, PerBedroom: in.PerBedroom, PerBathroom: in.PerBathroom,
		BaseMinutes: in.BaseMinutes, MinutesPerRoom: in.MinutesPerRoom, IsActive: active,
	})
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, svc)
	return nil
}
