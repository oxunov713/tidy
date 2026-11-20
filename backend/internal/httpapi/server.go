// Package httpapi is the REST API described in docs/API.md.
package httpapi

import (
	"context"
	"log/slog"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

type Server struct {
	auth      *service.Auth
	users     *service.Users
	catalogue *service.Catalogue
	bookings  *service.Bookings
	dispatch  *service.Dispatcher
	cleaners  *service.Cleaners
	admin     *service.Admin
	payments  *service.Payments
	ws        http.Handler
	health    func(context.Context) error
	log       *slog.Logger

	corsOrigins []string
	// Sign-in and token refresh have separate limits: apps refresh in the
	// background and must not lock their users out of signing in.
	authLimit    *rateLimiter
	refreshLimit *rateLimiter
}

type Deps struct {
	Auth        *service.Auth
	Users       *service.Users
	Catalogue   *service.Catalogue
	Bookings    *service.Bookings
	Dispatch    *service.Dispatcher
	Cleaners    *service.Cleaners
	Admin       *service.Admin
	Payments    *service.Payments
	WebSocket   http.Handler
	Health      func(context.Context) error
	Log         *slog.Logger
	CORSOrigins []string
}

func New(d Deps) *Server {
	return &Server{
		auth: d.Auth, users: d.Users, catalogue: d.Catalogue, bookings: d.Bookings,
		dispatch: d.Dispatch, cleaners: d.Cleaners, admin: d.Admin, payments: d.Payments,
		ws: d.WebSocket, health: d.Health, log: d.Log,
		corsOrigins:  d.CORSOrigins,
		authLimit:    newRateLimiter(30, time.Minute),
		refreshLimit: newRateLimiter(60, time.Minute),
	}
}

func (s *Server) Routes() http.Handler {
	r := chi.NewRouter()
	r.Use(middleware.RequestID)
	r.Use(requestLogger(s.log))
	r.Use(middleware.Recoverer)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins: s.corsOrigins,
		AllowedMethods: []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowedHeaders: []string{"Authorization", "Content-Type"},
		ExposedHeaders: []string{"X-Request-Id"},
		MaxAge:         300,
	}))

	r.Get("/healthz", s.handle(s.healthz))

	r.Route("/api/v1", func(r chi.Router) {
		// The WebSocket lives longer than any request timeout.
		r.Handle("/ws", s.ws)

		r.Group(func(r chi.Router) {
			r.Use(middleware.Timeout(15 * time.Second))

			r.Route("/auth", func(r chi.Router) {
				r.With(s.limitByIP(s.refreshLimit)).Post("/refresh", s.handle(s.refresh))
				r.Group(func(r chi.Router) {
					r.Use(s.limitByIP(s.authLimit))
					r.Post("/otp", s.handle(s.requestOTP))
					r.Post("/verify", s.handle(s.verifyOTP))
					r.Post("/logout", s.handle(s.logout))
				})
			})

			r.Get("/services", s.handle(s.listServices))
			r.Get("/extras", s.handle(s.listExtras))
			r.Post("/quotes", s.handle(s.quote))
			r.Post("/webhooks/stripe", s.handle(s.stripeWebhook))

			r.Group(func(r chi.Router) {
				r.Use(s.authenticate)
				s.meRoutes(r)
				s.bookingRoutes(r)
				r.Route("/cleaner", s.cleanerRoutes)
				r.Route("/admin", s.adminRoutes)
			})
		})
	})
	return r
}

func (s *Server) meRoutes(r chi.Router) {
	r.Get("/me", s.handle(s.getMe))
	r.Patch("/me", s.handle(s.patchMe))
	r.Post("/me/devices", s.handle(s.registerDevice))
	r.Get("/me/addresses", s.handle(s.listAddresses))
	r.Post("/me/addresses", s.handle(s.createAddress))
	r.Delete("/me/addresses/{id}", s.handle(s.deleteAddress))
}

func (s *Server) bookingRoutes(r chi.Router) {
	r.Group(func(r chi.Router) {
		r.Use(s.requireRole(domain.RoleClient))
		r.Get("/slots", s.handle(s.slots))
		r.Post("/bookings", s.handle(s.createBooking))
		r.Get("/bookings", s.handle(s.listBookings))
		r.Post("/bookings/{id}/cancel", s.handle(s.cancelBooking))
		r.Post("/bookings/{id}/payment", s.handle(s.payBooking))
		r.Post("/bookings/{id}/review", s.handle(s.reviewBooking))
		r.Get("/plans", s.handle(s.listPlans))
		r.Delete("/plans/{id}", s.handle(s.endPlan))
	})
	// Client, assigned cleaner or admin; the service checks which.
	r.Get("/bookings/{id}", s.handle(s.getBooking))
	r.Get("/bookings/{id}/messages", s.handle(s.listMessages))
	r.Post("/bookings/{id}/messages", s.handle(s.postMessage))
}

func (s *Server) cleanerRoutes(r chi.Router) {
	r.Use(s.requireRole(domain.RoleCleaner))
	r.Post("/online", s.handle(s.setOnline))
	r.Get("/offers", s.handle(s.listOffers))
	r.Post("/offers/{id}/accept", s.handle(s.acceptOffer))
	r.Post("/offers/{id}/decline", s.handle(s.declineOffer))
	r.Get("/jobs", s.handle(s.listJobs))
	r.Post("/jobs/{id}/status", s.handle(s.setJobStatus))
	r.Get("/availability", s.handle(s.getAvailability))
	r.Put("/availability", s.handle(s.putAvailability))
	r.Get("/earnings", s.handle(s.earnings))
}

func (s *Server) adminRoutes(r chi.Router) {
	r.Use(s.requireRole(domain.RoleAdmin))
	r.Get("/stats/today", s.handle(s.statsToday))
	r.Get("/bookings", s.handle(s.adminBookings))
	r.Patch("/bookings/{id}", s.handle(s.adminPatchBooking))
	r.Get("/cleaners", s.handle(s.adminCleaners))
	r.Post("/cleaners/{id}/approve", s.handle(s.setCleanerStatus(domain.CleanerApproved)))
	r.Post("/cleaners/{id}/suspend", s.handle(s.setCleanerStatus(domain.CleanerSuspended)))
	r.Get("/services", s.handle(s.adminServices))
	r.Put("/services/{id}", s.handle(s.updateService))
}

func (s *Server) healthz(w http.ResponseWriter, r *http.Request) error {
	if err := s.health(r.Context()); err != nil {
		return err
	}
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
	return nil
}
