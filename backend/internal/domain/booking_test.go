package domain

import (
	"testing"
	"time"
)

func TestBookingTransitions(t *testing.T) {
	allowed := map[[2]BookingStatus]bool{
		{StatusPending, StatusConfirmed}:    true,
		{StatusPending, StatusCancelled}:    true,
		{StatusConfirmed, StatusAssigned}:   true,
		{StatusConfirmed, StatusCancelled}:  true,
		{StatusAssigned, StatusOnTheWay}:    true,
		{StatusAssigned, StatusCancelled}:   true,
		{StatusOnTheWay, StatusInProgress}:  true,
		{StatusInProgress, StatusCompleted}: true,
	}
	all := []BookingStatus{
		StatusPending, StatusConfirmed, StatusAssigned, StatusOnTheWay,
		StatusInProgress, StatusCompleted, StatusCancelled,
	}
	for _, from := range all {
		for _, to := range all {
			want := allowed[[2]BookingStatus{from, to}]
			if got := from.CanTransitionTo(to); got != want {
				t.Errorf("%s -> %s: got %v, want %v", from, to, got, want)
			}
		}
	}
}

func TestBookingStatusIsFinal(t *testing.T) {
	tests := []struct {
		status BookingStatus
		final  bool
	}{
		{StatusPending, false},
		{StatusInProgress, false},
		{StatusCompleted, true},
		{StatusCancelled, true},
	}
	for _, tt := range tests {
		if got := tt.status.IsFinal(); got != tt.final {
			t.Errorf("%s.IsFinal() = %v, want %v", tt.status, got, tt.final)
		}
	}
}

func TestCancellationIsFree(t *testing.T) {
	now := time.Date(2026, 12, 1, 10, 0, 0, 0, time.UTC)
	tests := []struct {
		name  string
		start time.Time
		free  bool
	}{
		{"two days ahead", now.Add(48 * time.Hour), true},
		{"exactly 24 hours", now.Add(24 * time.Hour), true},
		{"23 hours ahead", now.Add(23 * time.Hour), false},
		{"already started", now.Add(-time.Hour), false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			b := Booking{Start: tt.start}
			if got := b.CancellationIsFree(now); got != tt.free {
				t.Errorf("got %v, want %v", got, tt.free)
			}
		})
	}
}
