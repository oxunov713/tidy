// Package push has the Notifier implementations.
package push

import (
	"context"
	"log/slog"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// Log writes notifications to the log. It is the default in development.
type Log struct {
	Log *slog.Logger
}

func (l Log) Send(_ context.Context, token string, n domain.Notification) error {
	l.Log.Info("push notification", "token", shorten(token), "title", n.Title, "body", n.Body, "data", n.Data)
	return nil
}

func shorten(token string) string {
	if len(token) <= 12 {
		return token
	}
	return token[:12] + "…"
}
