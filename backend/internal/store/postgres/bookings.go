package postgres

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/oxunov713/tidy/backend/internal/domain"
	"github.com/oxunov713/tidy/backend/internal/service"
)

const bookingColumns = `b.id, b.code, b.client_id, b.cleaner_id, b.service_id, s.title, b.address_id,
	b.requested_cleaner_id, b.plan_id, b.bedrooms, b.bathrooms, b.frequency,
	lower(b.period), upper(b.period), b.status, b.subtotal, b.discount, b.total,
	b.cleaner_payout, b.created_at, b.updated_at`

const bookingFrom = ` FROM bookings b JOIN services s ON s.id = b.service_id`

func scanBooking(row pgx.Row) (domain.Booking, error) {
	var b domain.Booking
	err := row.Scan(&b.ID, &b.Code, &b.ClientID, &b.CleanerID, &b.ServiceID, &b.ServiceTitle, &b.AddressID,
		&b.RequestedCleanerID, &b.PlanID, &b.Bedrooms, &b.Bathrooms, &b.Frequency,
		&b.Start, &b.End, &b.Status, &b.Subtotal, &b.Discount, &b.Total,
		&b.CleanerPayout, &b.CreatedAt, &b.UpdatedAt)
	if isNoRows(err) {
		return b, domain.NotFound("Booking")
	}
	return b, err
}

func getBooking(ctx context.Context, q querier, id uuid.UUID) (domain.Booking, error) {
	b, err := scanBooking(q.QueryRow(ctx, `SELECT `+bookingColumns+bookingFrom+` WHERE b.id = $1`, id))
	if err != nil {
		return b, err
	}
	list := []domain.Booking{b}
	if err := loadExtras(ctx, q, list); err != nil {
		return b, err
	}
	return list[0], nil
}

func queryBookings(ctx context.Context, q querier, sql string, args ...any) ([]domain.Booking, error) {
	rows, err := q.Query(ctx, sql, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []domain.Booking{}
	for rows.Next() {
		b, err := scanBooking(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, b)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return out, loadExtras(ctx, q, out)
}

// loadExtras fills Extras for all bookings with one query.
func loadExtras(ctx context.Context, q querier, list []domain.Booking) error {
	if len(list) == 0 {
		return nil
	}
	index := make(map[uuid.UUID]int, len(list))
	ids := make([]uuid.UUID, len(list))
	for i := range list {
		list[i].Extras = []domain.BookingExtra{}
		index[list[i].ID] = i
		ids[i] = list[i].ID
	}
	rows, err := q.Query(ctx, `
		SELECT be.booking_id, be.extra_id, e.title, be.price
		FROM booking_extras be JOIN service_extras e ON e.id = be.extra_id
		WHERE be.booking_id = ANY($1::uuid[]) ORDER BY e.title`, uuidStrings(ids))
	if err != nil {
		return err
	}
	defer rows.Close()
	for rows.Next() {
		var bookingID uuid.UUID
		var e domain.BookingExtra
		if err := rows.Scan(&bookingID, &e.ExtraID, &e.Title, &e.Price); err != nil {
			return err
		}
		i := index[bookingID]
		list[i].Extras = append(list[i].Extras, e)
	}
	return rows.Err()
}

func (s *Store) CreateBooking(ctx context.Context, nb domain.NewBooking) (domain.Booking, error) {
	var b domain.Booking
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		var planID *uuid.UUID
		if nb.Plan != nil {
			var id uuid.UUID
			err := tx.QueryRow(ctx, `
				INSERT INTO booking_plans (client_id, frequency, template, next_run_on)
				VALUES ($1, $2, $3, $4::date) RETURNING id`,
				nb.ClientID, nb.Plan.Frequency, nb.Plan.Template, nb.Plan.NextRunOn.Format(time.DateOnly)).Scan(&id)
			if err != nil {
				return fmt.Errorf("insert plan: %w", err)
			}
			planID = &id
		}
		if nb.FromPlan != nil {
			planID = &nb.FromPlan.PlanID
			// The plan may have ended since the scheduler read it.
			tag, err := tx.Exec(ctx, `UPDATE booking_plans SET next_run_on = $2::date WHERE id = $1 AND is_active`,
				nb.FromPlan.PlanID, nb.FromPlan.NextRunOn.Format(time.DateOnly))
			if err != nil {
				return fmt.Errorf("advance plan: %w", err)
			}
			if tag.RowsAffected() == 0 {
				return domain.ErrPlanEnded
			}
		}

		var id uuid.UUID
		err := tx.QueryRow(ctx, `
			INSERT INTO bookings (code, client_id, service_id, address_id, requested_cleaner_id, plan_id,
				bedrooms, bathrooms, frequency, period, subtotal, discount, total, cleaner_payout)
			VALUES ('TD-' || nextval('booking_code_seq'), $1, $2, $3, $4, $5,
				$6, $7, $8, tstzrange($9, $10, '[)'), $11, $12, $13, $14)
			RETURNING id`,
			nb.ClientID, nb.ServiceID, nb.AddressID, nb.RequestedCleanerID, planID,
			nb.Bedrooms, nb.Bathrooms, nb.Frequency, nb.Start, nb.End,
			nb.Quote.Subtotal, nb.Quote.Discount, nb.Quote.Total, domain.CleanerPayout(nb.Quote.Total),
		).Scan(&id)
		if err != nil {
			return fmt.Errorf("insert booking: %w", err)
		}
		for _, e := range nb.Extras {
			if _, err := tx.Exec(ctx, `INSERT INTO booking_extras (booking_id, extra_id, price) VALUES ($1, $2, $3)`,
				id, e.ID, e.Price); err != nil {
				return fmt.Errorf("insert booking extra: %w", err)
			}
		}
		if err := addEvent(ctx, tx, id, domain.StatusPending, &nb.ClientID); err != nil {
			return err
		}
		b, err = getBooking(ctx, tx, id)
		return err
	})
	return b, err
}

