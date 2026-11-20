// Command seed creates demo accounts: an admin, three approved cleaners
// around central London with working hours, and a client with an address.
// It is safe to run more than once.
package main

import (
	"context"
	"fmt"
	"os"
	"time"

	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/store/postgres"
)

type demoUser struct {
	phone, name, role string
}

type demoCleaner struct {
	demoUser
	bio      string
	lat, lng float64
}

var (
	admin    = demoUser{"+447700900001", "Ada Admin", "admin"}
	client   = demoUser{"+447700900201", "Charlie Client", "client"}
	cleaners = []demoCleaner{
		{demoUser{"+447700900101", "Sarah Jones", "cleaner"}, "Five years of deep cleans, pet friendly.", 51.5115, -0.1160},
		{demoUser{"+447700900102", "Tom Clarke", "cleaner"}, "End of tenancy specialist.", 51.4952, -0.1441},
		{demoUser{"+447700900103", "Priya Shah", "cleaner"}, "Eco products only.", 51.5226, -0.0937},
	}
)

func main() {
	url := os.Getenv("DATABASE_URL")
	if url == "" {
		fmt.Fprintln(os.Stderr, "DATABASE_URL is required")
		os.Exit(2)
	}
	if err := run(url); err != nil {
		fmt.Fprintln(os.Stderr, "seed:", err)
		os.Exit(1)
	}
	fmt.Println("demo data ready:")
	fmt.Printf("  admin   %s\n  client  %s\n", admin.phone, client.phone)
	for _, c := range cleaners {
		fmt.Printf("  cleaner %s (%s)\n", c.phone, c.name)
	}
	fmt.Println("log in with POST /api/v1/auth/otp; in development the code is printed in the api log")
}

func run(url string) error {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	return seed(ctx, url)
}

func seed(ctx context.Context, url string) error {
	store, err := postgres.Open(ctx, url)
	if err != nil {
		return err
	}
	defer store.Close()

	return pgx.BeginFunc(ctx, store.Pool(), func(tx pgx.Tx) error {
		if _, err := upsertUser(ctx, tx, admin); err != nil {
			return err
		}

		clientID, err := upsertUser(ctx, tx, client)
		if err != nil {
			return err
		}
		_, err = tx.Exec(ctx, `
			INSERT INTO addresses (user_id, line1, city, postcode, lat, lng, access_notes)
			SELECT $1, '221B Baker Street', 'London', 'NW1 6XE', 51.5238, -0.1586, 'Ring the top bell.'
			WHERE NOT EXISTS (SELECT 1 FROM addresses WHERE user_id = $1 AND deleted_at IS NULL)`, clientID)
		if err != nil {
			return fmt.Errorf("client address: %w", err)
		}

		for _, c := range cleaners {
			id, err := upsertUser(ctx, tx, c.demoUser)
			if err != nil {
				return err
			}
			_, err = tx.Exec(ctx, `
				INSERT INTO cleaners (user_id, status, bio, is_online, last_lat, last_lng, last_seen_at)
				VALUES ($1, 'approved', $2, true, $3, $4, now())
				ON CONFLICT (user_id) DO UPDATE SET status = 'approved', bio = $2, is_online = true,
					last_lat = $3, last_lng = $4, last_seen_at = now()`, id, c.bio, c.lat, c.lng)
			if err != nil {
				return fmt.Errorf("cleaner %s: %w", c.name, err)
			}
			// Monday to Saturday, 08:00 to 18:00.
			_, err = tx.Exec(ctx, `
				INSERT INTO cleaner_availability (cleaner_id, weekday, start_time, end_time)
				SELECT $1, d, '08:00', '18:00' FROM generate_series(0, 5) AS d
				ON CONFLICT (cleaner_id, weekday) DO UPDATE SET start_time = '08:00', end_time = '18:00'`, id)
			if err != nil {
				return fmt.Errorf("availability %s: %w", c.name, err)
			}
		}
		return nil
	})
}

func upsertUser(ctx context.Context, tx pgx.Tx, u demoUser) (string, error) {
	var id string
	err := tx.QueryRow(ctx, `
		INSERT INTO users (phone, full_name, role) VALUES ($1, $2, $3)
		ON CONFLICT (phone) DO UPDATE SET full_name = $2, role = $3
		RETURNING id`, u.phone, u.name, u.role).Scan(&id)
	if err != nil {
		return "", fmt.Errorf("user %s: %w", u.name, err)
	}
	return id, nil
}
