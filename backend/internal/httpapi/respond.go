package httpapi

import (
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/google/uuid"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

const maxBodyBytes = 1 << 20

// handlerFunc returns an error instead of writing it, so every handler
// reports errors the same way.
type handlerFunc func(w http.ResponseWriter, r *http.Request) error

func (s *Server) handle(fn handlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if err := fn(w, r); err != nil {
			s.writeError(w, r, err)
		}
	}
}

type errorBody struct {
	Error errorDetail `json:"error"`
}

type errorDetail struct {
	Code    domain.ErrorCode  `json:"code"`
	Message string            `json:"message"`
	Details map[string]string `json:"details,omitempty"`
}

var statusByCode = map[domain.ErrorCode]int{
	domain.CodeInvalidRequest:    http.StatusBadRequest,
	domain.CodeUnauthorized:      http.StatusUnauthorized,
	domain.CodeForbidden:         http.StatusForbidden,
	domain.CodeNotFound:          http.StatusNotFound,
	domain.CodeSlotTaken:         http.StatusConflict,
	domain.CodeInvalidTransition: http.StatusConflict,
	domain.CodeOfferGone:         http.StatusConflict,
	domain.CodeTooManyRequests:   http.StatusTooManyRequests,
}

func (s *Server) writeError(w http.ResponseWriter, r *http.Request, err error) {
	var de *domain.Error
	if errors.As(err, &de) {
		status, ok := statusByCode[de.Code]
		if !ok {
			status = http.StatusBadRequest
		}
		writeJSON(w, status, errorBody{Error: errorDetail{Code: de.Code, Message: de.Message, Details: de.Fields}})
		return
	}
	s.log.ErrorContext(r.Context(), "request failed",
		"request_id", middleware.GetReqID(r.Context()), "method", r.Method, "path", r.URL.Path, "err", err)
	writeJSON(w, http.StatusInternalServerError, errorBody{Error: errorDetail{
		Code: "internal", Message: "Something went wrong. Please try again.",
	}})
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}

func noContent(w http.ResponseWriter) error {
	w.WriteHeader(http.StatusNoContent)
	return nil
}

func decode(w http.ResponseWriter, r *http.Request, v any) error {
	dec := json.NewDecoder(http.MaxBytesReader(w, r.Body, maxBodyBytes))
	err := dec.Decode(v)
	if err == nil {
		return nil
	}
	var typeErr *json.UnmarshalTypeError
	var maxErr *http.MaxBytesError
	switch {
	case errors.As(err, &typeErr) && typeErr.Field != "":
		return domain.Invalid(typeErr.Field, "has the wrong type")
	case errors.As(err, &maxErr):
		return domain.NewError(domain.CodeInvalidRequest, "The request body is too large.")
	case errors.Is(err, io.EOF):
		return domain.NewError(domain.CodeInvalidRequest, "The request body is empty.")
	}
	return domain.NewError(domain.CodeInvalidRequest, "The request body must be valid JSON.")
}

func pathID(r *http.Request, name string) (uuid.UUID, error) {
	id, err := uuid.Parse(chi.URLParam(r, name))
	if err != nil {
		return uuid.Nil, domain.Invalid(name, "must be a UUID")
	}
	return id, nil
}

// query reads typed query parameters and collects the problems.
type query struct {
	values map[string][]string
	errs   domain.FieldErrors
}

func newQuery(r *http.Request) *query {
	return &query{values: r.URL.Query(), errs: domain.FieldErrors{}}
}

func (q *query) str(name string) string {
	return strings.TrimSpace(firstOf(q.values[name]))
}

func (q *query) int(name string, def int) int {
	s := q.str(name)
	if s == "" {
		return def
	}
	v, err := strconv.Atoi(s)
	q.errs.Check(err == nil, name, "must be a number")
	return v
}

func (q *query) uuid(name string) uuid.UUID {
	id, err := uuid.Parse(q.str(name))
	q.errs.Check(err == nil, name, "must be a UUID")
	return id
}

func (q *query) optionalUUID(name string) *uuid.UUID {
	if q.str(name) == "" {
		return nil
	}
	id := q.uuid(name)
	return &id
}

// uuids accepts both ?extra_ids=a,b and ?extra_ids=a&extra_ids=b.
func (q *query) uuids(name string) []uuid.UUID {
	var out []uuid.UUID
	for _, v := range q.values[name] {
		for _, part := range strings.Split(v, ",") {
			if part = strings.TrimSpace(part); part == "" {
				continue
			}
			id, err := uuid.Parse(part)
			q.errs.Check(err == nil, name, "must be a list of UUIDs")
			out = append(out, id)
		}
	}
	return out
}

// time accepts RFC 3339 or a plain date (midnight UTC).
func (q *query) time(name string) *time.Time {
	s := q.str(name)
	if s == "" {
		return nil
	}
	for _, layout := range []string{time.RFC3339, time.DateOnly} {
		if t, err := time.Parse(layout, s); err == nil {
			return &t
		}
	}
	q.errs.Check(false, name, "must be an RFC 3339 time or YYYY-MM-DD")
	return nil
}

func (q *query) err() error { return q.errs.Err() }

func firstOf(v []string) string {
	if len(v) == 0 {
		return ""
	}
	return v[0]
}
