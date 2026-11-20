// Package scheduler runs the periodic jobs: recurring bookings, offer
// expiry and charging saved cards.
package scheduler

import (
	"context"
	"log/slog"
	"sync"
	"time"
)

type PlanRunner interface {
	RunPlans(ctx context.Context) (int, error)
}

type OfferSweeper interface {
	Sweep(ctx context.Context) error
}

type PaymentAuthorizer interface {
	AuthorizeDue(ctx context.Context) error
}

type Scheduler struct {
	plans    PlanRunner
	offers   OfferSweeper
	payments PaymentAuthorizer
	log      *slog.Logger

	PlanInterval    time.Duration
	SweepInterval   time.Duration
	PaymentInterval time.Duration
}

func New(plans PlanRunner, offers OfferSweeper, payments PaymentAuthorizer, log *slog.Logger) *Scheduler {
	return &Scheduler{
		plans:           plans,
		offers:          offers,
		payments:        payments,
		log:             log,
		PlanInterval:    time.Hour,
		SweepInterval:   5 * time.Second,
		PaymentInterval: time.Minute,
	}
}

// Run blocks until ctx is cancelled. Each job runs once straight away and
// then on its interval; a slow run delays the next one instead of overlapping.
func (s *Scheduler) Run(ctx context.Context) {
	var wg sync.WaitGroup
	start := func(interval time.Duration, job func(context.Context)) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			every(ctx, interval, job)
		}()
	}
	start(s.PlanInterval, func(ctx context.Context) {
		n, err := s.plans.RunPlans(ctx)
		if err != nil {
			s.log.Error("recurring bookings", "err", err)
			return
		}
		if n > 0 {
			s.log.Info("recurring bookings created", "count", n)
		}
	})
	start(s.SweepInterval, func(ctx context.Context) {
		if err := s.offers.Sweep(ctx); err != nil && ctx.Err() == nil {
			s.log.Error("offer sweep", "err", err)
		}
	})
	start(s.PaymentInterval, func(ctx context.Context) {
		if err := s.payments.AuthorizeDue(ctx); err != nil && ctx.Err() == nil {
			s.log.Error("authorise saved cards", "err", err)
		}
	})
	wg.Wait()
}

func every(ctx context.Context, interval time.Duration, job func(context.Context)) {
	t := time.NewTicker(interval)
	defer t.Stop()
	for {
		job(ctx)
		select {
		case <-ctx.Done():
			return
		case <-t.C:
		}
	}
}