func addEvent(ctx context.Context, q querier, bookingID uuid.UUID, status domain.BookingStatus, actor *uuid.UUID) error {
	_, err := q.Exec(ctx, `INSERT INTO booking_events (booking_id, status, actor_id) VALUES ($1, $2, $3)`,
		bookingID, status, actor)
	return err
}

func (s *Store) GetBooking(ctx context.Context, id uuid.UUID) (domain.Booking, error) {
	return getBooking(ctx, s.pool, id)
}

func (s *Store) ListBookings(ctx context.Context, f service.ListBookingsFilter) ([]domain.Booking, string, error) {
	var where []string
	var args []any
	arg := func(v any) string {
		args = append(args, v)
		return fmt.Sprintf("$%d", len(args))
	}

	ascending := false
	if f.ClientID != nil {
		where = append(where, "b.client_id = "+arg(*f.ClientID))
	}
	if f.Upcoming != nil {
		upcoming := fmt.Sprintf("(upper(b.period) > %s AND b.status NOT IN ('completed', 'cancelled'))", arg(f.Now))
		if *f.Upcoming {
			where = append(where, upcoming)
			ascending = true
		} else {
			where = append(where, "NOT "+upcoming)
		}
	}
	if f.Status != nil {
		where = append(where, "b.status = "+arg(*f.Status))
	}
	from := bookingFrom
	if f.Query != "" {
		from += ` JOIN users u ON u.id = b.client_id`
		p := arg("%" + escapeLike(f.Query) + "%")
		where = append(where, fmt.Sprintf("(b.code ILIKE %[1]s OR u.full_name ILIKE %[1]s OR u.phone ILIKE %[1]s)", p))
	}

	order, cmp := "DESC", "<"
	if ascending {
		order, cmp = "ASC", ">"
	}
	if f.Cursor != "" {
		c, err := decodeCursor(f.Cursor)
		if err != nil {
			return nil, "", err
		}
		where = append(where, fmt.Sprintf("(lower(b.period), b.id) %s (%s, %s)", cmp, arg(c.Time), arg(c.ID)))
	}

	sql := `SELECT ` + bookingColumns + from
	if len(where) > 0 {
		sql += ` WHERE ` + strings.Join(where, " AND ")
	}
	// One extra row tells whether there is a next page.
	sql += fmt.Sprintf(` ORDER BY lower(b.period) %[1]s, b.id %[1]s LIMIT %[2]s`, order, arg(f.Limit+1))

	list, err := queryBookings(ctx, s.pool, sql, args...)
	if err != nil {
		return nil, "", err
	}
	next := ""
	if len(list) > f.Limit {
		list = list[:f.Limit]
		last := list[len(list)-1]
		next = encodeCursor(cursor{Time: last.Start, ID: last.ID})
	}
	return list, next, nil
}

