package domain

import (
	"testing"
	"time"
)

func TestAvailabilityCovers(t *testing.T) {
	london, err := time.LoadLocation("Europe/London")
	if err != nil {
		t.Fatal(err)
	}
	// Thursday 3 December 2026, 08:00-17:00 London time.
	thursday := Availability{Weekday: 3, StartTime: 8 * 60, EndTime: 17 * 60}
	at := func(h, m int) time.Time { return time.Date(2026, 12, 3, h, m, 0, 0, london) }

	tests := []struct {
		name       string
		start, end time.Time
		want       bool
	}{
		{"inside", at(9, 0), at(11, 30), true},
		{"exactly the window", at(8, 0), at(17, 0), true},
		{"starts too early", at(7, 30), at(9, 0), false},
		{"ends too late", at(15, 0), at(17, 30), false},
		{"wrong day", at(9, 0).AddDate(0, 0, 1), at(11, 0).AddDate(0, 0, 1), false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := thursday.Covers(tt.start, tt.end, london); got != tt.want {
				t.Errorf("got %v, want %v", got, tt.want)
			}
		})
	}
}

func TestTimeOfDay(t *testing.T) {
	for _, s := range []string{"00:00", "08:30", "23:59"} {
		v, err := ParseTimeOfDay(s)
		if err != nil || v.String() != s {
			t.Errorf("round trip %q: got %q, %v", s, v, err)
		}
	}
	for _, s := range []string{"24:00", "8:30", "08:60", "abcde", ""} {
		if _, err := ParseTimeOfDay(s); err == nil {
			t.Errorf("ParseTimeOfDay(%q): want error", s)
		}
	}
}

func TestNormalizePhone(t *testing.T) {
	tests := []struct {
		in, want string
		ok       bool
	}{
		{"+44 7700 900123", "+447700900123", true},
		{"+998-90-123-45-67", "+998901234567", true},
		{"07700900123", "", false},
		{"+44abc", "", false},
	}
	for _, tt := range tests {
		got, ok := NormalizePhone(tt.in)
		if got != tt.want || ok != tt.ok {
			t.Errorf("NormalizePhone(%q) = %q, %v; want %q, %v", tt.in, got, ok, tt.want, tt.ok)
		}
	}
}

func TestDistanceAndETA(t *testing.T) {
	// Trafalgar Square to King's Cross, about 3 km.
	d := DistanceKm(51.5080, -0.1281, 51.5308, -0.1238)
	if d < 2.4 || d > 2.7 {
		t.Errorf("distance = %.2f km, want about 2.5", d)
	}
	if got := ETAMinutes(d); got != 8 {
		t.Errorf("ETAMinutes(%.2f) = %d, want 8", d, got)
	}
	if got := ETAMinutes(0); got != 1 {
		t.Errorf("ETAMinutes(0) = %d, want 1", got)
	}
}
