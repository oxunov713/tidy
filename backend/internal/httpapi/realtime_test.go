package httpapi_test

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/coder/websocket"
	"github.com/google/uuid"
)

type wsConn struct {
	t    *testing.T
	conn *websocket.Conn
}

func (e *testEnv) ws(token string) *wsConn {
	e.t.Helper()
	ctx, cancel := context.WithTimeout(e.t.Context(), 5*time.Second)
	defer cancel()
	url := "ws" + strings.TrimPrefix(e.url, "http") + "/ws?token=" + token
	conn, _, err := websocket.Dial(ctx, url, nil)
	if err != nil {
		e.t.Fatalf("dial websocket: %v", err)
	}
	e.t.Cleanup(func() { conn.CloseNow() })
	return &wsConn{t: e.t, conn: conn}
}

func (w *wsConn) send(msg any) {
	w.t.Helper()
	b, _ := json.Marshal(msg)
	if err := w.conn.Write(w.t.Context(), websocket.MessageText, b); err != nil {
		w.t.Fatalf("write: %v", err)
	}
}

func (w *wsConn) receive() map[string]any {
	w.t.Helper()
	ctx, cancel := context.WithTimeout(w.t.Context(), 5*time.Second)
	defer cancel()
	_, data, err := w.conn.Read(ctx)
	if err != nil {
		w.t.Fatalf("read: %v", err)
	}
	var m map[string]any
	if err := json.Unmarshal(data, &m); err != nil {
		w.t.Fatalf("decode %s: %v", data, err)
	}
	return m
}

// receiveType skips other messages until one of type typ arrives.
func (w *wsConn) receiveType(typ string) map[string]any {
	w.t.Helper()
	for {
		if m := w.receive(); m["type"] == typ {
			return m
		}
	}
}

// silent waits a moment for a message that should not come. The library
// closes the connection when the read times out, so call it last.
func (w *wsConn) silent() {
	w.t.Helper()
	ctx, cancel := context.WithTimeout(w.t.Context(), 300*time.Millisecond)
	defer cancel()
	if _, data, err := w.conn.Read(ctx); err == nil {
		w.t.Errorf("want no message, got %s", data)
	}
}

func (w *wsConn) join(bookingID uuid.UUID) {
	w.t.Helper()
	w.send(map[string]any{"type": "subscribe", "room": "booking:" + bookingID.String()})
	if got := w.receive(); got["type"] != "subscribed" {
		w.t.Fatalf("want subscribed, got %v", got)
	}
}

func wantRevoked(t *testing.T, got map[string]any, bookingID uuid.UUID) {
	t.Helper()
	if got["room"] != "booking:"+bookingID.String() || got["reason"] != "access_revoked" {
		t.Errorf("got %v, want unsubscribed from booking:%s with reason access_revoked", got, bookingID)
	}
}

func TestReassignEvictsOldCleaner(t *testing.T) {
	e := newEnv(t)
	old := e.cleaner("+447700901201", 51.5200, -0.1550, true)
	next := e.cleaner("+447700901202", 51.5000, -0.1000, false)
	admin := e.admin("+447700901203")
	c := e.client("+447700901301")
	b := e.book(c, tomorrowAt(10))
	e.expect(e.do("POST", "/cleaner/offers/"+b.ID.String()+"/accept", old.AccessToken, nil), http.StatusOK)

	watcher := e.ws(c.AccessToken)
	watcher.join(b.ID)
	oldWS := e.ws(old.AccessToken)
	oldWS.join(b.ID)

	e.expect(e.do("PATCH", "/admin/bookings/"+b.ID.String(), admin.AccessToken, map[string]any{"cleaner_id": next.ID}), http.StatusOK)
	wantRevoked(t, oldWS.receiveType("unsubscribed"), b.ID)

	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/messages", c.AccessToken, map[string]string{"body": "Door code is 1234"}), http.StatusCreated)
	watcher.receiveType("message.new")

	nextWS := e.ws(next.AccessToken)
	nextWS.join(b.ID)
	nextWS.send(map[string]any{"type": "location", "booking_id": b.ID, "lat": 51.52, "lng": -0.15})
	watcher.receiveType("cleaner.location")
	oldWS.silent()

	// The old cleaner can't come back or report a position either. The
	// silence check closed the first connection.
	oldWS = e.ws(old.AccessToken)
	oldWS.send(map[string]any{"type": "subscribe", "room": "booking:" + b.ID.String()})
	if got := oldWS.receive(); got["type"] != "error" || got["code"] != "forbidden" {
		t.Errorf("old cleaner rejoining: got %v, want forbidden", got)
	}
	oldWS.send(map[string]any{"type": "location", "booking_id": b.ID, "lat": 51.52, "lng": -0.15})
	if got := oldWS.receive(); got["type"] != "error" || got["code"] != "forbidden" {
		t.Errorf("old cleaner location: got %v, want forbidden", got)
	}
}

func TestCancelEvictsCleaner(t *testing.T) {
	e := newEnv(t)
	cl := e.cleaner("+447700901204", 51.5200, -0.1550, true)
	c := e.client("+447700901302")
	b := e.book(c, tomorrowAt(15))
	e.expect(e.do("POST", "/cleaner/offers/"+b.ID.String()+"/accept", cl.AccessToken, nil), http.StatusOK)

	watcher := e.ws(c.AccessToken)
	watcher.join(b.ID)
	cleanerWS := e.ws(cl.AccessToken)
	cleanerWS.join(b.ID)

	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/cancel", c.AccessToken, nil), http.StatusOK)
	if got := watcher.receiveType("booking.status"); got["status"] != "cancelled" {
		t.Errorf("client got %v, want the cancelled status", got)
	}
	wantRevoked(t, cleanerWS.receiveType("unsubscribed"), b.ID)
}

func TestFanOutSkipsCleanerWhoLostAccess(t *testing.T) {
	e := newEnv(t)
	cl := e.cleaner("+447700901205", 51.5200, -0.1550, true)
	c := e.client("+447700901303")
	b := e.book(c, tomorrowAt(13))
	e.expect(e.do("POST", "/cleaner/offers/"+b.ID.String()+"/accept", cl.AccessToken, nil), http.StatusOK)

	cleanerWS := e.ws(cl.AccessToken)
	cleanerWS.join(b.ID)

	// Taken away behind the API's back, so no eviction event is sent.
	if _, err := e.store.Pool().Exec(t.Context(),
		`UPDATE bookings SET cleaner_id = NULL, status = 'confirmed' WHERE id = $1`, b.ID); err != nil {
		t.Fatal(err)
	}
	e.expect(e.do("POST", "/bookings/"+b.ID.String()+"/messages", c.AccessToken, map[string]string{"body": "Are you coming?"}), http.StatusCreated)
	wantRevoked(t, cleanerWS.receive(), b.ID)
	cleanerWS.silent()
}
