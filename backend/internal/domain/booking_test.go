package domain

import (
	"strings"
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

func TestReviewLimits(t *testing.T) {
	ok := Review{Rating: 5, Comment: strings.Repeat("é", MaxReviewComment), Tip: MaxTip}
	if err := ok.Validate(); err != nil {
		t.Errorf("review at the limits: %v", err)
	}
	for name, r := range map[string]Review{
		"long comment": {Rating: 5, Comment: strings.Repeat("a", MaxReviewComment+1)},
		"big tip":      {Rating: 5, Tip: MaxTip + 1},
		"long tag":     {Rating: 5, Tags: []string{strings.Repeat("a", MaxTagLength+1)}},
	} {
		if r.Validate() == nil {
			t.Errorf("%s: want an error", name)
		}
	}
}

func TestMessageLengthCountsCharacters(t *testing.T) {
	if _, err := ValidateMessageBody(strings.Repeat("é", MaxMessageLength)); err != nil {
		t.Errorf("2000 two-byte characters: %v", err)
	}
	if _, err := ValidateMessageBody(strings.Repeat("a", MaxMessageLength+1)); err == nil {
		t.Error("2001 characters: want an error")
	}
}

func TestStatusPhraseNamesEveryStatus(t *testing.T) {
	for _, s := range []BookingStatus{StatusPending, StatusConfirmed, StatusAssigned, StatusOnTheWay,
		StatusInProgress, StatusCompleted, StatusCancelled} {
		if p := s.Phrase(); p == "This booking" || p == "" {
			t.Errorf("%s has no phrase", s)
		}
	}
	if !StatusConfirmed.CanBeReassigned() || !StatusAssigned.CanBeReassigned() || StatusOnTheWay.CanBeReassigned() {
		t.Error("only confirmed and assigned bookings can be reassigned")
	}
}

func TestChatClosed(t *testing.T) {
	done := time.Date(2026, 12, 1, 12, 0, 0, 0, time.UTC)
	tests := []struct {
		name   string
		status BookingStatus
		now    time.Time
		closed bool
	}{
		{"assigned", StatusAssigned, done, false},
		{"cancelled", StatusCancelled, done, true},
		{"completed an hour ago", StatusCompleted, done.Add(time.Hour), false},
		{"completed 25 hours ago", StatusCompleted, done.Add(25 * time.Hour), true},
	}
	for _, tt := range tests {
		b := Booking{Status: tt.status, UpdatedAt: done}
		if got := b.ChatClosed(tt.now) != nil; got != tt.closed {
			t.Errorf("%s: closed = %v, want %v", tt.name, got, tt.closed)
		}
	}
}
