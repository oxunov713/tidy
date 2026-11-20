// Command api runs the Tidy HTTP and WebSocket server.
package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
	_ "time/tzdata" // the distroless image has no zoneinfo

	"github.com/oxunov713/tidy/backend/internal/config"
	"github.com/oxunov713/tidy/backend/internal/httpapi"
	"github.com/oxunov713/tidy/backend/internal/payment"
	"github.com/oxunov713/tidy/backend/internal/push"
	"github.com/oxunov713/tidy/backend/internal/realtime"
	"github.com/oxunov713/tidy/backend/internal/scheduler"
	"github.com/oxunov713/tidy/backend/internal/service"
	"github.com/oxunov713/tidy/backend/internal/store/postgres"
)

const shutdownTimeout = 20 * time.Second

func main() {
	if err := run(); err != nil {
		slog.Error("api stopped", "err", err)
		os.Exit(1)
	}
}

func run() error {
	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("config: %w", err)
	}
	log := newLogger(cfg)

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	if cfg.AutoMigrate {
		if err := postgres.Migrate(cfg.DatabaseURL); err != nil {
			return err
		}
		log.Info("migrations applied")
	}
	store, err := postgres.Open(ctx, cfg.DatabaseURL)
	if err != nil {
		return err
	}
	defer store.Close()

	provider, err := paymentProvider(cfg)
	if err != nil {
		return err
	}
	notifier, err := pushNotifier(ctx, cfg, log)
	if err != nil {
		return err
	}

	loc, radius := cfg.Location, cfg.DispatchRadiusKm
	auth := service.NewAuth(store, service.LogCodeSender{Log: log, ShowCodes: cfg.IsDevelopment()}, service.AuthConfig{
		Secret:     []byte(cfg.JWTSecret),
		AccessTTL:  cfg.AccessTokenTTL,
		RefreshTTL: cfg.RefreshTokenTTL,
	}, nil)
	hub := realtime.NewHub(auth.ParseAccessToken, realtime.Options{OriginPatterns: cfg.WSOriginPatterns}, log)
	pusher := service.NewPusher(store, notifier, log)
	dispatch := service.NewDispatcher(store, store, hub, pusher, loc, radius, nil, log)
	payments := service.NewPayments(store, provider, dispatch, hub, pusher, nil, log)
	bookings := service.NewBookings(store, store, payments, hub, pusher, loc, radius, nil, log)
	cleaners := service.NewCleaners(store, payments, hub, pusher, loc, nil, log)
	admin := service.NewAdmin(store, bookings, dispatch, hub, pusher, loc, nil, log)

	api := httpapi.New(httpapi.Deps{
		Auth:        auth,
		Users:       service.NewUsers(store),
		Catalogue:   service.NewCatalogue(store),
		Bookings:    bookings,
		Dispatch:    dispatch,
		Cleaners:    cleaners,
		Admin:       admin,
		Payments:    payments,
		WebSocket:   hub.Handler(bookings),
		Health:      store.Ping,
		Log:         log,
		CORSOrigins: cfg.CORSAllowedOrigins,
	})
	srv := &http.Server{
		Addr:              cfg.HTTPAddr,
		Handler:           api.Routes(),
		ReadHeaderTimeout: 5 * time.Second,
		IdleTimeout:       2 * time.Minute,
	}

	var jobs sync.WaitGroup
	jobs.Add(1)
	go func() {
		defer jobs.Done()
		scheduler.New(bookings, dispatch, payments, log).Run(ctx)
	}()

	serveErr := make(chan error, 1)
	go func() {
		log.Info("api listening", "addr", cfg.HTTPAddr, "env", cfg.Env, "payments", provider.Name(), "push", cfg.PushProvider)
		serveErr <- srv.ListenAndServe()
	}()

	select {
	case err := <-serveErr:
		stop()
		jobs.Wait()
		return err
	case <-ctx.Done():
	}

	log.Info("shutting down")
	shutdownCtx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
	defer cancel()
	hub.Close()
	err = srv.Shutdown(shutdownCtx)
	jobs.Wait()
	pusher.Wait()
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		return fmt.Errorf("shutdown: %w", err)
	}
	log.Info("stopped")
	return nil
}

func newLogger(cfg config.Config) *slog.Logger {
	opts := &slog.HandlerOptions{Level: cfg.LogLevel}
	if cfg.IsDevelopment() {
		return slog.New(slog.NewTextHandler(os.Stdout, opts))
	}
	return slog.New(slog.NewJSONHandler(os.Stdout, opts))
}

func paymentProvider(cfg config.Config) (service.PaymentProvider, error) {
	switch cfg.PaymentProvider {
	case "stripe":
		return payment.NewStripe(cfg.StripeSecretKey, cfg.StripeWebhookSecret), nil
	case "mock":
		return payment.Mock{}, nil
	}
	return nil, fmt.Errorf("unknown payment provider %q", cfg.PaymentProvider)
}

func pushNotifier(ctx context.Context, cfg config.Config, log *slog.Logger) (service.Notifier, error) {
	switch cfg.PushProvider {
	case "fcm":
		return push.NewFCM(ctx, []byte(cfg.FCMServiceAccountJSON))
	case "log":
		return push.Log{Log: log}, nil
	}
	return nil, fmt.Errorf("unknown push provider %q", cfg.PushProvider)
}
