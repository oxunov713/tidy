package httpapi

import (
	"net/http"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

func (s *Server) setOnline(w http.ResponseWriter, r *http.Request) error {
	var in struct {
		Online bool     `json:"online"`
		Lat    *float64 `json:"lat"`
		Lng    *float64 `json:"lng"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	if err := s.cleaners.SetOnline(r.Context(), principal(r), in.Online, in.Lat, in.Lng); err != nil {
		return err
	}
	return noContent(w)
}

func (s *Server) listOffers(w http.ResponseWriter, r *http.Request) error {
	offers, err := s.dispatch.OpenOffers(r.Context(), principal(r))
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, offers)
	return nil
}

func (s *Server) acceptOffer(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	b, err := s.dispatch.Accept(r.Context(), principal(r), id)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, b)
	return nil
}

func (s *Server) declineOffer(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	if err := s.dispatch.Decline(r.Context(), principal(r), id); err != nil {
		return err
	}
	return noContent(w)
}

func (s *Server) listJobs(w http.ResponseWriter, r *http.Request) error {
	q := newQuery(r)
	from, to := q.time("from"), q.time("to")
	if err := q.err(); err != nil {
		return err
	}
	jobs, err := s.cleaners.Jobs(r.Context(), principal(r), from, to)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, jobs)
	return nil
}

func (s *Server) setJobStatus(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	var in struct {
		Status domain.BookingStatus `json:"status"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	b, err := s.cleaners.UpdateJobStatus(r.Context(), principal(r), id, in.Status)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, b)
	return nil
}

func (s *Server) getAvailability(w http.ResponseWriter, r *http.Request) error {
	list, err := s.cleaners.Availability(r.Context(), principal(r))
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, list)
	return nil
}

func (s *Server) putAvailability(w http.ResponseWriter, r *http.Request) error {
	var in []domain.Availability
	if err := decode(w, r, &in); err != nil {
		return err
	}
	list, err := s.cleaners.SetAvailability(r.Context(), principal(r), in)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, list)
	return nil
}

func (s *Server) earnings(w http.ResponseWriter, r *http.Request) error {
	e, err := s.cleaners.Earnings(r.Context(), principal(r), r.URL.Query().Get("period"))
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, e)
	return nil
}
