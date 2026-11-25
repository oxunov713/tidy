package service

import (
	"context"
	"time"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// unassignedCutoff: a confirmed booking that still has no cleaner this close
// to the start is cancelled, so the client isn't left waiting at the door.
const unassignedCutoff = 2 * time.Hour

// SweepStuck cancels bookings that can no longer happen: pending ones the
// client didn't pay in time and confirmed ones nobody took before
// unassignedCutoff. Both are refunded. The scheduler calls it.
func (s *Bookings) SweepStuck(ctx context.Context) error {
	now := s.clock.now()
	stuck, err := s.store.CancelStuck(ctx, now, now.Add(unassignedCutoff))
	if err != nil {
		return err
	}
	for _, c := range stuck.Unpaid {
		s.afterCancel(ctx, c, true)
		s.notifyClient(c.Booking, "Booking cancelled", "We didn't receive the payment for booking "+c.Booking.Code+", so it was cancelled.")
	}
	for _, c := range stuck.Unassigned {
		s.afterCancel(ctx, c, true)
		s.notifyClient(c.Booking, "Booking cancelled", "Sorry, no cleaner was free for booking "+c.Booking.Code+". You have been refunded in full.")
	}
	return nil
}

func (s *Bookings) notifyClient(b domain.Booking, title, body string) {
	s.push.Notify(b.ClientID, domain.Notification{
		Title: title,
		Body:  body,
		Data:  map[string]string{"type": "booking.status", "booking_id": b.ID.String(), "status": string(b.Status)},
	})
}
