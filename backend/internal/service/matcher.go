package service

import (
	"context"
	"sort"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// matcher finds cleaners who could do a visit at an address. Slots and
// dispatch use the same rules, so a slot shown as free can be dispatched.
type matcher struct {
	store    CleanerStore
	loc      *time.Location
	radiusKm float64
}

type candidate struct {
	cleaner    domain.Cleaner
	distanceKm float64
	window     *domain.Availability
	busy       []domain.Period
}

// freeFor reports whether the cleaner works then and has nothing else booked.
func (c candidate) freeFor(visit domain.Period, loc *time.Location) bool {
	if c.window == nil || !c.window.Covers(visit.Start, visit.End, loc) {
		return false
	}
	for _, b := range c.busy {
		if b.Overlaps(visit) {
			return false
		}
	}
	return true
}

type matchQuery struct {
	lat, lng float64
	day      time.Time
	// onlineSince limits the search to cleaners online and seen since then.
	onlineSince *time.Time
	// only limits the search to one cleaner, e.g. "book Sarah again".
	only *uuid.UUID
}

// candidates returns cleaners within the radius who work on that day,
// nearest first. Distance is computed in Go: with a few hundred cleaners per
// city that is cheaper than maintaining a geo index.
func (m *matcher) candidates(ctx context.Context, q matchQuery) ([]candidate, error) {
	cleaners, err := m.store.ListApprovedCleaners(ctx, q.onlineSince)
	if err != nil {
		return nil, err
	}

	var out []candidate
	for _, c := range cleaners {
		if q.only != nil && c.UserID != *q.only {
			continue
		}
		if c.LastLat == nil || c.LastLng == nil {
			continue
		}
		d := domain.DistanceKm(q.lat, q.lng, *c.LastLat, *c.LastLng)
		if d > m.radiusKm {
			continue
		}
		out = append(out, candidate{cleaner: c, distanceKm: d})
	}
	if len(out) == 0 {
		return nil, nil
	}

	ids := make([]uuid.UUID, len(out))
	for i, c := range out {
		ids[i] = c.cleaner.UserID
	}
	day := q.day.In(m.loc)
	windows, err := m.store.AvailabilityFor(ctx, ids, domain.MondayIndex(day))
	if err != nil {
		return nil, err
	}
	dayStart := time.Date(day.Year(), day.Month(), day.Day(), 0, 0, 0, 0, m.loc)
	busy, err := m.store.BusyPeriods(ctx, ids, dayStart, dayStart.AddDate(0, 0, 1))
	if err != nil {
		return nil, err
	}

	working := out[:0]
	for _, c := range out {
		w, ok := windows[c.cleaner.UserID]
		if !ok {
			continue
		}
		c.window = &w
		c.busy = busy[c.cleaner.UserID]
		working = append(working, c)
	}
	sort.SliceStable(working, func(i, j int) bool { return working[i].distanceKm < working[j].distanceKm })
	return working, nil
}

// anyFree reports whether at least one candidate can take the visit.
func anyFree(cands []candidate, visit domain.Period, loc *time.Location) bool {
	for _, c := range cands {
		if c.freeFor(visit, loc) {
			return true
		}
	}
	return false
}
