// Package realtime is the WebSocket hub. Apps subscribe to rooms and get
// booking status, offers, chat messages and the cleaner's live location.
//
// The hub is in memory, which is fine for one instance. With several
// instances the fan-out would move to Postgres LISTEN/NOTIFY; the message
// format would stay the same.
package realtime

import (
	"context"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"
	"strings"
	"sync"
	"time"

	"github.com/coder/websocket"
	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

const (
	roomOffers        = "cleaner:offers"
	bookingRoomPrefix = "booking:"

	maxMessageBytes = 4 << 10
	sendBuffer      = 32
	writeTimeout    = 10 * time.Second
	checkTimeout    = 5 * time.Second

	reasonAccessRevoked = "access_revoked"
)

func bookingRoom(id uuid.UUID) string { return bookingRoomPrefix + id.String() }

// Authenticator turns the token from the URL into a caller.
type Authenticator func(token string) (service.Principal, error)

// Backend answers the questions the hub can't answer alone.
type Backend interface {
	CanWatch(ctx context.Context, userID, bookingID uuid.UUID) (bool, error)
	RecordLocation(ctx context.Context, cleanerID, bookingID uuid.UUID, lat, lng float64) (int, error)
}

type Options struct {
	OriginPatterns []string
	// PingInterval is how often the server pings. A connection that hasn't
	// answered within PongTimeout is dropped.
	PingInterval time.Duration
	PongTimeout  time.Duration
}

type Hub struct {
	auth Authenticator
	opts Options
	log  *slog.Logger

	mu      sync.RWMutex
	rooms   map[string]map[*client]struct{}
	clients map[*client]struct{}
}

func NewHub(auth Authenticator, opts Options, log *slog.Logger) *Hub {
	if opts.PingInterval == 0 {
		opts.PingInterval = 30 * time.Second
	}
	if opts.PongTimeout == 0 {
		opts.PongTimeout = 30 * time.Second
	}
	return &Hub{
		auth:    auth,
		opts:    opts,
		log:     log,
		rooms:   make(map[string]map[*client]struct{}),
		clients: make(map[*client]struct{}),
	}
}

// Close disconnects everyone. http.Server.Shutdown doesn't wait for
// hijacked connections, so main calls this on shutdown.
func (h *Hub) Close() {
	h.mu.RLock()
	defer h.mu.RUnlock()
	for c := range h.clients {
		c.cancel()
	}
}

type client struct {
	service.Principal
	send    chan []byte
	rooms   map[string]bool // guarded by Hub.mu
	cancel  context.CancelFunc
	backend Backend
}

// Handler serves GET /ws?token=<access token>.
func (h *Hub) Handler(backend Backend) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token := r.URL.Query().Get("token")
		if token == "" {
			token = strings.TrimPrefix(r.Header.Get("Authorization"), "Bearer ")
		}
		p, err := h.auth(token)
		if err != nil {
			http.Error(w, `{"error":{"code":"unauthorized","message":"Please sign in again."}}`, http.StatusUnauthorized)
			return
		}
		conn, err := websocket.Accept(w, r, &websocket.AcceptOptions{OriginPatterns: h.opts.OriginPatterns})
		if err != nil {
			h.log.Debug("websocket accept", "err", err)
			return
		}
		h.serve(r.Context(), conn, p, backend)
	})
}

func (h *Hub) serve(parent context.Context, conn *websocket.Conn, p service.Principal, backend Backend) {
	ctx, cancel := context.WithCancel(parent)
	defer cancel()
	defer conn.CloseNow()
	conn.SetReadLimit(maxMessageBytes)

	c := &client{Principal: p, send: make(chan []byte, sendBuffer), rooms: map[string]bool{}, cancel: cancel, backend: backend}
	h.register(c)
	defer h.unregister(c)

	go h.writeLoop(ctx, conn, c)
	go h.pingLoop(ctx, conn, c)

	for {
		_, data, err := conn.Read(ctx)
		if err != nil {
			if websocket.CloseStatus(err) == -1 && ctx.Err() == nil {
				h.log.Debug("websocket read", "user_id", p.UserID, "err", err)
			}
			return
		}
		var in inbound
		if err := json.Unmarshal(data, &in); err != nil {
			c.reply(errorMessage(domain.Invalid("message", "must be JSON with a type")))
			continue
		}
		h.handle(ctx, c, in, backend)
	}
}

