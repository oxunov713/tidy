package httpapi

import (
	"context"
	"log/slog"
	"net"
	"net/http"
	"strings"
	"sync"
	"time"

	"github.com/go-chi/chi/v5/middleware"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

type ctxKey int

const principalKey ctxKey = iota

func principal(r *http.Request) service.Principal {
	p, _ := r.Context().Value(principalKey).(service.Principal)
	return p
}

// requestLogger logs one line per request with its id, status and duration.
func requestLogger(log *slog.Logger) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()
			ww := middleware.NewWrapResponseWriter(w, r.ProtoMajor)
			reqID := middleware.GetReqID(r.Context())
			ww.Header().Set("X-Request-Id", reqID)
			next.ServeHTTP(ww, r)

			level := slog.LevelInfo
			if ww.Status() >= 500 {
				level = slog.LevelError
			}
			log.LogAttrs(r.Context(), level, "http request",
				slog.String("request_id", reqID),
				slog.String("method", r.Method),
				slog.String("path", r.URL.Path),
				slog.Int("status", ww.Status()),
				slog.Int("bytes", ww.BytesWritten()),
				slog.Duration("duration", time.Since(start)),
			)
		})
	}
}

// authenticate requires a valid access token and stores the caller in the context.
func (s *Server) authenticate(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token, ok := strings.CutPrefix(r.Header.Get("Authorization"), "Bearer ")
		if !ok || token == "" {
			s.writeError(w, r, domain.ErrUnauthorized)
			return
		}
		p, err := s.auth.ParseAccessToken(token)
		if err != nil {
			s.writeError(w, r, err)
			return
		}
		next.ServeHTTP(w, r.WithContext(context.WithValue(r.Context(), principalKey, p)))
	})
}

func (s *Server) requireRole(roles ...domain.Role) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			p := principal(r)
			for _, role := range roles {
				if p.Role == role {
					next.ServeHTTP(w, r)
					return
				}
			}
			s.writeError(w, r, domain.Forbidden("Your account can't use this."))
		})
	}
}

// rateLimiter allows a fixed number of requests per client IP per window.
// It protects the login endpoints on top of the per-phone OTP limits.
type rateLimiter struct {
	limit  int
	window time.Duration

	mu      sync.Mutex
	started time.Time
	counts  map[string]int
}

func newRateLimiter(limit int, window time.Duration) *rateLimiter {
	return &rateLimiter{limit: limit, window: window, counts: map[string]int{}}
}

func (l *rateLimiter) allow(key string, now time.Time) bool {
	l.mu.Lock()
	defer l.mu.Unlock()
	// A fixed window is crude but needs no cleanup goroutine.
	if now.Sub(l.started) >= l.window {
		l.started = now
		clear(l.counts)
	}
	l.counts[key]++
	return l.counts[key] <= l.limit
}

func (s *Server) limitByIP(l *rateLimiter) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// RemoteAddr, not X-Forwarded-For, which any caller can set.
			ip, _, err := net.SplitHostPort(r.RemoteAddr)
			if err != nil {
				ip = r.RemoteAddr
			}
			if !l.allow(ip, time.Now()) {
				s.writeError(w, r, domain.ErrTooManyRequests)
				return
			}
			next.ServeHTTP(w, r)
		})
	}
}