func (s *Store) ListCleanerJobs(ctx context.Context, cleanerID uuid.UUID, from, to time.Time) ([]domain.Booking, error) {
	return queryBookings(ctx, s.pool, `SELECT `+bookingColumns+bookingFrom+`
		WHERE b.cleaner_id = $1 AND b.status <> 'cancelled' AND b.period && tstzrange($2, $3, '[)')
		ORDER BY lower(b.period)`, cleanerID, from, to)
}

func (s *Store) SetBookingStatus(ctx context.Context, id uuid.UUID, from, to domain.BookingStatus, actor *uuid.UUID) (domain.Booking, error) {
	var b domain.Booking
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		if err := setStatus(ctx, tx, id, from, to, actor); err != nil {
			return err
		}
		var err error
		b, err = getBooking(ctx, tx, id)
		return err
	})
	return b, err
}

func setStatus(ctx context.Context, tx pgx.Tx, id uuid.UUID, from, to domain.BookingStatus, actor *uuid.UUID) error {
	tag, err := tx.Exec(ctx, `UPDATE bookings SET status = $3, updated_at = now() WHERE id = $1 AND status = $2`,
		id, from, to)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return missingOrMoved(ctx, tx, id)
	}
	return addEvent(ctx, tx, id, to, actor)
}

// missingOrMoved explains why a conditional update touched no row.
func missingOrMoved(ctx context.Context, q querier, id uuid.UUID) error {
	var exists bool
	if err := q.QueryRow(ctx, `SELECT EXISTS (SELECT 1 FROM bookings WHERE id = $1)`, id).Scan(&exists); err != nil {
		return err
	}
	if !exists {
		return domain.NotFound("Booking")
	}
	return domain.InvalidTransition("The booking was changed in the meantime. Refresh and try again.")
}

func withdrawOffers(ctx context.Context, tx pgx.Tx, bookingID uuid.UUID) ([]uuid.UUID, error) {
	rows, err := tx.Query(ctx, `
		UPDATE booking_offers SET status = 'withdrawn'
		WHERE booking_id = $1 AND status = 'open' RETURNING cleaner_id`, bookingID)
	if err != nil {
		return nil, err
	}
	return pgx.CollectRows(rows, pgx.RowTo[uuid.UUID])
}

func (s *Store) CancelBooking(ctx context.Context, id uuid.UUID, from domain.BookingStatus, actor *uuid.UUID) (domain.Booking, []uuid.UUID, error) {
	var b domain.Booking
	var withdrawn []uuid.UUID
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		if err := setStatus(ctx, tx, id, from, domain.StatusCancelled, actor); err != nil {
			return err
		}
		var err error
		if withdrawn, err = withdrawOffers(ctx, tx, id); err != nil {
			return err
		}
		b, err = getBooking(ctx, tx, id)
		return err
	})
	return b, withdrawn, err
}

// stuckBatch bounds one sweep; the next sweep picks up the rest.
const stuckBatch = 100

func (s *Store) CancelStuck(ctx context.Context, now, unassignedBy time.Time) (service.StuckBookings, error) {
	var out service.StuckBookings
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		var err error
		out.Unpaid, err = cancelWhere(ctx, tx, `status = 'pending' AND payment_due_at <= $1`, now)
		if err != nil {
			return err
		}
		out.Unassigned, err = cancelWhere(ctx, tx, `status = 'confirmed' AND cleaner_id IS NULL AND lower(period) <= $1`, unassignedBy)
		return err
	})
	return out, err
}

