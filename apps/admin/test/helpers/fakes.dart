import 'dart:async';

import 'package:tidy_admin/features/bookings/domain/bookings_repository.dart';
import 'package:tidy_admin/features/cleaners/domain/cleaners_repository.dart';
import 'package:tidy_admin/features/services/domain/services_repository.dart';
import 'package:tidy_core/testing.dart';
import 'package:tidy_core/tidy_core.dart';

final _epoch = DateTime.utc(2026, 12, 3, 10);

Booking booking({
  String id = 'b1',
  String code = 'TD-1000',
  BookingStatus status = BookingStatus.confirmed,
  String? cleanerId,
  int total = 6800,
}) => Booking(
  id: id,
  code: code,
  clientId: 'client-$id',
  serviceId: 's1',
  serviceTitle: 'Standard clean',
  addressId: 'a1',
  bedrooms: 2,
  bathrooms: 1,
  frequency: Frequency.once,
  start: _epoch,
  end: _epoch.add(const Duration(hours: 3)),
  status: status,
  subtotal: total,
  discount: 0,
  total: total,
  cleanerPayout: total * 3 ~/ 4,
  createdAt: _epoch,
  updatedAt: _epoch,
  cleanerId: cleanerId,
);

AdminBooking adminBooking(
  int n, {
  BookingStatus status = BookingStatus.confirmed,
  String client = 'Emma Wilson',
  String cleaner = '',
}) => AdminBooking(
  booking: booking(
    id: 'b$n',
    code: 'TD-${1000 + n}',
    status: status,
    cleanerId: cleaner.isEmpty ? null : 'c-$cleaner',
  ),
  clientName: client,
  clientPhone: '+4477009002${n.toString().padLeft(2, '0')}',
  cleanerName: cleaner,
);

User cleanerUser(
  String id,
  String name, {
  CleanerStatus status = CleanerStatus.approved,
  bool online = false,
}) => User(
  id: id,
  phone: '+4477009001$id',
  fullName: name,
  role: UserRole.cleaner,
  createdAt: _epoch,
  cleaner: Cleaner(
    userId: id,
    status: status,
    bio: '',
    rating: 4.8,
    ratingCount: 12,
    isOnline: online,
  ),
);

User adminUser() => User(
  id: 'admin',
  phone: '+447700900001',
  fullName: 'Ada Admin',
  role: UserRole.admin,
  createdAt: _epoch,
);

AdminService service(
  String id,
  String title, {
  int basePrice = 4500,
  bool isActive = true,
}) => AdminService(
  id: id,
  slug: id,
  title: title,
  basePrice: basePrice,
  perBedroom: 1500,
  perBathroom: 1000,
  baseMinutes: 120,
  minutesPerRoom: 30,
  isActive: isActive,
  sortOrder: 1,
);

class ListCall {
  const ListCall(this.status, this.query, this.cursor);

  final BookingStatus? status;
  final String? query;
  final String? cursor;
}

/// Serves [all] filtered by status and query, [pageSize] rows at a time, with
/// the offset as the cursor.
class FakeBookingsRepository implements BookingsRepository {
  FakeBookingsRepository(this.all, {this.pageSize = 2});

  final List<AdminBooking> all;
  final int pageSize;
  final calls = <ListCall>[];
  final statsCalls = <int>[];
  AdminStats statsValue = const AdminStats(
    bookings: 7,
    revenue: 40800,
    cleanersOnline: 3,
    pendingApprovals: 2,
  );

  /// Set to make the next `list` call fail.
  Exception? failNextList;
  Exception? reassignError;
  BookingDetails? detailsValue;
  final reassigned = <(String, String)>[];
  final cancelled = <String>[];

  @override
  Future<AdminStats> stats() async {
    statsCalls.add(statsCalls.length);
    return statsValue;
  }

  @override
  Future<AdminBookingPage> list({
    BookingStatus? status,
    String? query,
    String? cursor,
  }) async {
    calls.add(ListCall(status, query, cursor));
    final failure = failNextList;
    if (failure != null) {
      failNextList = null;
      throw failure;
    }
    final q = (query ?? '').toLowerCase();
    final matching = [
      for (final b in all)
        if ((status == null || b.booking.status == status) &&
            (q.isEmpty ||
                b.clientName.toLowerCase().contains(q) ||
                b.booking.code.toLowerCase().contains(q)))
          b,
    ];
    final offset = int.tryParse(cursor ?? '') ?? 0;
    final end = (offset + pageSize).clamp(0, matching.length);
    return AdminBookingPage(
      items: matching.sublist(offset, end),
      nextCursor: end < matching.length ? '$end' : '',
    );
  }

  @override
  Future<BookingDetails> details(String id) async {
    final fixed = detailsValue;
    if (fixed != null) return fixed;
    final row = all.firstWhere((r) => r.booking.id == id);
    return BookingDetails(
      booking: row.booking,
      address: const Address(
        id: 'a1',
        line1: '12 Baker Street',
        city: 'London',
        postcode: 'NW1 6XE',
        lat: 51.5,
        lng: -0.15,
        line2: '',
        accessNotes: 'Ring twice',
      ),
      events: [
        BookingEvent(status: BookingStatus.pending, at: _epoch),
        BookingEvent(status: row.booking.status, at: _epoch),
      ],
    );
  }

  @override
  Future<Booking> reassign(String id, String cleanerId) async {
    final error = reassignError;
    if (error != null) throw error;
    reassigned.add((id, cleanerId));
    return booking(
      id: id,
      status: BookingStatus.assigned,
      cleanerId: cleanerId,
    );
  }

  @override
  Future<Booking> cancel(String id) async {
    cancelled.add(id);
    return booking(id: id, status: BookingStatus.cancelled);
  }
}

class FakeCleanersRepository implements CleanersRepository {
  FakeCleanersRepository(this.cleaners);

  final List<User> cleaners;
  final approved = <String>[];
  final suspended = <String>[];

  /// When set, approve/suspend wait for it, so a test can look at the state
  /// while the request is in flight.
  Completer<void>? gate;
  Exception? failWith;

  @override
  Future<List<User>> list() async => cleaners;

  Future<void> _call(List<String> log, String id) async {
    log.add(id);
    await gate?.future;
    final error = failWith;
    if (error != null) throw error;
  }

  @override
  Future<void> approve(String id) => _call(approved, id);

  @override
  Future<void> suspend(String id) => _call(suspended, id);
}

class FakeServicesRepository implements ServicesRepository {
  FakeServicesRepository(this.services);

  final List<AdminService> services;
  final updates = <(String, ServiceUpdate)>[];
  Exception? failWith;

  @override
  Future<List<AdminService>> list() async => services;

  @override
  Future<AdminService> update(String id, ServiceUpdate update) async {
    updates.add((id, update));
    final error = failWith;
    if (error != null) throw error;
    final old = services.firstWhere((s) => s.id == id);
    return old.copyWith(
      title: update.title,
      basePrice: update.basePrice,
      perBedroom: update.perBedroom,
      perBathroom: update.perBathroom,
      baseMinutes: update.baseMinutes,
      minutesPerRoom: update.minutesPerRoom,
      isActive: update.isActive,
    );
  }
}

/// The admin app's session repository, as a fake.
FakeSessionRepository fakeAdminSession({User? restored, User? signInAs}) =>
    FakeSessionRepository(
      expectedRole: UserRole.admin,
      restoreResult: restored,
      verifyResult: signInAs ?? adminUser(),
    );