func (h *Hub) writeLoop(ctx context.Context, conn *websocket.Conn, c *client) {
	for {
		select {
		case <-ctx.Done():
			return
		case msg := <-c.send:
			wctx, cancel := context.WithTimeout(ctx, writeTimeout)
			err := conn.Write(wctx, websocket.MessageText, msg)
			cancel()
			if err != nil {
				c.cancel()
				return
			}
		}
	}
}

func (h *Hub) pingLoop(ctx context.Context, conn *websocket.Conn, c *client) {
	t := time.NewTicker(h.opts.PingInterval)
	defer t.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-t.C:
			pctx, cancel := context.WithTimeout(ctx, h.opts.PongTimeout)
			err := conn.Ping(pctx)
			cancel()
			if err != nil {
				h.log.Debug("dropping silent websocket", "user_id", c.UserID)
				c.cancel()
				return
			}
		}
	}
}

func (h *Hub) handle(ctx context.Context, c *client, in inbound, backend Backend) {
	switch in.Type {
	case "subscribe":
		if err := h.authorize(ctx, c, in.Room, backend); err != nil {
			c.reply(errorMessage(err))
			return
		}
		h.join(c, in.Room)
		c.reply(roomAck{Type: "subscribed", Room: in.Room})
	case "unsubscribe":
		h.leave(c, in.Room)
		c.reply(roomAck{Type: "unsubscribed", Room: in.Room})
	case "location":
		if c.Role != domain.RoleCleaner {
			c.reply(errorMessage(domain.Forbidden("Only cleaners share their location.")))
			return
		}
		eta, err := backend.RecordLocation(ctx, c.UserID, in.BookingID, in.Lat, in.Lng)
		if err != nil {
			c.reply(errorMessage(err))
			return
		}
		h.toRoom(bookingRoom(in.BookingID), cleanerLocation{
			Type: "cleaner.location", BookingID: in.BookingID, Lat: in.Lat, Lng: in.Lng, ETAMinutes: eta,
		}, nil)
	default:
		c.reply(errorMessage(domain.Invalid("type", "must be subscribe, unsubscribe or location")))
	}
}

func (h *Hub) authorize(ctx context.Context, c *client, room string, backend Backend) error {
	if room == roomOffers {
		if c.Role != domain.RoleCleaner {
			return domain.Forbidden("Only cleaners receive offers.")
		}
		return nil
	}
	id, ok := strings.CutPrefix(room, bookingRoomPrefix)
	bookingID, err := uuid.Parse(id)
	if !ok || err != nil {
		return domain.Invalid("room", "must be booking:<id> or cleaner:offers")
	}
	allowed, err := backend.CanWatch(ctx, c.UserID, bookingID)
	if err != nil {
		h.log.Error("websocket room check", "room", room, "err", err)
		return errors.New("internal error")
	}
	if !allowed {
		return domain.Forbidden("Only the client and the assigned cleaner can follow this booking.")
	}
	return nil
}

func (h *Hub) join(c *client, room string) {
	h.mu.Lock()
	defer h.mu.Unlock()
	members, ok := h.rooms[room]
	if !ok {
		members = make(map[*client]struct{})
		h.rooms[room] = members
	}
	members[c] = struct{}{}
	c.rooms[room] = true
}

func (h *Hub) leave(c *client, room string) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.removeLocked(c, room)
}

func (h *Hub) register(c *client) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.clients[c] = struct{}{}
}

func (h *Hub) unregister(c *client) {
	h.mu.Lock()
	defer h.mu.Unlock()
	for room := range c.rooms {
		h.removeLocked(c, room)
	}
	delete(h.clients, c)
}

