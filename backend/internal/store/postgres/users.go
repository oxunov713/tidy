package postgres

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

func (s *Store) CountOTPRequests(ctx context.Context, phone string, since time.Time) (int, error) {
	var n int
	err := s.pool.QueryRow(ctx,
		`SELECT count(*) FROM otp_requests WHERE phone = $1 AND created_at > $2`, phone, since).Scan(&n)
	return n, err
}

func (s *Store) SaveOTP(ctx context.Context, phone, codeHash string, expiresAt time.Time) error {
	return s.inTx(ctx, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			INSERT INTO otp_codes (phone, code_hash, expires_at, attempts) VALUES ($1, $2, $3, 0)
			ON CONFLICT (phone) DO UPDATE SET code_hash = $2, expires_at = $3, attempts = 0`,
			phone, codeHash, expiresAt)
		if err != nil {
			return err
		}
		if _, err := tx.Exec(ctx, `INSERT INTO otp_requests (phone) VALUES ($1)`, phone); err != nil {
			return err
		}
		// Housekeeping: rows older than any rate limit window are useless.
		_, err = tx.Exec(ctx, `DELETE FROM otp_requests WHERE created_at < now() - interval '1 day'`)
		return err
	})
}

func (s *Store) TouchOTP(ctx context.Context, phone string) (service.OTPState, error) {
	var st service.OTPState
	err := s.pool.QueryRow(ctx, `
		UPDATE otp_codes SET attempts = attempts + 1 WHERE phone = $1
		RETURNING code_hash, expires_at, attempts`, phone).Scan(&st.CodeHash, &st.ExpiresAt, &st.Attempts)
	if isNoRows(err) {
		return st, domain.NotFound("Code")
	}
	return st, err
}

func (s *Store) ConsumeOTP(ctx context.Context, phone, codeHash string) (bool, error) {
	tag, err := s.pool.Exec(ctx, `DELETE FROM otp_codes WHERE phone = $1 AND code_hash = $2`, phone, codeHash)
	return tag.RowsAffected() == 1, err
}

func (s *Store) DeleteOTP(ctx context.Context, phone string) error {
	_, err := s.pool.Exec(ctx, `DELETE FROM otp_codes WHERE phone = $1`, phone)
	return err
}

const userColumns = `id, phone, full_name, email, role, avatar_url, created_at`

func scanUser(row pgx.Row) (domain.User, error) {
	var u domain.User
	err := row.Scan(&u.ID, &u.Phone, &u.FullName, &u.Email, &u.Role, &u.AvatarURL, &u.CreatedAt)
	if isNoRows(err) {
		return u, domain.NotFound("User")
	}
	return u, err
}

func (s *Store) FindOrCreateUser(ctx context.Context, phone string, role domain.Role) (domain.User, error) {
	var u domain.User
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		// The no-op update makes RETURNING work for an existing row too.
		row := tx.QueryRow(ctx, `
			INSERT INTO users (phone, role) VALUES ($1, $2)
			ON CONFLICT (phone) DO UPDATE SET phone = EXCLUDED.phone
			RETURNING `+userColumns, phone, role)
		var err error
		if u, err = scanUser(row); err != nil {
			return err
		}
		if u.Role == domain.RoleCleaner {
			_, err = tx.Exec(ctx, `INSERT INTO cleaners (user_id) VALUES ($1) ON CONFLICT DO NOTHING`, u.ID)
		}
		return err
	})
	return u, err
}

func (s *Store) GetUser(ctx context.Context, id uuid.UUID) (domain.User, error) {
	return scanUser(s.pool.QueryRow(ctx, `SELECT `+userColumns+` FROM users WHERE id = $1`, id))
}

func (s *Store) GetUsers(ctx context.Context, ids []uuid.UUID) (map[uuid.UUID]domain.User, error) {
	out := make(map[uuid.UUID]domain.User, len(ids))
	if len(ids) == 0 {
		return out, nil
	}
	rows, err := s.pool.Query(ctx, `SELECT `+userColumns+` FROM users WHERE id = ANY($1::uuid[])`, uuidStrings(ids))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	for rows.Next() {
		u, err := scanUser(rows)
		if err != nil {
			return nil, err
		}
		out[u.ID] = u
	}
	return out, rows.Err()
}

func (s *Store) UpdateUser(ctx context.Context, id uuid.UUID, fullName, email *string) (domain.User, error) {
	// nil leaves a field as is; an empty email clears it.
	return scanUser(s.pool.QueryRow(ctx, `
		UPDATE users SET
			full_name = coalesce($2, full_name),
			email = CASE WHEN $3::text IS NULL THEN email ELSE nullif($3, '') END
		WHERE id = $1 RETURNING `+userColumns, id, fullName, email))
}

func (s *Store) SaveRefreshToken(ctx context.Context, userID uuid.UUID, tokenHash string, expiresAt time.Time) error {
	_, err := s.pool.Exec(ctx,
		`INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES ($1, $2, $3)`,
		userID, tokenHash, expiresAt)
	return err
}

func (s *Store) RotateRefreshToken(ctx context.Context, r service.RefreshRotation) (uuid.UUID, time.Time, error) {
	var userID uuid.UUID
	rotatedAt := r.Now
	reused := false
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		var revokedAt *time.Time
		var replacedBy *string
		var expires time.Time
		err := tx.QueryRow(ctx, `
			SELECT user_id, revoked_at, replaced_by, expires_at FROM refresh_tokens
			WHERE token_hash = $1 FOR UPDATE`, r.OldHash).Scan(&userID, &revokedAt, &replacedBy, &expires)
		if isNoRows(err) {
			return domain.ErrUnauthorized
		}
		if err != nil {
			return err
		}
		if revokedAt != nil {
			ok, err := retriedWithinGrace(ctx, tx, r, *revokedAt, replacedBy)
			if err != nil || ok {
				rotatedAt = *revokedAt
				return err
			}
			// A rotated token came back: it was stolen or the app is
			// confused. Either way, sign the user out everywhere.
			reused = true
			_, err = tx.Exec(ctx, `UPDATE refresh_tokens SET revoked_at = $2 WHERE user_id = $1 AND revoked_at IS NULL`, userID, r.Now)
			return err
		}
		if r.Now.After(expires) {
			return domain.ErrUnauthorized
		}
		if _, err := tx.Exec(ctx, `UPDATE refresh_tokens SET revoked_at = $2, replaced_by = $3 WHERE token_hash = $1`,
			r.OldHash, r.Now, r.NewHash); err != nil {
			return err
		}
		_, err = tx.Exec(ctx, `INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES ($1, $2, $3)`,
			userID, r.NewHash, r.ExpiresAt)
		return err
	})
	if err == nil && reused {
		err = domain.ErrUnauthorized
	}
	return userID, rotatedAt, err
}

// retriedWithinGrace: two requests raced with the same token, or the answer
// to the first one was lost. The successor must still be usable: rotated
// on is fine, signed out is not.
func retriedWithinGrace(ctx context.Context, tx pgx.Tx, r service.RefreshRotation, revokedAt time.Time, replacedBy *string) (bool, error) {
	if replacedBy == nil || *replacedBy != r.NewHash || r.Now.Sub(revokedAt) > r.Grace {
		return false, nil
	}
	var successorRevoked, successorRotated bool
	err := tx.QueryRow(ctx, `
		SELECT revoked_at IS NOT NULL, replaced_by IS NOT NULL FROM refresh_tokens WHERE token_hash = $1`,
		r.NewHash).Scan(&successorRevoked, &successorRotated)
	if isNoRows(err) {
		return false, nil
	}
	return err == nil && (!successorRevoked || successorRotated), err
}

func (s *Store) RevokeRefreshToken(ctx context.Context, tokenHash string) error {
	_, err := s.pool.Exec(ctx,
		`UPDATE refresh_tokens SET revoked_at = now() WHERE token_hash = $1 AND revoked_at IS NULL`, tokenHash)
	return err
}

func (s *Store) UpsertDevice(ctx context.Context, userID uuid.UUID, token string, platform domain.DevicePlatform) error {
	_, err := s.pool.Exec(ctx, `
		INSERT INTO device_tokens (token, user_id, platform) VALUES ($1, $2, $3)
		ON CONFLICT (token) DO UPDATE SET user_id = $2, platform = $3, updated_at = now()`,
		token, userID, platform)
	return err
}

func (s *Store) DeviceTokens(ctx context.Context, userID uuid.UUID) ([]string, error) {
	rows, err := s.pool.Query(ctx, `SELECT token FROM device_tokens WHERE user_id = $1`, userID)
	if err != nil {
		return nil, err
	}
	return pgx.CollectRows(rows, pgx.RowTo[string])
}

func (s *Store) DeleteDevice(ctx context.Context, token string) error {
	_, err := s.pool.Exec(ctx, `DELETE FROM device_tokens WHERE token = $1`, token)
	return err
}

const addressColumns = `id, user_id, line1, line2, city, postcode, lat, lng, access_notes, deleted_at IS NOT NULL`

func scanAddress(row pgx.Row) (domain.Address, error) {
	var a domain.Address
	err := row.Scan(&a.ID, &a.UserID, &a.Line1, &a.Line2, &a.City, &a.Postcode, &a.Lat, &a.Lng, &a.AccessNotes, &a.Deleted)
	if isNoRows(err) {
		return a, domain.NotFound("Address")
	}
	return a, err
}

func (s *Store) ListAddresses(ctx context.Context, userID uuid.UUID) ([]domain.Address, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT `+addressColumns+` FROM addresses
		WHERE user_id = $1 AND deleted_at IS NULL ORDER BY line1, id`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []domain.Address{}
	for rows.Next() {
		a, err := scanAddress(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, a)
	}
	return out, rows.Err()
}

func (s *Store) CreateAddress(ctx context.Context, a domain.Address) (domain.Address, error) {
	return scanAddress(s.pool.QueryRow(ctx, `
		INSERT INTO addresses (user_id, line1, line2, city, postcode, lat, lng, access_notes)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING `+addressColumns,
		a.UserID, a.Line1, a.Line2, a.City, a.Postcode, a.Lat, a.Lng, a.AccessNotes))
}

func (s *Store) GetAddress(ctx context.Context, id uuid.UUID) (domain.Address, error) {
	return scanAddress(s.pool.QueryRow(ctx, `SELECT `+addressColumns+` FROM addresses WHERE id = $1`, id))
}

func (s *Store) DeleteAddress(ctx context.Context, userID, id uuid.UUID) error {
	tag, err := s.pool.Exec(ctx, `
		UPDATE addresses SET deleted_at = now()
		WHERE id = $1 AND user_id = $2 AND deleted_at IS NULL`, id, userID)
	if err == nil && tag.RowsAffected() == 0 {
		return domain.NotFound("Address")
	}
	return err
}

func uuidStrings(ids []uuid.UUID) []string {
	out := make([]string, len(ids))
	for i, id := range ids {
		out[i] = id.String()
	}
	return out
}
