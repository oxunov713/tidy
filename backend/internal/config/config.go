// Package config reads the service settings from environment variables.
package config

import (
	"errors"
	"fmt"
	"log/slog"
	"os"
	"strconv"
	"strings"
	"time"
)

type Config struct {
	Env      string // development or production
	HTTPAddr string
	LogLevel slog.Level

	DatabaseURL string
	AutoMigrate bool

	JWTSecret       string
	AccessTokenTTL  time.Duration
	RefreshTokenTTL time.Duration

	// Location is the time zone for working hours and "today" in reports.
	Location *time.Location
	// DispatchRadiusKm limits which cleaners see a job and which slots are offered.
	DispatchRadiusKm float64

	PaymentProvider     string // mock or stripe
	StripeSecretKey     string
	StripeWebhookSecret string

	PushProvider          string // log or fcm
	FCMServiceAccountJSON string

	CORSAllowedOrigins []string
	WSOriginPatterns   []string
}

func (c Config) IsDevelopment() bool { return c.Env == "development" }

// Load reads the environment. Every variable is listed in .env.example.
func Load() (Config, error) {
	var errs []error
	get := func(key, def string) string {
		if v, ok := os.LookupEnv(key); ok && v != "" {
			return v
		}
		return def
	}
	duration := func(key, def string) time.Duration {
		d, err := time.ParseDuration(get(key, def))
		if err != nil {
			errs = append(errs, fmt.Errorf("%s: %w", key, err))
		}
		return d
	}
	boolean := func(key string, def bool) bool {
		b, err := strconv.ParseBool(get(key, strconv.FormatBool(def)))
		if err != nil {
			errs = append(errs, fmt.Errorf("%s: %w", key, err))
		}
		return b
	}

	c := Config{
		Env:                   get("APP_ENV", "development"),
		HTTPAddr:              get("HTTP_ADDR", ":8080"),
		DatabaseURL:           get("DATABASE_URL", ""),
		AutoMigrate:           boolean("AUTO_MIGRATE", false),
		JWTSecret:             get("JWT_SECRET", ""),
		AccessTokenTTL:        duration("ACCESS_TOKEN_TTL", "15m"),
		RefreshTokenTTL:       duration("REFRESH_TOKEN_TTL", "720h"),
		PaymentProvider:       get("PAYMENT_PROVIDER", "mock"),
		StripeSecretKey:       get("STRIPE_SECRET_KEY", ""),
		StripeWebhookSecret:   get("STRIPE_WEBHOOK_SECRET", ""),
		PushProvider:          get("PUSH_PROVIDER", "log"),
		FCMServiceAccountJSON: get("FCM_SERVICE_ACCOUNT_JSON", ""),
		CORSAllowedOrigins:    list(get("CORS_ALLOWED_ORIGINS", "http://localhost:*")),
		WSOriginPatterns:      list(get("WS_ORIGIN_PATTERNS", "localhost:*")),
	}

	if err := c.LogLevel.UnmarshalText([]byte(get("LOG_LEVEL", "info"))); err != nil {
		errs = append(errs, fmt.Errorf("LOG_LEVEL: %w", err))
	}
	radius, err := strconv.ParseFloat(get("DISPATCH_RADIUS_KM", "15"), 64)
	if err != nil || radius <= 0 {
		errs = append(errs, errors.New("DISPATCH_RADIUS_KM: must be a positive number"))
	}
	c.DispatchRadiusKm = radius
	if c.Location, err = time.LoadLocation(get("TIMEZONE", "Europe/London")); err != nil {
		errs = append(errs, fmt.Errorf("TIMEZONE: %w", err))
	}

	errs = append(errs, c.validate()...)
	return c, errors.Join(errs...)
}

func (c Config) validate() []error {
	var errs []error
	if c.Env != "development" && c.Env != "production" {
		errs = append(errs, errors.New("APP_ENV: must be development or production"))
	}
	if c.DatabaseURL == "" {
		errs = append(errs, errors.New("DATABASE_URL: required"))
	}
	if len(c.JWTSecret) < 32 {
		errs = append(errs, errors.New("JWT_SECRET: must be at least 32 characters"))
	}
	switch c.PaymentProvider {
	case "mock":
		if !c.IsDevelopment() {
			errs = append(errs, errors.New("PAYMENT_PROVIDER: mock is only allowed in development"))
		}
	case "stripe":
		if c.StripeSecretKey == "" || c.StripeWebhookSecret == "" {
			errs = append(errs, errors.New("STRIPE_SECRET_KEY and STRIPE_WEBHOOK_SECRET: required for stripe"))
		}
	default:
		errs = append(errs, errors.New("PAYMENT_PROVIDER: must be mock or stripe"))
	}
	switch c.PushProvider {
	case "log":
	case "fcm":
		if c.FCMServiceAccountJSON == "" {
			errs = append(errs, errors.New("FCM_SERVICE_ACCOUNT_JSON: required for fcm"))
		}
	default:
		errs = append(errs, errors.New("PUSH_PROVIDER: must be log or fcm"))
	}
	return errs
}

func list(s string) []string {
	var out []string
	for _, part := range strings.Split(s, ",") {
		if part = strings.TrimSpace(part); part != "" {
			out = append(out, part)
		}
	}
	return out
}
