package service

import (
	"context"
	"crypto/hmac"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"fmt"
	"log/slog"
	"math/big"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

const (
	otpDigits        = 6
	otpTTL           = 5 * time.Minute
	otpMaxAttempts   = 5
	otpMaxRequests   = 3
	otpRequestWindow = 10 * time.Minute
	tokenIssuer      = "tidy"
	// refreshGrace lets an app retry a refresh whose answer it never got,
	// or two refreshes race, without being signed out.
	refreshGrace = 10 * time.Second
)

type AuthConfig struct {
	Secret     []byte
	AccessTTL  time.Duration
	RefreshTTL time.Duration
}

type Auth struct {
	store  AuthStore
	sender CodeSender
	cfg    AuthConfig
	clock  Clock
}

func NewAuth(store AuthStore, sender CodeSender, cfg AuthConfig, clock Clock) *Auth {
	return &Auth{store: store, sender: sender, cfg: cfg, clock: clock}
}

type Session struct {
	AccessToken  string       `json:"access_token"`
	RefreshToken string       `json:"refresh_token"`
	User         *domain.User `json:"user,omitempty"`
}

var (
	errWrongCode    = domain.NewError(domain.CodeUnauthorized, "The code is wrong or has expired.")
	errBadPhone     = domain.Invalid("phone", "must be in international format, e.g. +447700900123")
	errBadRefresh   = domain.NewError(domain.CodeUnauthorized, "Please sign in again.")
	errTooManyCodes = domain.NewError(domain.CodeTooManyRequests, "Too many codes requested. Try again in a few minutes.")
)

// RequestCode sends a new login code to the phone.
func (a *Auth) RequestCode(ctx context.Context, rawPhone string) error {
	phone, ok := domain.NormalizePhone(rawPhone)
	if !ok {
		return errBadPhone
	}
	now := a.clock.now()
	n, err := a.store.CountOTPRequests(ctx, phone, now.Add(-otpRequestWindow))
	if err != nil {
		return err
	}
	if n >= otpMaxRequests {
		return errTooManyCodes
	}

	code, err := randomDigits(otpDigits)
	if err != nil {
		return err
	}
	if err := a.store.SaveOTP(ctx, phone, a.hashCode(phone, code), now.Add(otpTTL)); err != nil {
		return err
	}
	return a.sender.SendCode(ctx, phone, code)
}

// Verify checks the code and signs the user in, creating the account on
// first login. Role only matters for new accounts.
func (a *Auth) Verify(ctx context.Context, rawPhone, code string, role domain.Role) (Session, error) {
	phone, ok := domain.NormalizePhone(rawPhone)
	if !ok {
		return Session{}, errBadPhone
	}
	if role == "" {
		role = domain.RoleClient
	}
	if role != domain.RoleClient && role != domain.RoleCleaner {
		return Session{}, domain.Invalid("role", "must be client or cleaner")
	}

	otp, err := a.store.TouchOTP(ctx, phone)
	if errors.Is(err, domain.ErrNotFound) {
		return Session{}, errWrongCode
	}
	if err != nil {
		return Session{}, err
	}
	if otp.Attempts > otpMaxAttempts {
		if err := a.store.DeleteOTP(ctx, phone); err != nil {
			return Session{}, err
		}
		return Session{}, domain.NewError(domain.CodeTooManyRequests, "Too many wrong codes. Request a new one.")
	}
	want := a.hashCode(phone, code)
	if a.clock.now().After(otp.ExpiresAt) || !hmac.Equal([]byte(otp.CodeHash), []byte(want)) {
		return Session{}, errWrongCode
	}
	// Two requests with the right code can race; only one may consume it.
	consumed, err := a.store.ConsumeOTP(ctx, phone, want)
	if err != nil {
		return Session{}, err
	}
	if !consumed {
		return Session{}, errWrongCode
	}

	user, err := a.store.FindOrCreateUser(ctx, phone, role)
	if err != nil {
		return Session{}, err
	}
	s, err := a.newSession(ctx, user)
	if err != nil {
		return Session{}, err
	}
	s.User = &user
	return s, nil
}

// Refresh swaps a refresh token for a new pair. Each refresh token works
// once; presenting it again within refreshGrace returns the same pair.
func (a *Auth) Refresh(ctx context.Context, refreshToken string) (Session, error) {
	if refreshToken == "" {
		return Session{}, errBadRefresh
	}
	// The successor is derived from the old token, so a retry can be given
	// the same token without storing it in plain text.
	next := a.successor(refreshToken)
	now := a.clock.now()
	userID, rotatedAt, err := a.store.RotateRefreshToken(ctx, RefreshRotation{
		OldHash:   hashToken(refreshToken),
		NewHash:   hashToken(next),
		ExpiresAt: now.Add(a.cfg.RefreshTTL),
		Now:       now,
		Grace:     refreshGrace,
	})
	if err != nil {
		return Session{}, err
	}
	user, err := a.store.GetUser(ctx, userID)
	if err != nil {
		return Session{}, err
	}
	// Issued at the rotation time, so a retry gets the same access token too.
	access, err := a.accessTokenAt(user, rotatedAt)
	if err != nil {
		return Session{}, err
	}
	return Session{AccessToken: access, RefreshToken: next}, nil
}

func (a *Auth) successor(refreshToken string) string {
	mac := hmac.New(sha256.New, a.cfg.Secret)
	mac.Write([]byte("refresh:" + refreshToken))
	return base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
}

// Logout revokes the refresh token. Unknown tokens are ignored, so logging
// out twice is fine.
func (a *Auth) Logout(ctx context.Context, refreshToken string) error {
	if refreshToken == "" {
		return nil
	}
	return a.store.RevokeRefreshToken(ctx, hashToken(refreshToken))
}

type accessClaims struct {
	Role domain.Role `json:"role"`
	jwt.RegisteredClaims
}

// ParseAccessToken validates the JWT and returns who is calling.
func (a *Auth) ParseAccessToken(token string) (Principal, error) {
	var claims accessClaims
	_, err := jwt.ParseWithClaims(token, &claims,
		func(*jwt.Token) (any, error) { return a.cfg.Secret, nil },
		jwt.WithValidMethods([]string{jwt.SigningMethodHS256.Alg()}),
		jwt.WithIssuer(tokenIssuer),
		jwt.WithExpirationRequired(),
		jwt.WithTimeFunc(a.clock.now),
	)
	if err != nil {
		return Principal{}, domain.ErrUnauthorized
	}
	id, err := uuid.Parse(claims.Subject)
	if err != nil || !claims.Role.Valid() {
		return Principal{}, domain.ErrUnauthorized
	}
	return Principal{UserID: id, Role: claims.Role}, nil
}

func (a *Auth) newSession(ctx context.Context, user domain.User) (Session, error) {
	access, err := a.accessToken(user)
	if err != nil {
		return Session{}, err
	}
	refresh, err := randomToken()
	if err != nil {
		return Session{}, err
	}
	if err := a.store.SaveRefreshToken(ctx, user.ID, hashToken(refresh), a.clock.now().Add(a.cfg.RefreshTTL)); err != nil {
		return Session{}, err
	}
	return Session{AccessToken: access, RefreshToken: refresh}, nil
}

func (a *Auth) accessToken(user domain.User) (string, error) {
	return a.accessTokenAt(user, a.clock.now())
}

func (a *Auth) accessTokenAt(user domain.User, now time.Time) (string, error) {
	claims := accessClaims{
		Role: user.Role,
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   user.ID.String(),
			Issuer:    tokenIssuer,
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(now.Add(a.cfg.AccessTTL)),
		},
	}
	return jwt.NewWithClaims(jwt.SigningMethodHS256, claims).SignedString(a.cfg.Secret)
}

