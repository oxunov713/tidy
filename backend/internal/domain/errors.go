package domain

import (
	"fmt"
	"unicode/utf8"
)

// ErrorCode is the machine readable code sent to the apps in the error body.
type ErrorCode string

const (
	CodeInvalidRequest    ErrorCode = "invalid_request"
	CodeUnauthorized      ErrorCode = "unauthorized"
	CodeForbidden         ErrorCode = "forbidden"
	CodeNotFound          ErrorCode = "not_found"
	CodeSlotTaken         ErrorCode = "slot_taken"
	CodeInvalidTransition ErrorCode = "invalid_transition"
	CodeOfferGone         ErrorCode = "offer_gone"
	CodeTooManyRequests   ErrorCode = "too_many_requests"
	CodePayloadTooLarge   ErrorCode = "payload_too_large"
)

// Error is an error the API can show to the user as is.
type Error struct {
	Code    ErrorCode
	Message string
	// Fields maps a request field to what is wrong with it.
	Fields map[string]string
}

func (e *Error) Error() string { return fmt.Sprintf("%s: %s", e.Code, e.Message) }

// Is makes errors.Is match on the code, so a custom message still matches
// the sentinel with the same code.
func (e *Error) Is(target error) bool {
	t, ok := target.(*Error)
	return ok && t.Code == e.Code
}

// Sentinels for errors.Is checks. Use the constructors below to return an
// error with a more specific message.
var (
	ErrInvalidRequest    = &Error{Code: CodeInvalidRequest, Message: "The request is invalid."}
	ErrUnauthorized      = &Error{Code: CodeUnauthorized, Message: "Please sign in again."}
	ErrForbidden         = &Error{Code: CodeForbidden, Message: "You can't do that."}
	ErrNotFound          = &Error{Code: CodeNotFound, Message: "Not found."}
	ErrSlotTaken         = &Error{Code: CodeSlotTaken, Message: "This time was just booked by someone else."}
	ErrInvalidTransition = &Error{Code: CodeInvalidTransition, Message: "The booking can't move to that status."}
	ErrOfferGone         = &Error{Code: CodeOfferGone, Message: "This job is no longer available."}
	ErrTooManyRequests   = &Error{Code: CodeTooManyRequests, Message: "Too many attempts. Try again later."}
	ErrPayloadTooLarge   = &Error{Code: CodePayloadTooLarge, Message: "The request body is too large."}
)

func NewError(code ErrorCode, message string) *Error {
	return &Error{Code: code, Message: message}
}

func NotFound(what string) *Error {
	return &Error{Code: CodeNotFound, Message: what + " not found."}
}

func Forbidden(message string) *Error {
	return &Error{Code: CodeForbidden, Message: message}
}

func InvalidTransition(message string) *Error {
	return &Error{Code: CodeInvalidTransition, Message: message}
}

// FieldErrors collects validation problems so all of them are reported at once.
type FieldErrors map[string]string

// Check records message for field when ok is false. The first problem per
// field wins.
func (f FieldErrors) Check(ok bool, field, message string) {
	if ok {
		return
	}
	if _, exists := f[field]; !exists {
		f[field] = message
	}
}

// Err returns nil when there were no problems.
func (f FieldErrors) Err() error {
	if len(f) == 0 {
		return nil
	}
	return &Error{Code: CodeInvalidRequest, Message: "Some fields are invalid.", Fields: f}
}

// CheckLength records a problem when s (counted in characters, not bytes)
// is longer than limit, or empty while required.
func (f FieldErrors) CheckLength(s string, required bool, limit int, field string) {
	n := utf8.RuneCountInString(s)
	switch {
	case required && n == 0:
		f.Check(false, field, "is required")
	case n > limit:
		f.Check(false, field, fmt.Sprintf("must be at most %d characters", limit))
	}
}

func Invalid(field, message string) *Error {
	return &Error{Code: CodeInvalidRequest, Message: "Some fields are invalid.", Fields: map[string]string{field: message}}
}