// cancelWhere cancels bookings matching cond (with $1 as its argument) as
// the system, without an actor.
func cancelWhere(ctx context.Context, tx pgx.Tx, cond string, arg any) ([]service.CancelledBooking, error) {
	rows, err := tx.Query(ctx, `
		UPDATE bookings SET status = 'cancelled', updated_at = now()
		WHERE id IN (SELECT id FROM bookings WHERE `+cond+` ORDER BY lower(period) LIMIT $2 FOR UPDATE SKIP LOCKED)
		RETURNING id`, arg, stuckBatch)
	if err != nil {
		return nil, err
	}
	ids, err := pgx.CollectRows(rows, pgx.RowTo[uuid.UUID])
	if err != nil {
		return nil, err
	}
	var out []service.CancelledBooking
	for _, id := range ids {
		if err := addEvent(ctx, tx, id, domain.StatusCancelled, nil); err != nil {
			return nil, err
		}
		withdrawn, err := withdrawOffers(ctx, tx, id)
		if err != nil {
			return nil, err
		}
		b, err := getBooking(ctx, tx, id)
		if err != nil {
			return nil, err
		}
		out = append(out, service.CancelledBooking{Booking: b, Withdrawn: withdrawn})
	}
	return out, nil
}

func (s *Store) AssignCleaner(ctx context.Context, bookingID, cleanerID uuid.UUID, actor *uuid.UUID) (domain.Booking, []uuid.UUID, error) {
	var b domain.Booking
	var withdrawn []uuid.UUID
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		tag, err := tx.Exec(ctx, `
			UPDATE bookings SET cleaner_id = $2, status = 'assigned', updated_at = now()
			WHERE id = $1 AND status IN ('confirmed', 'assigned')`, bookingID, cleanerID)
		if err != nil {
			return mapAssignError(err)
		}
		if tag.RowsAffected() == 0 {
			return missingOrMoved(ctx, tx, bookingID)
		}
		if withdrawn, err = withdrawOffers(ctx, tx, bookingID); err != nil {
			return err
		}
		if err := addEvent(ctx, tx, bookingID, domain.StatusAssigned, actor); err != nil {
			return err
		}
		b, err = getBooking(ctx, tx, bookingID)
		return err
	})
	return b, withdrawn, err
}

// mapAssignError turns the bookings_no_overlap violation into slot_taken.
func mapAssignError(err error) error {
	if code, constraint := pgErrorCode(err); code == pgExclusionViolation && constraint == "bookings_no_overlap" {
		return domain.ErrSlotTaken
	}
	return err
}

func (s *Store) BookingEvents(ctx context.Context, id uuid.UUID) ([]domain.BookingEvent, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT status, actor_id, created_at FROM booking_events WHERE booking_id = $1 ORDER BY id`, id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []domain.BookingEvent{}
	for rows.Next() {
		var e domain.BookingEvent
		if err := rows.Scan(&e.Status, &e.ActorID, &e.At); err != nil {
			return nil, err
		}
		out = append(out, e)
	}
	return out, rows.Err()
}

func (s *Store) LastLocation(ctx context.Context, bookingID uuid.UUID) (*domain.Location, error) {
	var l domain.Location
	err := s.pool.QueryRow(ctx, `SELECT lat, lng, recorded_at FROM booking_locations WHERE booking_id = $1`, bookingID).
		Scan(&l.Lat, &l.Lng, &l.At)
	if isNoRows(err) {
		return nil, nil
	}
	return &l, err
}

func (s *Store) SaveLocation(ctx context.Context, bookingID, cleanerID uuid.UUID, lat, lng float64, now time.Time) error {
	return s.inTx(ctx, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			INSERT INTO booking_locations (booking_id, lat, lng, recorded_at) VALUES ($1, $2, $3, $4)
			ON CONFLICT (booking_id) DO UPDATE SET lat = $2, lng = $3, recorded_at = $4`, bookingID, lat, lng, now)
		if err != nil {
			return err
		}
		_, err = tx.Exec(ctx, `UPDATE cleaners SET last_lat = $2, last_lng = $3, last_seen_at = $4 WHERE user_id = $1`,
			cleanerID, lat, lng, now)
		return err
	})
}