func (h *Hub) removeLocked(c *client, room string) {
	delete(c.rooms, room)
	if members, ok := h.rooms[room]; ok {
		delete(members, c)
		if len(members) == 0 {
			delete(h.rooms, room)
		}
	}
}

// toRoom sends msg to every member of room that passes only (nil means all).
func (h *Hub) toRoom(room string, msg any, only func(*client) bool) {
	b, ok := h.encode(msg)
	if !ok {
		return
	}
	for _, c := range h.members(room) {
		if only == nil || only(c) {
			c.deliver(b)
		}
	}
}

// toBookingRoom checks every member's access again before sending, so
// someone who lost access through a path that didn't evict them (a direct
// database change, a missed event) still gets nothing.
func (h *Hub) toBookingRoom(bookingID uuid.UUID, msg any) {
	b, ok := h.encode(msg)
	if !ok {
		return
	}
	room := bookingRoom(bookingID)
	for _, c := range h.members(room) {
		if c.backend != nil {
			ctx, cancel := context.WithTimeout(context.Background(), checkTimeout)
			allowed, err := c.backend.CanWatch(ctx, c.UserID, bookingID)
			cancel()
			if err != nil {
				h.log.Error("websocket room recheck", "room", room, "err", err)
				continue
			}
			if !allowed {
				h.evict(c, room)
				continue
			}
		}
		c.deliver(b)
	}
}

func (h *Hub) encode(msg any) ([]byte, bool) {
	b, err := json.Marshal(msg)
	if err != nil {
		h.log.Error("encode websocket message", "err", err)
		return nil, false
	}
	return b, true
}

// members is a snapshot, so slow access checks run without the lock.
func (h *Hub) members(room string) []*client {
	h.mu.RLock()
	defer h.mu.RUnlock()
	out := make([]*client, 0, len(h.rooms[room]))
	for c := range h.rooms[room] {
		out = append(out, c)
	}
	return out
}

// evict removes c from room and tells the app why.
func (h *Hub) evict(c *client, room string) {
	h.mu.Lock()
	member := c.rooms[room]
	h.removeLocked(c, room)
	h.mu.Unlock()
	if member {
		c.reply(roomAck{Type: "unsubscribed", Room: room, Reason: reasonAccessRevoked})
	}
}

func (c *client) reply(msg any) {
	b, err := json.Marshal(msg)
	if err != nil {
		return
	}
	c.deliver(b)
}

// deliver queues b. A client that can't keep up is disconnected instead of
// slowing others.
func (c *client) deliver(b []byte) {
	select {
	case c.send <- b:
	default:
		c.cancel()
	}
}

func cleanerOnly(id uuid.UUID) func(*client) bool {
	return func(c *client) bool { return c.UserID == id }
}

// The methods below implement service.Events.

func (h *Hub) BookingStatus(b domain.Booking, at time.Time) {
	h.toBookingRoom(b.ID, bookingStatus{Type: "booking.status", BookingID: b.ID, Status: b.Status, At: at})
}

func (h *Hub) OfferNew(cleanerID uuid.UUID, b domain.Booking, expiresAt time.Time) {
	h.toRoom(roomOffers, offerNew{Type: "offer.new", Booking: b, ExpiresAt: expiresAt}, cleanerOnly(cleanerID))
}

func (h *Hub) OfferGone(cleanerID, bookingID uuid.UUID) {
	h.toRoom(roomOffers, offerGone{Type: "offer.gone", BookingID: bookingID}, cleanerOnly(cleanerID))
}

func (h *Hub) MessageNew(bookingID uuid.UUID, m domain.Message) {
	h.toBookingRoom(bookingID, messageNew{Type: "message.new", BookingID: bookingID, Message: m})
}

func (h *Hub) BookingAccessRevoked(bookingID, userID uuid.UUID) {
	room := bookingRoom(bookingID)
	for _, c := range h.members(room) {
		if c.UserID == userID {
			h.evict(c, room)
		}
	}
}

var _ service.Events = (*Hub)(nil)
