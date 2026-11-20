package postgres

import (
	"encoding/base64"
	"encoding/json"
	"time"

	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

// cursor points at the last row of a page. It is opaque to the apps.
type cursor struct {
	Time time.Time `json:"t"`
	ID   uuid.UUID `json:"id"`
}

func encodeCursor(c cursor) string {
	b, _ := json.Marshal(c)
	return base64.RawURLEncoding.EncodeToString(b)
}

func decodeCursor(s string) (cursor, error) {
	var c cursor
	b, err := base64.RawURLEncoding.DecodeString(s)
	if err != nil || json.Unmarshal(b, &c) != nil || c.ID == uuid.Nil {
		return c, domain.Invalid("cursor", "is not valid")
	}
	return c, nil
}