// hashCode keys the hash with the server secret: a six digit code is too
// easy to brute force from a leaked plain hash.
func (a *Auth) hashCode(phone, code string) string {
	mac := hmac.New(sha256.New, a.cfg.Secret)
	mac.Write([]byte("otp:" + phone + ":" + code))
	return hex.EncodeToString(mac.Sum(nil))
}

// Refresh tokens are 256 random bits, so a fast unsalted hash is enough.
func hashToken(token string) string {
	sum := sha256.Sum256([]byte(token))
	return hex.EncodeToString(sum[:])
}

func randomToken() (string, error) {
	b := make([]byte, 32)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(b), nil
}

func randomDigits(n int) (string, error) {
	limit := new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(n)), nil)
	v, err := rand.Int(rand.Reader, limit)
	if err != nil {
		return "", err
	}
	return fmt.Sprintf("%0*d", n, v), nil
}

// LogCodeSender writes the code to the log instead of sending an SMS. It
// only prints the code itself in development.
type LogCodeSender struct {
	Log       *slog.Logger
	ShowCodes bool
}

func (s LogCodeSender) SendCode(_ context.Context, phone, code string) error {
	if s.ShowCodes {
		s.Log.Info("login code", "phone", phone, "code", code)
		return nil
	}
	s.Log.Warn("no SMS provider configured, login code not delivered", "phone", phone)
	return nil
}
