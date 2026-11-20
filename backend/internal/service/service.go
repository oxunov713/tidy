// Package service holds the use cases of Tidy. It depends only on domain
// and on the interfaces in ports.go.
package service

import (
	"context"
	"errors"
	"log/slog"
	"sync"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// Principal is the authenticated caller.
type Principal struct {
	UserID uuid.UUID
	Role   domain.Role
}

func (p Principal) IsAdmin() bool { return p.Role == domain.RoleAdmin }

// Page is one page of a cursor-paginated list.
type Page[T any] struct {
	Items      []T    `json:"items"`
	NextCursor string `json:"next_cursor"`
}

const (
	defaultPageSize = 20
	maxPageSize     = 50
)

func pageSize(limit int) int {
	if limit <= 0 {
		return defaultPageSize
	}
	return min(limit, maxPageSize)
}

// Clock returns the current time. Tests replace it to move time forward.
type Clock func() time.Time

func (c Clock) now() time.Time {
	if c == nil {
		return time.Now().UTC()
	}
	return c().UTC()
}

// Pusher sends push notifications in the background, so a slow push
// provider never delays an API response.
type Pusher struct {
	devices  DeviceStore
	notifier Notifier
	log      *slog.Logger
	wg       sync.WaitGroup
}

func NewPusher(devices DeviceStore, notifier Notifier, log *slog.Logger) *Pusher {
	return &Pusher{devices: devices, notifier: notifier, log: log}
}

func (p *Pusher) Notify(userID uuid.UUID, n domain.Notification) {
	p.wg.Add(1)
	go func() {
		defer p.wg.Done()
		ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
		defer cancel()

		tokens, err := p.devices.DeviceTokens(ctx, userID)
		if err != nil {
			p.log.Error("load device tokens", "user_id", userID, "err", err)
			return
		}
		for _, token := range tokens {
			err := p.notifier.Send(ctx, token, n)
			switch {
			case errors.Is(err, domain.ErrDeviceTokenGone):
				if err := p.devices.DeleteDevice(ctx, token); err != nil {
					p.log.Error("delete device token", "err", err)
				}
			case err != nil:
				p.log.Warn("send push", "user_id", userID, "err", err)
			}
		}
	}()
}

// Wait blocks until notifications in flight are sent. Called on shutdown.
func (p *Pusher) Wait() { p.wg.Wait() }
