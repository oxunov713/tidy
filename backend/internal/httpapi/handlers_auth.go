package httpapi

import (
	"net/http"
	"net/url"

	"github.com/go-chi/chi/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

func (s *Server) requestOTP(w http.ResponseWriter, r *http.Request) error {
	var in struct {
		Phone string `json:"phone"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	if err := s.auth.RequestCode(r.Context(), in.Phone); err != nil {
		return err
	}
	return noContent(w)
}

func (s *Server) verifyOTP(w http.ResponseWriter, r *http.Request) error {
	var in struct {
		Phone string      `json:"phone"`
		Code  string      `json:"code"`
		Role  domain.Role `json:"role"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	session, err := s.auth.Verify(r.Context(), in.Phone, in.Code, in.Role)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, session)
	return nil
}

type refreshRequest struct {
	RefreshToken string `json:"refresh_token"`
}

func (s *Server) refresh(w http.ResponseWriter, r *http.Request) error {
	var in refreshRequest
	if err := decode(w, r, &in); err != nil {
		return err
	}
	session, err := s.auth.Refresh(r.Context(), in.RefreshToken)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, session)
	return nil
}

func (s *Server) logout(w http.ResponseWriter, r *http.Request) error {
	var in refreshRequest
	if err := decode(w, r, &in); err != nil {
		return err
	}
	if err := s.auth.Logout(r.Context(), in.RefreshToken); err != nil {
		return err
	}
	return noContent(w)
}

func (s *Server) getMe(w http.ResponseWriter, r *http.Request) error {
	me, err := s.users.Me(r.Context(), principal(r))
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, me)
	return nil
}

func (s *Server) patchMe(w http.ResponseWriter, r *http.Request) error {
	var in struct {
		FullName *string `json:"full_name"`
		Email    *string `json:"email"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	me, err := s.users.UpdateMe(r.Context(), principal(r), service.ProfileUpdate{FullName: in.FullName, Email: in.Email})
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, me)
	return nil
}

func (s *Server) registerDevice(w http.ResponseWriter, r *http.Request) error {
	var in struct {
		Token    string                `json:"token"`
		Platform domain.DevicePlatform `json:"platform"`
	}
	if err := decode(w, r, &in); err != nil {
		return err
	}
	if err := s.users.RegisterDevice(r.Context(), principal(r), in.Token, in.Platform); err != nil {
		return err
	}
	return noContent(w)
}

func (s *Server) removeDevice(w http.ResponseWriter, r *http.Request) error {
	token, err := url.PathUnescape(chi.URLParam(r, "token"))
	if err != nil {
		return domain.Invalid("token", "is not a valid path segment")
	}
	if err := s.users.RemoveDevice(r.Context(), principal(r), token); err != nil {
		return err
	}
	return noContent(w)
}

func (s *Server) listAddresses(w http.ResponseWriter, r *http.Request) error {
	list, err := s.users.Addresses(r.Context(), principal(r))
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, list)
	return nil
}

func (s *Server) createAddress(w http.ResponseWriter, r *http.Request) error {
	var in domain.Address
	if err := decode(w, r, &in); err != nil {
		return err
	}
	a, err := s.users.AddAddress(r.Context(), principal(r), in)
	if err != nil {
		return err
	}
	writeJSON(w, http.StatusCreated, a)
	return nil
}

func (s *Server) deleteAddress(w http.ResponseWriter, r *http.Request) error {
	id, err := pathID(r, "id")
	if err != nil {
		return err
	}
	if err := s.users.DeleteAddress(r.Context(), principal(r), id); err != nil {
		return err
	}
	return noContent(w)
}

// serviceCard is the public view of a service in the catalogue.
type serviceCard struct {
	ID        string `json:"id"`
	Slug      string `json:"slug"`
	Title     string `json:"title"`
	FromPrice int    `json:"from_price"`
	Minutes   int    `json:"minutes"`
}

func (s *Server) listServices(w http.ResponseWriter, r *http.Request) error {
	list, err := s.catalogue.Services(r.Context())
	if err != nil {
		return err
	}
	out := make([]serviceCard, len(list))
	for i, svc := range list {
		out[i] = serviceCard{ID: svc.ID.String(), Slug: svc.Slug, Title: svc.Title, FromPrice: svc.BasePrice, Minutes: svc.BaseMinutes}
	}
	writeJSON(w, http.StatusOK, out)
	return nil
}

type extraCard struct {
	ID    string `json:"id"`
	Slug  string `json:"slug"`
	Title string `json:"title"`
	Price int    `json:"price"`
}

func (s *Server) listExtras(w http.ResponseWriter, r *http.Request) error {
	list, err := s.catalogue.Extras(r.Context())
	if err != nil {
		return err
	}
	out := make([]extraCard, len(list))
	for i, e := range list {
		out[i] = extraCard{ID: e.ID.String(), Slug: e.Slug, Title: e.Title, Price: e.Price}
	}
	writeJSON(w, http.StatusOK, out)
	return nil
}
