@Tags(['integration'])
library;

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

/// End to end flow against a running backend, with the real [ApiClient] and
/// [RealtimeClient]. Skipped unless `TIDY_API_URL` is set.
///
/// ```bash
/// TIDY_API_URL=http://localhost:8080 \
/// TIDY_API_LOG=/tmp/tidy-api.log \
/// flutter test test/integration --tags integration
/// ```
///
/// Environment:
/// * `TIDY_API_URL`: server origin, e.g. `http://localhost:8080`.
/// * `TIDY_API_LOG`: file the API writes its log to. In development the API
///   logs one-time codes there (`msg="login code"`).
/// * `TIDY_ADMIN_PHONE` (default `+447700900001`): the seeded admin, from
///   `make seed`.
/// * `TIDY_CLEANER_PHONE`: optional seeded cleaner to use instead of a fresh
///   one. A seeded cleaner keeps the slot of every earlier run, so repeated
///   runs find later and later slots.
/// * `TIDY_DATABASE_URL`: optional. If the first free slot is more than 3
///   hours away (`on_the_way` is refused before that), the test moves the
///   booking to two hours from now with `psql` so the whole visit can run.
///   Without it the test stops after checking that the server refuses.
final String? _apiUrl = Platform.environment['TIDY_API_URL'];
final String? _logPath = Platform.environment['TIDY_API_LOG'];
final String _adminPhone =
    Platform.environment['TIDY_ADMIN_PHONE'] ?? '+447700900001';
final String? _seededCleaner = Platform.environment['TIDY_CLEANER_PHONE'];
final String? _databaseUrl = Platform.environment['TIDY_DATABASE_URL'];

const _wait = Duration(seconds: 10);

/// Where Sarah and the others of the seed work, a few km from the address.
const _cleanerLat = 51.5115;
const _cleanerLng = -0.116;

