package scheduler

import (
	"context"
	"io"
	"log/slog"
	"sync/atomic"
	"testing"
	"time"
)

type counter struct{ n atomic.Int32 }

func (c *counter) RunPlans(context.Context) (int, error) { c.n.Add(1); return 0, nil }
func (c *counter) Sweep(context.Context) error           { c.n.Add(1); return nil }

func TestRunStopsOnCancel(t *testing.T) {
	plans, offers := &counter{}, &counter{}
	s := New(plans, offers, slog.New(slog.NewTextHandler(io.Discard, nil)))
	s.PlanInterval, s.SweepInterval = time.Hour, 10*time.Millisecond

	ctx, cancel := context.WithCancel(context.Background())
	done := make(chan struct{})
	go func() {
		s.Run(ctx)
		close(done)
	}()

	time.Sleep(55 * time.Millisecond)
	cancel()
	select {
	case <-done:
	case <-time.After(time.Second):
		t.Fatal("Run did not return after cancel")
	}
	if got := plans.n.Load(); got != 1 {
		t.Errorf("plans ran %d times, want 1 (once at start)", got)
	}
	if got := offers.n.Load(); got < 3 {
		t.Errorf("sweep ran %d times, want at least 3", got)
	}
}