func (s *Store) CreateReview(ctx context.Context, r domain.Review) (domain.Review, error) {
	err := s.inTx(ctx, func(tx pgx.Tx) error {
		err := tx.QueryRow(ctx, `
			INSERT INTO reviews (booking_id, cleaner_id, rating, tags, comment, tip)
			VALUES ($1, $2, $3, $4, $5, $6) RETURNING created_at`,
			r.BookingID, r.CleanerID, r.Rating, r.Tags, r.Comment, r.Tip).Scan(&r.CreatedAt)
		if code, _ := pgErrorCode(err); code == pgUniqueViolation {
			return domain.InvalidTransition("This booking already has a review.")
		}
		if err != nil {
			return err
		}
		_, err = tx.Exec(ctx, `
			UPDATE cleaners SET rating_sum = rating_sum + $2, rating_count = rating_count + 1
			WHERE user_id = $1`, r.CleanerID, r.Rating)
		return err
	})
	return r, err
}

func (s *Store) GetReview(ctx context.Context, bookingID uuid.UUID) (*domain.Review, error) {
	var r domain.Review
	err := s.pool.QueryRow(ctx, `
		SELECT booking_id, cleaner_id, rating, tags, comment, tip, created_at
		FROM reviews WHERE booking_id = $1`, bookingID).
		Scan(&r.BookingID, &r.CleanerID, &r.Rating, &r.Tags, &r.Comment, &r.Tip, &r.CreatedAt)
	if isNoRows(err) {
		return nil, nil
	}
	return &r, err
}

// maxChatHistory caps one response; a single clean never gets near it.
const maxChatHistory = 500

func (s *Store) ListMessages(ctx context.Context, bookingID uuid.UUID) ([]domain.Message, error) {
	rows, err := s.pool.Query(ctx, `
		SELECT id, booking_id, sender_id, body, created_at FROM (
			SELECT * FROM messages WHERE booking_id = $1 ORDER BY id DESC LIMIT $2
		) recent ORDER BY id`, bookingID, maxChatHistory)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := []domain.Message{}
	for rows.Next() {
		var m domain.Message
		if err := rows.Scan(&m.ID, &m.BookingID, &m.SenderID, &m.Body, &m.CreatedAt); err != nil {
			return nil, err
		}
		out = append(out, m)
	}
	return out, rows.Err()
}

func (s *Store) CreateMessage(ctx context.Context, m domain.Message) (domain.Message, error) {
	err := s.pool.QueryRow(ctx, `
		INSERT INTO messages (booking_id, sender_id, body) VALUES ($1, $2, $3)
		RETURNING id, created_at`, m.BookingID, m.SenderID, m.Body).Scan(&m.ID, &m.CreatedAt)
	return m, err
}

func (s *Store) StatsBetween(ctx context.Context, from, to time.Time) (service.Stats, error) {
	var st service.Stats
	err := s.pool.QueryRow(ctx, `
		SELECT count(*) FILTER (WHERE status <> 'cancelled'),
			coalesce(sum(total) FILTER (WHERE status = 'completed'), 0)
		FROM bookings WHERE lower(period) >= $1 AND lower(period) < $2`, from, to).
		Scan(&st.Bookings, &st.Revenue)
	if err != nil {
		return st, err
	}
	err = s.pool.QueryRow(ctx, `
		SELECT count(*) FILTER (WHERE status = 'approved' AND is_online),
			count(*) FILTER (WHERE status = 'pending')
		FROM cleaners`).Scan(&st.CleanersOnline, &st.PendingApprovals)
	return st, err
}

func escapeLike(s string) string {
	return strings.NewReplacer(`\`, `\\`, `%`, `\%`, `_`, `\_`).Replace(s)
}
