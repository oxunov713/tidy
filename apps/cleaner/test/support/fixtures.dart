import 'package:tidy_cleaner/features/jobs/domain/incoming_offer.dart';
import 'package:tidy_core/tidy_core.dart';

/// 3 December 2026, 09:00 UTC. Tests use it as "now".
final now = DateTime.utc(2026, 12, 3, 9);

Booking booking({
  String id = 'b1',
  BookingStatus status = BookingStatus.assigned,
  DateTime? start,
  Duration length = const Duration(hours: 2, minutes: 30),
  int payout = 5800,
  String title = 'Standard clean',
  List<BookingExtra> extras = const [],
}) {
  final from = start ?? now.add(const Duration(hours: 1));
  return Booking(
    id: id,
    code: 'TD-$id',
    clientId: 'client-1',
    serviceId: 's1',
    serviceTitle: title,
    addressId: 'a1',
    bedrooms: 3,
    bathrooms: 2,
    frequency: Frequency.once,
    start: from,
    end: from.add(length),
    status: status,
    subtotal: 8000,
    discount: 0,
    total: 8000,
    cleanerPayout: payout,
    createdAt: now.subtract(const Duration(days: 1)),
    updatedAt: now.subtract(const Duration(minutes: 30)),
    extras: extras,
  );
}

const address = Address(
  id: 'a1',
  line1: '14 Baker Street',
  city: 'London',
  postcode: 'NW1 6XE',
  lat: 51.5237,
  lng: -0.1585,
  line2: 'Flat 3',
  accessNotes: 'Key in the lockbox',
);

Job job({
  String id = 'b1',
  BookingStatus status = BookingStatus.assigned,
  DateTime? start,
  String client = 'Emma W.',
  int payout = 5800,
}) => Job(
  booking: booking(id: id, status: status, start: start, payout: payout),
  address: address,
  clientName: client,
);

IncomingOffer offer({
  String id = 'o1',
  Duration expiresIn = const Duration(seconds: 60),
  int payout = 8400,
  bool withDetails = true,
}) => IncomingOffer(
  booking: booking(
    id: id,
    status: BookingStatus.confirmed,
    payout: payout,
    title: 'Deep clean',
    start: now.add(const Duration(days: 1)),
    length: const Duration(hours: 3, minutes: 30),
    extras: const [BookingExtra(id: 'e1', title: 'Inside fridge', price: 1500)],
  ),
  expiresAt: now.add(expiresIn),
  distanceKm: withDetails ? 2.4 : null,
  postcode: withDetails ? 'NW1' : null,
  city: withDetails ? 'Camden' : null,
);

Earnings earnings({
  String period = 'week',
  int total = 48600,
  int tips = 3200,
  int jobs = 8,
  int minutes = 1290,
  List<EarningsDay>? days,
  List<EarningsJob>? recent,
}) => Earnings(
  period: period,
  from: '2026-11-30',
  to: '2026-12-06',
  total: total,
  tips: tips,
  jobs: jobs,
  minutes: minutes,
  days:
      days ??
      const [
        EarningsDay(date: '2026-11-30', amount: 5800),
        EarningsDay(date: '2026-12-01', amount: 7200),
        EarningsDay(date: '2026-12-02', amount: 6300),
        EarningsDay(date: '2026-12-03', amount: 9600),
        EarningsDay(date: '2026-12-04', amount: 0),
        EarningsDay(date: '2026-12-05', amount: 0),
        EarningsDay(date: '2026-12-06', amount: 0),
      ],
  recent:
      recent ??
      [
        EarningsJob(
          bookingId: 'x1',
          code: 'TD-1040',
          serviceTitle: 'Deep clean',
          start: DateTime.utc(2026, 12, 2, 13),
          minutes: 210,
          amount: 8400,
          tip: 0,
        ),
        EarningsJob(
          bookingId: 'x2',
          code: 'TD-1038',
          serviceTitle: 'Standard clean',
          start: DateTime.utc(2026, 12, 1, 10),
          minutes: 150,
          amount: 5800,
          tip: 500,
        ),
      ],
);

User user({
  CleanerStatus status = CleanerStatus.approved,
  bool online = false,
  UserRole role = UserRole.cleaner,
}) => User(
  id: 'me',
  phone: '+447700900101',
  fullName: 'Sarah Jones',
  role: role,
  createdAt: DateTime.utc(2026),
  cleaner: Cleaner(
    userId: 'me',
    status: status,
    bio: 'Eight years of making homes shine.',
    rating: 4.9,
    ratingCount: 12,
    isOnline: online,
  ),
);