void main() {
  test(
    'client, cleaner and admin through a whole booking',
    () async {
      final session = _Session(_apiUrl!);
      addTearDown(session.close);
      await _flow(session);
    },
    skip: _apiUrl == null ? 'Set TIDY_API_URL to run against a backend' : null,
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

Future<void> _flow(_Session s) async {
  // -- Catalogue and quotes need no sign in ----------------------------------
  final guest = s.newApp();
  final services = await guest.api.catalog.services();
  final extras = await guest.api.catalog.extras();
  final standard = services.firstWhere((x) => x.slug == 'standard');
  final oven = extras.firstWhere((x) => x.slug == 'oven');

  final plain = QuoteRequest(
    serviceId: standard.id,
    bedrooms: 2,
    bathrooms: 1,
  );
  final withOven = plain.copyWith(
    extraIds: [oven.id],
    frequency: Frequency.weekly,
  );
  final plainQuote = await guest.api.bookings.quote(plain);
  final quote = await guest.api.bookings.quote(withOven);
  expect(
    quote.minutes,
    greaterThan(plainQuote.minutes),
    reason: 'extras count',
  );
  expect(quote.total, quote.subtotal - quote.discount);
  expect(quote.discount, greaterThan(0));
  expect(quote.lines.map((l) => l.label), contains(oven.title));
  expect(quote.lines.last.amount, -quote.discount);

  await expectLater(
    guest.api.bookings.quote(plain.copyWith(bedrooms: 0)),
    throwsA(
      isA<InvalidRequestException>().having(
        (e) => e.details?['bedrooms'],
        'details.bedrooms',
        isNotEmpty,
      ),
    ),
  );
  await expectLater(
    guest.api.me.get(),
    throwsA(isA<UnauthorizedException>()),
  );

  // -- Admin ----------------------------------------------------------------
  final admin = s.newApp();
  final adminSession = await s.login(admin, _adminPhone);
  expect(adminSession.user.role, UserRole.admin);
  final adminServices = await admin.api.admin.services();
  expect(adminServices.map((x) => x.slug), contains('standard'));

  // -- Cleaner: sign up, approval, availability, online ----------------------
  final cleaner = s.newApp();
  final cleanerPhone = _seededCleaner ?? s.randomPhone();
  final cleanerSession = await s.login(
    cleaner,
    cleanerPhone,
    role: UserRole.cleaner,
  );
  final cleanerId = cleanerSession.user.id;
  var me = await cleaner.api.me.get();
  expect(me.role, UserRole.cleaner);
  expect(me.cleaner, isNotNull);

  if (me.cleaner!.status != CleanerStatus.approved) {
    expect(me.cleaner!.status, CleanerStatus.pending);
    await expectLater(
      cleaner.api.cleaner.setOnline(
        online: true,
        lat: _cleanerLat,
        lng: _cleanerLng,
      ),
      throwsA(isA<ForbiddenException>()),
    );
    final pending = await admin.api.admin.cleaners(
      status: CleanerStatus.pending,
    );
    expect(pending.map((u) => u.id), contains(cleanerId));
    await _approve(admin, cleanerId);
  }
  final windows = await cleaner.api.cleaner.setAvailability([
    for (var day = 0; day < 7; day++)
      AvailabilityWindow(weekday: day, startTime: '06:00', endTime: '22:00'),
  ]);
  expect(windows, hasLength(7));
  expect((await cleaner.api.cleaner.availability()).first.startTime, '06:00');
  await cleaner.api.cleaner.setOnline(
    online: true,
    lat: _cleanerLat,
    lng: _cleanerLng,
  );
  me = await cleaner.api.me.get();
  expect(me.cleaner!.isOnline, isTrue);
  expect(me.cleaner!.lastLat, closeTo(_cleanerLat, 1e-6));

  final approved = await admin.api.admin.cleaners(
    status: CleanerStatus.approved,
  );
  expect(approved.map((u) => u.id), contains(cleanerId));

  // The cleaner listens for offers before anything is booked.
  await cleaner.rt.connect();
  cleaner.rt.subscribe(Rooms.cleanerOffers);
  await cleaner.events.next<RoomSubscribed>(
    (e) => e.room == Rooms.cleanerOffers,
  );

  // -- Client: sign up, address, slots, booking --------------------------------
  final client = s.newApp();
  final clientSession = await s.login(
    client,
    s.randomPhone(),
    role: UserRole.client,
  );
  expect(clientSession.user.role, UserRole.client);
  expect(clientSession.user.cleaner, isNull);
  final profile = await client.api.me.update(
    fullName: 'Integration Client',
    email: 'integration@example.com',
  );
  expect(profile.fullName, 'Integration Client');
  expect(profile.email, 'integration@example.com');

  final address = await client.api.me.addAddress(
    const AddressInput(
      line1: '221B Baker Street',
      city: 'London',
      postcode: 'NW1 6XE',
      lat: 51.5238,
      lng: -0.1586,
      accessNotes: 'Ring the top bell.',
    ),
  );
  expect(address.line2, isEmpty);
  expect(await client.api.me.addresses(), [address]);
  await expectLater(
    client.api.cleaner.offers(),
    throwsA(isA<ForbiddenException>()),
  );

  await client.rt.connect();

  final slot = await _firstFreeSlot(
    client.api,
    request: withOven,
    addressId: address.id,
    cleanerId: cleanerId,
  );
  final booked = await client.api.bookings.create(
    CreateBookingRequest(
      serviceId: standard.id,
      bedrooms: 2,
      bathrooms: 1,
      addressId: address.id,
      start: slot.start.toLocal(),
      extraIds: [oven.id],
      frequency: Frequency.weekly,
      cleanerId: cleanerId,
    ),
  );
  final booking = booked.booking;
  expect(booked.payment.clientSecret, isNotEmpty);
  expect(booking.status, BookingStatus.confirmed, reason: 'mock payment');
  expect(booking.start, slot.start);
  expect(booking.total, quote.total);
  expect(booking.end.difference(booking.start).inMinutes, quote.minutes);
  expect(booking.requestedCleanerId, cleanerId);
  expect(booking.extras.single.id, oven.id);
  expect(booking.planId, isNotNull, reason: 'weekly starts a plan');
  expect(booking.cleanerPayout, lessThan(booking.total));
  final bookingRoom = Rooms.booking(booking.id);

  // Nobody else may follow this booking.
  final stranger = s.newApp();
  await s.login(stranger, s.randomPhone(), role: UserRole.client);
  await stranger.rt.connect();
  stranger.rt.subscribe(bookingRoom);
  final denied = await stranger.events.next<RealtimeError>((_) => true);
  expect(denied.code, 'forbidden');
  await expectLater(
    stranger.api.bookings.get(booking.id),
    throwsA(isA<ForbiddenException>()),
  );

  client.rt.subscribe(bookingRoom);
  await client.events.next<RoomSubscribed>((e) => e.room == bookingRoom);

  // -- Offer arrives over the socket and by REST ---------------------------------
  final pushed = await cleaner.events.next<OfferReceived>(
    (e) => e.booking.id == booking.id,
  );
  expect(pushed.booking.status, BookingStatus.confirmed);
  expect(pushed.expiresAt.isAfter(DateTime.now().toUtc()), isTrue);

  final offers = await cleaner.api.cleaner.offers();
  final offer = offers.singleWhere((o) => o.booking.id == booking.id);
  expect(offer.postcode, 'NW1 6XE');
  expect(offer.city, 'London');
  expect(offer.distanceKm, inInclusiveRange(1, 10));
  expect(offer.expiresAt, pushed.expiresAt);

  final accepted = await cleaner.api.cleaner.acceptOffer(booking.id);
  expect(accepted.status, BookingStatus.assigned);
  expect(accepted.cleanerId, cleanerId);
  final assigned = await client.events.next<BookingStatusChanged>(
    (e) => e.bookingId == booking.id && e.status == BookingStatus.assigned,
  );
  expect(assigned.at.isUtc, isTrue);
  await expectLater(
    cleaner.api.cleaner.acceptOffer(booking.id),
    throwsA(isA<OfferGoneException>()),
  );
  expect(await cleaner.api.cleaner.offers(), isEmpty);

  cleaner.rt.subscribe(bookingRoom);
  await cleaner.events.next<RoomSubscribed>((e) => e.room == bookingRoom);

  var details = await client.api.bookings.get(booking.id);
  expect(details.booking.status, BookingStatus.assigned);
  expect(details.cleaner?.id, cleanerId);
  expect(details.address, address);
  expect(details.lastLocation, isNull);
  expect(details.events.map((e) => e.status), [
    BookingStatus.pending,
    BookingStatus.confirmed,
    BookingStatus.assigned,
  ]);
  expect(details.events.first.actorId, clientSession.user.id);
  expect(details.events[1].actorId, isNull, reason: 'system confirmed it');

  // The same slot is gone for the next client.
  await expectLater(
    client.api.bookings.create(
      CreateBookingRequest(
        serviceId: standard.id,
        bedrooms: 2,
        bathrooms: 1,
        addressId: address.id,
        start: slot.start,
        extraIds: [oven.id],
        cleanerId: cleanerId,
      ),
    ),
    throwsA(isA<SlotTakenException>()),
  );

  final jobs = await cleaner.api.cleaner.jobs(
    from: slot.start.subtract(const Duration(hours: 1)),
    to: booking.end.add(const Duration(hours: 1)),
  );
  final job = jobs.singleWhere((j) => j.booking.id == booking.id);
  expect(job.clientName, 'Integration Client');
  expect(job.address.line1, '221B Baker Street');

  final adminRows = await admin.api.admin.bookings(query: booking.code);
  final row = adminRows.items.singleWhere((r) => r.booking.id == booking.id);
  expect(row.clientName, 'Integration Client');
  expect(row.clientPhone, clientSession.user.phone);
  expect(row.cleanerName, cleanerSession.user.fullName);

  // -- Setting off ------------------------------------------------------------
  var visitStart = booking.start;
  final untilStart = booking.start.difference(DateTime.now().toUtc());
  if (untilStart > const Duration(hours: 3)) {
    await expectLater(
      cleaner.api.cleaner.setJobStatus(booking.id, BookingStatus.onTheWay),
      throwsA(isA<InvalidTransitionException>()),
      reason: 'on_the_way is refused more than 3 hours before the start',
    );
    if (_databaseUrl == null) {
      // The only way to tell the person running the test why it stopped.
      // ignore: avoid_print
      print(
        'First free slot is ${untilStart.inHours} h away and TIDY_DATABASE_URL '
        'is not set: stopping before the visit.',
      );
      return;
    }
    await _moveToTwoHoursFromNow(booking.id);
    visitStart = (await client.api.bookings.get(booking.id)).booking.start;
    expect(visitStart.isBefore(booking.start), isTrue);
  }

  await cleaner.api.cleaner.setJobStatus(booking.id, BookingStatus.onTheWay);
  await client.events.next<BookingStatusChanged>(
    (e) => e.bookingId == booking.id && e.status == BookingStatus.onTheWay,
  );

  expect(
    cleaner.rt.sendLocation(
      bookingId: booking.id,
      lat: _cleanerLat,
      lng: _cleanerLng,
    ),
    isTrue,
  );
  final moved = await client.events.next<CleanerLocationUpdated>(
    (e) => e.bookingId == booking.id,
  );
  expect(moved.lat, closeTo(_cleanerLat, 1e-6));
  expect(moved.lng, closeTo(_cleanerLng, 1e-6));
  expect(moved.etaMinutes, greaterThan(0));

  details = await client.api.bookings.get(booking.id);
  expect(details.lastLocation?.lat, closeTo(_cleanerLat, 1e-6));

  await expectLater(
    cleaner.api.cleaner.setJobStatus(booking.id, BookingStatus.completed),
    throwsA(isA<InvalidTransitionException>()),
  );

  await cleaner.api.cleaner.setJobStatus(booking.id, BookingStatus.inProgress);
  await client.events.next<BookingStatusChanged>(
    (e) => e.bookingId == booking.id && e.status == BookingStatus.inProgress,
  );
  // Sharing the position is only allowed on the way.
  cleaner.rt.sendLocation(
    bookingId: booking.id,
    lat: _cleanerLat,
    lng: _cleanerLng,
  );
  final refused = await cleaner.events.next<RealtimeError>(
    (e) => e.code == 'invalid_transition',
  );
  expect(refused.message, isNotEmpty);

  await expectLater(
    client.api.bookings.review(
      booking.id,
      const ReviewRequest(rating: 5),
    ),
    throwsA(isA<ApiException>()),
    reason: 'only after completed',
  );

  final done = await cleaner.api.cleaner.setJobStatus(
    booking.id,
    BookingStatus.completed,
  );
  expect(done.status, BookingStatus.completed);
  await client.events.next<BookingStatusChanged>(
    (e) => e.bookingId == booking.id && e.status == BookingStatus.completed,
  );

  // -- Review -------------------------------------------------------------------
  final review = await client.api.bookings.review(
    booking.id,
    const ReviewRequest(
      rating: 5,
      tags: ['thorough', 'friendly'],
      comment: 'Spotless',
      tip: 300,
    ),
  );
  expect(review.rating, 5);
  expect(review.tags, ['thorough', 'friendly']);
  expect(review.tip, 300);
  expect(review.cleanerId, cleanerId);

  details = await client.api.bookings.get(booking.id);
  expect(details.booking.status, BookingStatus.completed);
  expect(details.review?.comment, 'Spotless');
  expect(details.events.map((e) => e.status).toList(), [
    BookingStatus.pending,
    BookingStatus.confirmed,
    BookingStatus.assigned,
    BookingStatus.onTheWay,
    BookingStatus.inProgress,
    BookingStatus.completed,
  ]);
  expect(details.cleaner?.ratingCount, 1);
  expect(details.cleaner?.rating, 5);

  client.rt.unsubscribe(bookingRoom);
  await client.events.next<RoomUnsubscribed>((e) => e.room == bookingRoom);

  // -- Earnings ------------------------------------------------------------------
  for (final period in EarningsPeriod.values) {
    final earnings = await cleaner.api.cleaner.earnings(period: period);
    expect(earnings.period, period.name);
    expect(
      earnings.days,
      hasLength(period == EarningsPeriod.week ? 7 : greaterThan(27)),
    );
    expect(earnings.jobs, 1);
    expect(earnings.total, booking.cleanerPayout);
    expect(earnings.tips, 300);
    expect(earnings.minutes, quote.minutes);
    expect(
      earnings.days.fold<int>(0, (sum, d) => sum + d.amount),
      booking.cleanerPayout + 300,
    );
    final recent = earnings.recent.single;
    expect(recent.bookingId, booking.id);
    expect(recent.code, booking.code);
    expect(recent.amount, booking.cleanerPayout);
    expect(recent.tip, 300);
    expect(recent.start, visitStart);
  }

  // -- Lists, cursors and cancelling --------------------------------------------
  final later = await _firstFreeSlot(
    client.api,
    request: plain,
    addressId: address.id,
    cleanerId: cleanerId,
    fromDay: 3,
  );
  final second = await client.api.bookings.create(
    CreateBookingRequest(
      serviceId: standard.id,
      bedrooms: 2,
      bathrooms: 1,
      addressId: address.id,
      start: later.start,
      cleanerId: cleanerId,
    ),
  );
  final cancelled = await client.api.bookings.cancel(second.booking.id);
  expect(cancelled.refunded, isTrue, reason: 'more than 24 h ahead');
  expect(cancelled.booking.status, BookingStatus.cancelled);
  await expectLater(
    client.api.bookings.cancel(second.booking.id),
    throwsA(isA<InvalidTransitionException>()),
  );

  final seen = <String>{};
  for (final scope in BookingScope.values) {
    String? cursor;
    do {
      final page = await client.api.bookings.list(
        scope: scope,
        cursor: cursor,
        limit: 1,
      );
      expect(page.items.length, lessThanOrEqualTo(1));
      seen.addAll(page.items.map((b) => b.id));
      cursor = page.hasMore ? page.nextCursor : null;
    } while (cursor != null);
  }
  expect(seen, {booking.id, second.booking.id});

  final chat = await client.api.bookings.sendMessage(booking.id, 'Thank you!');
  expect(chat.senderId, clientSession.user.id);
  expect(chat.bookingId, booking.id);
  expect(
    (await cleaner.api.bookings.messages(booking.id)).map((m) => m.body),
    ['Thank you!'],
  );

  // -- Admin again: numbers, list, edits -----------------------------------------
  final stats = await admin.api.admin.statsToday();
  expect(stats.cleanersOnline, greaterThanOrEqualTo(1));
  expect(stats.pendingApprovals, greaterThanOrEqualTo(0));
  expect(stats.bookings, greaterThanOrEqualTo(1));
  expect(stats.revenue, greaterThanOrEqualTo(booking.total));

  final completed = await admin.api.admin.bookings(
    status: BookingStatus.completed,
    limit: 5,
  );
  expect(completed.items, isNotEmpty);
  expect(
    completed.items.map((r) => r.booking.status),
    everyElement(BookingStatus.completed),
  );
  expect(completed.items.map((r) => r.booking.id), contains(booking.id));

  final target = adminServices.firstWhere((x) => x.slug == 'standard');
  final saved = await admin.api.admin.updateService(
    target.id,
    ServiceUpdate(
      title: target.title,
      basePrice: target.basePrice,
      perBedroom: target.perBedroom,
      perBathroom: target.perBathroom,
      baseMinutes: target.baseMinutes,
      minutesPerRoom: target.minutesPerRoom,
      isActive: target.isActive,
    ),
  );
  expect(saved, target);

  // -- Tokens ---------------------------------------------------------------------
  expect(await client.api.refreshSession(), isTrue);
  expect((await client.api.me.get()).id, clientSession.user.id);
  await client.api.auth.logout();
  await expectLater(
    client.api.me.get(),
    throwsA(isA<UnauthorizedException>()),
  );
}

/// First start time in the next two weeks where the cleaner is free.
Future<Slot> _firstFreeSlot(
  ApiClient api, {
  required QuoteRequest request,
  required String addressId,
  required String cleanerId,
  int fromDay = 0,
}) async {
  final today = DateTime.now().toUtc();
  for (var day = fromDay; day < fromDay + 14; day++) {
    final response = await api.bookings.slots(
      serviceId: request.serviceId,
      bedrooms: request.bedrooms,
      bathrooms: request.bathrooms,
      extraIds: request.extraIds,
      date: today.add(Duration(days: day)),
      addressId: addressId,
      cleanerId: cleanerId,
    );
    for (final slot in response.slots) {
      if (slot.available) return slot;
    }
  }
  fail('No free slot in the next two weeks');
}

/// `POST /admin/cleaners/{id}/approve`. The backend currently answers 500 to
/// it (the SQL types `$2` both as `cleaner_status` and as text), so when that
/// happens the cleaner is approved with `psql` instead and the test says so.
Future<void> _approve(_App admin, String cleanerId) async {
  try {
    await admin.api.admin.approveCleaner(cleanerId);
    return;
  } on ServerException catch (e) {
    if (_databaseUrl == null) {
      fail('approve failed ($e); set TIDY_DATABASE_URL to approve with psql');
    }
    // The only way to tell the person running the test about the workaround.
    // ignore: avoid_print
    print(
      'WARNING: POST /admin/cleaners/{id}/approve failed with $e; '
      'approving with psql',
    );
  }
  final result = await Process.run('psql', [
    _databaseUrl!,
    '-v',
    'ON_ERROR_STOP=1',
    '-c',
    "UPDATE cleaners SET status = 'approved' WHERE user_id = '$cleanerId'",
  ]);
  expect(result.exitCode, 0, reason: '${result.stderr}');
}

Future<void> _moveToTwoHoursFromNow(String bookingId) async {
  final result = await Process.run('psql', [
    _databaseUrl!,
    '-v',
    'ON_ERROR_STOP=1',
    '-c',
    '''
UPDATE bookings
SET period = tstzrange(
  now() + interval '125 minutes',
  now() + interval '125 minutes' + (upper(period) - lower(period)))
WHERE id = '$bookingId'
''',
  ]);
  expect(result.exitCode, 0, reason: '${result.stderr}');
}

/// One signed in app: REST client, socket and everything the socket said.
class _App {
  _App(this.api, this.rt, this.storage, this.events);

  final ApiClient api;
  final RealtimeClient rt;
  final InMemoryTokenStorage storage;
  final EventLog events;
}

class _Session {
  _Session(this.url);

  final String url;
  final _apps = <_App>[];
  final _random = Random();

  _App newApp() {
    final storage = InMemoryTokenStorage();
    final config = ApiConfig(baseUrl: url);
    final api = ApiClient(config: config, tokenStorage: storage);
    final rt = RealtimeClient(
      config: config,
      tokenStorage: storage,
      onHandshakeFailed: api.refreshSession,
    );
    final app = _App(api, rt, storage, EventLog(rt.events));
    _apps.add(app);
    return app;
  }

  /// A UK mobile number that is not one of the seeded accounts.
  String randomPhone() =>
      '+4477008${_random.nextInt(100000).toString().padLeft(5, '0')}';

  /// OTP sign in; the code comes from the API log.
  Future<AuthSession> login(_App app, String phone, {UserRole? role}) async {
    final before = _codes(phone).length;
    await app.api.auth.requestOtp(phone);
    final code = await _waitForCode(phone, before);
    return app.api.auth.verify(phone: phone, code: code, role: role);
  }

  List<String> _codes(String phone) {
    final path = _logPath;
    if (path == null) {
      fail('Set TIDY_API_LOG to the file the API writes its log to');
    }
    final pattern = RegExp(
      'msg="login code" phone=${RegExp.escape(phone)} code=(\\d+)',
    );
    return [
      for (final line in File(path).readAsLinesSync())
        if (pattern.firstMatch(line) case final match?) match.group(1)!,
    ];
  }

  Future<String> _waitForCode(String phone, int before) async {
    final deadline = DateTime.now().add(_wait);
    while (DateTime.now().isBefore(deadline)) {
      final codes = _codes(phone);
      if (codes.length > before) return codes.last;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    fail('No login code for $phone in the API log');
  }

  Future<void> close() async {
    for (final app in _apps) {
      await app.rt.dispose();
      await app.events.close();
      app.api.close();
    }
  }
}

/// Remembers every socket event so a test can wait for one that already came.
class EventLog {
  EventLog(Stream<RealtimeEvent> source) {
    _subscription = source.listen(_seen.add);
  }

  late final StreamSubscription<RealtimeEvent> _subscription;
  final _seen = <RealtimeEvent>[];

  Future<void> close() => _subscription.cancel();

  /// The first event of type [T] matching [where], whether it arrived before
  /// the call or arrives within ten seconds.
  Future<T> next<T extends RealtimeEvent>(bool Function(T event) where) async {
    final deadline = DateTime.now().add(_wait);
    while (true) {
      for (final event in _seen) {
        if (event is T && where(event)) return event;
      }
      if (DateTime.now().isAfter(deadline)) {
        fail(
          'No $T within ${_wait.inSeconds}s. Seen: '
          '${_seen.map((e) => e.runtimeType).toList()}',
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 25));
    }
  }
}
