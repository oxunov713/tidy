package realtime

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"log/slog"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/coder/websocket"
	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

var (
	clientID   = uuid.MustParse("00000000-0000-0000-0000-00000000000c")
	cleanerID  = uuid.MustParse("00000000-0000-0000-0000-0000000000c1")
	strangerID = uuid.MustParse("00000000-0000-0000-0000-0000000000ff")
	bookingID  = uuid.MustParse("00000000-0000-0000-0000-0000000000b1")
)

// fakeBackend: the client and the cleaner may watch bookingID, nobody else.
type fakeBackend struct{}

func (fakeBackend) CanWatch(_ context.Context, userID, id uuid.UUID) (bool, error) {
	return id == bookingID && (userID == clientID || userID == cleanerID), nil
}

func (fakeBackend) RecordLocation(_ context.Context, cleaner, id uuid.UUID, lat, lng float64) (int, error) {
	if cleaner != cleanerID || id != bookingID {
		return 0, domain.Forbidden("not your job")
	}
	return 12, nil
}

func fakeAuth(token string) (service.Principal, error) {
	switch token {
	case "client":
		return service.Principal{UserID: clientID, Role: domain.RoleClient}, nil
	case "cleaner":
		return service.Principal{UserID: cleanerID, Role: domain.RoleCleaner}, nil
	case "stranger":
		return service.Principal{UserID: strangerID, Role: domain.RoleClient}, nil
	}
	return service.Principal{}, errors.New("bad token")
}

func startHub(t *testing.T) (*Hub, string) {
	t.Helper()
	log := slog.New(slog.NewTextHandler(io.Discard, nil))
	hub := NewHub(fakeAuth, Options{}, log)
	srv := httptest.NewServer(hub.Handler(fakeBackend{}))
	t.Cleanup(func() {
		hub.Close()
		srv.Close()
	})
	return hub, "ws" + strings.TrimPrefix(srv.URL, "http")
}

func dial(t *testing.T, ctx context.Context, url, token string) *websocket.Conn {
	t.Helper()
	conn, _, err := websocket.Dial(ctx, url+"?token="+token, nil)
	if err != nil {
		t.Fatalf("dial as %s: %v", token, err)
	}
	t.Cleanup(func() { conn.CloseNow() })
	return conn
}

func send(t *testing.T, ctx context.Context, conn *websocket.Conn, msg any) {
	t.Helper()
	b, _ := json.Marshal(msg)
	if err := conn.Write(ctx, websocket.MessageText, b); err != nil {
		t.Fatalf("write: %v", err)
	}
}

func receive(t *testing.T, ctx context.Context, conn *websocket.Conn) map[string]any {
	t.Helper()
	_, data, err := conn.Read(ctx)
	if err != nil {
		t.Fatalf("read: %v", err)
	}
	var m map[string]any
	if err := json.Unmarshal(data, &m); err != nil {
		t.Fatalf("decode %s: %v", data, err)
	}
	return m
}

func TestLocationIsRelayedToBookingRoom(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	_, url := startHub(t)

	watcher := dial(t, ctx, url, "client")
	send(t, ctx, watcher, map[string]any{"type": "subscribe", "room": "booking:" + bookingID.String()})
	if got := receive(t, ctx, watcher); got["type"] != "subscribed" {
		t.Fatalf("want subscribed, got %v", got)
	}

	cleaner := dial(t, ctx, url, "cleaner")
	send(t, ctx, cleaner, map[string]any{"type": "location", "booking_id": bookingID, "lat": 51.52, "lng": -0.15})

	got := receive(t, ctx, watcher)
	want := map[string]any{
		"type": "cleaner.location", "booking_id": bookingID.String(),
		"lat": 51.52, "lng": -0.15, "eta_minutes": float64(12),
	}
	for k, v := range want {
		if got[k] != v {
			t.Errorf("%s = %v, want %v", k, got[k], v)
		}
	}
}

func TestSubscribeChecksAccess(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	_, url := startHub(t)

	tests := []struct {
		token, room string
		code        string
	}{
		{"stranger", "booking:" + bookingID.String(), "forbidden"},
		{"client", "cleaner:offers", "forbidden"},
		{"client", "lobby", "invalid_request"},
	}
	for _, tt := range tests {
		conn := dial(t, ctx, url, tt.token)
		send(t, ctx, conn, map[string]any{"type": "subscribe", "room": tt.room})
		got := receive(t, ctx, conn)
		if got["type"] != "error" || got["code"] != tt.code {
			t.Errorf("%s joining %s: got %v, want error %s", tt.token, tt.room, got, tt.code)
		}
	}
}

func TestOffersGoOnlyToThatCleaner(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	hub, url := startHub(t)

	conn := dial(t, ctx, url, "cleaner")
	send(t, ctx, conn, map[string]any{"type": "subscribe", "room": "cleaner:offers"})
	receive(t, ctx, conn)

	hub.OfferNew(uuid.New(), domain.Booking{ID: uuid.New()}, time.Now())
	hub.OfferNew(cleanerID, domain.Booking{ID: bookingID}, time.Now())

	got := receive(t, ctx, conn)
	booking, _ := got["booking"].(map[string]any)
	if got["type"] != "offer.new" || booking["id"] != bookingID.String() {
		t.Errorf("got %v, want the offer for %s only", got, bookingID)
	}
}

func TestRejectsBadToken(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	_, url := startHub(t)

	_, resp, err := websocket.Dial(ctx, url+"?token=nope", nil)
	if err == nil {
		t.Fatal("want dial error")
	}
	if resp == nil || resp.StatusCode != 401 {
		t.Errorf("want 401, got %v", resp)
	}
}
