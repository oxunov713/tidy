// Command migrate applies the database migrations in migrations/.
package main

import (
	"fmt"
	"os"

	"github.com/oxunov713/tidy/backend/internal/store/postgres"
)

func main() {
	url := os.Getenv("DATABASE_URL")
	if url == "" {
		fmt.Fprintln(os.Stderr, "DATABASE_URL is required")
		os.Exit(2)
	}
	if err := postgres.Migrate(url); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	fmt.Println("migrations applied")
}
