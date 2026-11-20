import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fixtures.dart';

void main() {
  test('Quote parses the API.md example and round-trips', () {
    const json = {
      'subtotal': 8000,
      'discount': 1200,
      'total': 6800,
      'minutes': 180,
      'lines': [
        {'label': 'Standard clean · 2 bed, 1 bath', 'amount': 6000},
        {'label': 'Inside oven', 'amount': 2000},
        {'label': 'Weekly discount (15%)', 'amount': -1200},
      ],
    };
    final quote = Quote.fromJson(json);
    expect(quote.total, 6800);
    expect(quote.minutes, 180);
    expect(quote.lines.last.amount, -1200);
    expect(jsonDecode(jsonEncode(quote.toJson())), json);
  });

  test('Service reads snake_case keys', () {
    final service = Service.fromJson({
      'id': 's1',
      'slug': 'standard',
      'title': 'Standard clean',
      'from_price': 4500,
      'minutes': 120,
    });
    expect(service.fromPrice, 4500);
    expect(service.toJson()['from_price'], 4500);
  });

  test('AdminService has every price field', () {
    final service = AdminService.fromJson({
      'id': 's1',
      'slug': 'standard',
      'title': 'Standard clean',
      'base_price': 4500,
      'per_bedroom': 1500,
      'per_bathroom': 1000,
      'base_minutes': 120,
      'minutes_per_room': 30,
      'is_active': false,
      'sort_order': 1,
    });
    expect(service.perBedroom, 1500);
    expect(service.isActive, isFalse);
    expect(service.sortOrder, 1);
  });

  test('ServiceUpdate sends every field the server reads', () {
    final json = const ServiceUpdate(
      title: 'Standard clean',
      basePrice: 4500,
      perBedroom: 1500,
      perBathroom: 1000,
      baseMinutes: 120,
      minutesPerRoom: 30,
    ).toJson();
    expect(json, {
      'title': 'Standard clean',
      'base_price': 4500,
      'per_bedroom': 1500,
      'per_bathroom': 1000,
      'base_minutes': 120,
      'minutes_per_room': 30,
      'is_active': true,
    });
  });

  test('Slot parses RFC 3339 UTC times', () {
    final slot = Slot.fromJson({
      'start': '2026-12-03T08:00:00Z',
      'available': true,
    });
    expect(slot.start, DateTime.utc(2026, 12, 3, 8));
    expect(slot.start.isUtc, isTrue);
  });

  test('timestamps with offsets and nanoseconds are read as UTC', () {
    final booking = Booking.fromJson({
      ...bookingJson(),
      'start': '2026-12-03T15:00:00+05:00',
      'created_at': '2026-11-20T06:35:52.018791123Z',
    });
    expect(booking.start, DateTime.utc(2026, 12, 3, 10));
    expect(booking.createdAt.isUtc, isTrue);
  });

  test('Booking round-trips', () {
    final json = bookingJson();
    final booking = Booking.fromJson(json);
    expect(booking.status, BookingStatus.assigned);
    expect(booking.cleanerId, cleanerId);
    expect(booking.requestedCleanerId, isNull);
    expect(booking.cleanerPayout, 5100);
    expect(booking.extras.single.title, 'Inside oven');
    expect(booking.end.difference(booking.start), const Duration(hours: 3));
    expect(
      jsonDecode(jsonEncode(booking.toJson())),
      {
        ...json,
        'start': '2026-12-03T10:00:00.000Z',
        'end': '2026-12-03T13:00:00.000Z',
        'created_at': '2026-11-20T06:35:52.018791Z',
        'updated_at': '2026-11-20T06:35:52.182969Z',
      },
    );
  });

  test('BookingDetails reads the flat booking plus its extras', () {
    final details = BookingDetails.fromJson({
      ...bookingJson(status: 'completed'),
      'address': addressJson(),
      'cleaner': {
        'id': cleanerId,
        'full_name': 'Sarah Jones',
        'avatar_url': null,
        'rating': 5,
        'rating_count': 1,
      },
      'last_location': {
        'lat': 51.5,
        'lng': -0.1,
        'at': '2026-12-03T09:40:00Z',
      },
      'events': [
        {
          'status': 'pending',
          'actor_id': clientId,
          'at': '2026-11-20T06:35:52.018791Z',
        },
        {
          'status': 'confirmed',
          'actor_id': null,
          'at': '2026-11-20T06:35:52.02453Z',
        },
      ],
      'review': {
        'booking_id': '5874d2af-ead1-4862-a807-260266e04e24',
        'cleaner_id': cleanerId,
        'rating': 5,
        'tags': ['thorough'],
        'comment': '',
        'tip': 500,
        'created_at': '2026-11-20T06:35:52.202293Z',
      },
    });
    expect(details.booking.status, BookingStatus.completed);
    expect(details.address.postcode, 'NW1 6XE');
    expect(details.cleaner?.fullName, 'Sarah Jones');
    expect(details.cleaner?.rating, 5.0);
    expect(details.lastLocation?.lat, 51.5);
    expect(details.events.last.actorId, isNull);
    expect(details.events.first.actorId, clientId);
    expect(details.review?.tip, 500);
    expect(details.review?.tags, ['thorough']);
  });

  test('BookingDetails before anyone is assigned', () {
    final details = BookingDetails.fromJson({
      ...bookingJson(status: 'confirmed'),
      'cleaner_id': null,
      'address': addressJson(),
      'cleaner': null,
      'last_location': null,
      'events': <Object>[],
      'review': null,
    });
    expect(details.cleaner, isNull);
    expect(details.lastLocation, isNull);
    expect(details.review, isNull);
    expect(details.events, isEmpty);
  });

  test('Job and AdminBooking keep the booking and the extra fields', () {
    final job = Job.fromJson({
      ...bookingJson(),
      'address': addressJson(),
      'client_name': 'Charlie Client',
    });
    expect(job.booking.code, 'TD-1000');
    expect(job.clientName, 'Charlie Client');
    expect(job.address.line1, '221B Baker Street');

    final page = AdminBookingPage.fromJson({
      'items': [
        {
          ...bookingJson(),
          'client_name': 'Charlie Client',
          'client_phone': '+447700900201',
          'cleaner_name': '',
        },
      ],
      'next_cursor': '',
    });
    expect(page.items.single.booking.id, startsWith('5874'));
    expect(page.items.single.clientPhone, '+447700900201');
    expect(page.items.single.cleanerName, isEmpty);
    expect(page.hasMore, isFalse);
  });

  test('pages: next_cursor is a string, empty on the last page', () {
    final more = BookingPage.fromJson({
      'items': [bookingJson()],
      'next_cursor': 'abc',
    });
    expect(more.hasMore, isTrue);
    expect(more.nextCursor, 'abc');

    final last = BookingPage.fromJson({'items': <Object>[], 'next_cursor': ''});
    expect(last.hasMore, isFalse);
    expect(last.items, isEmpty);
  });

  test('Offer from GET /cleaner/offers', () {
    final offer = Offer.fromJson({
      'booking': bookingJson(status: 'confirmed'),
      'expires_at': '2026-11-20T06:47:05.5Z',
      'distance_km': 3.2,
      'postcode': 'NW1 6XE',
      'city': 'London',
    });
    expect(offer.distanceKm, 3.2);
    expect(offer.postcode, 'NW1 6XE');
    expect(offer.booking.status, BookingStatus.confirmed);
  });

  test('Cancellation and BookingCreated', () {
    final cancelled = Cancellation.fromJson({
      'booking': bookingJson(status: 'cancelled'),
      'refunded': true,
    });
    expect(cancelled.refunded, isTrue);
    expect(cancelled.booking.status, BookingStatus.cancelled);

    final created = BookingCreated.fromJson({
      'booking': bookingJson(status: 'confirmed'),
      'payment': {'client_secret': 'mock_secret'},
    });
    expect(created.payment.clientSecret, 'mock_secret');
  });

  test('Earnings', () {
    final earnings = Earnings.fromJson({
      'period': 'week',
      'from': '2026-11-16',
      'to': '2026-11-22',
      'total': 5100,
      'tips': 500,
      'jobs': 1,
      'minutes': 180,
      'days': [
        {'date': '2026-11-16', 'amount': 5600},
      ],
      'recent': [
        {
          'booking_id': 'b1',
          'code': 'TD-1000',
          'service_title': 'Standard clean',
          'start': '2026-11-16T10:00:00Z',
          'minutes': 180,
          'amount': 5100,
          'tip': 500,
        },
      ],
    });
    expect(earnings.minutes, 180);
    expect(earnings.days.single.amount, 5600);
    expect(earnings.recent.single.tip, 500);
    expect(earnings.recent.single.start, DateTime.utc(2026, 11, 16, 10));
  });

  test('CreateBookingRequest sends UTC and skips an empty cleaner', () {
    final local = DateTime.utc(2026, 12, 3, 8).toLocal();
    final request = CreateBookingRequest(
      serviceId: 's1',
      bedrooms: 2,
      bathrooms: 1,
      addressId: 'a1',
      start: local,
      extraIds: const ['e1'],
      frequency: Frequency.weekly,
    );
    final json = request.toJson();
    expect(json['service_id'], 's1');
    expect(json['address_id'], 'a1');
    expect(json['extra_ids'], ['e1']);
    expect(json['frequency'], 'weekly');
    expect(json['start'], '2026-12-03T08:00:00.000Z');
    expect(json.containsKey('cleaner_id'), isFalse);
  });

  test('VerifyRequest and AdminBookingPatch leave out unset fields', () {
    expect(
      const VerifyRequest(phone: '+447700900001', code: '123456').toJson(),
      {'phone': '+447700900001', 'code': '123456'},
    );
    expect(
      const VerifyRequest(
        phone: '+447700900201',
        code: '123456',
        role: UserRole.client,
      ).toJson()['role'],
      'client',
    );
    expect(
      const AdminBookingPatch(status: BookingStatus.cancelled).toJson(),
      {'status': 'cancelled'},
    );
  });

  test('User: client without and cleaner with a profile', () {
    final client = User.fromJson(userJson());
    expect(client.role, UserRole.client);
    expect(client.email, isNull);
    expect(client.cleaner, isNull);
    expect(client.createdAt, DateTime.utc(2026, 11, 20, 6, 35, 11, 249, 316));

    final user = User.fromJson({
      ...userJson(role: 'cleaner'),
      'cleaner': cleanerJson(),
    });
    final cleaner = user.cleaner!;
    expect(cleaner.status, CleanerStatus.approved);
    expect(cleaner.rating, 5.0);
    expect(cleaner.isOnline, isTrue);
    expect(cleaner.lastLat, 51.5115);
    expect(cleaner.lastSeenAt, isNotNull);
  });

  group('ApiError.fromEnvelope', () {
    test('reads the documented envelope', () {
      final error = ApiError.fromEnvelope({
        'error': {
          'code': 'invalid_request',
          'message': 'Some fields are invalid.',
          'details': {'bedrooms': 'must be between 1 and 10'},
        },
      });
      expect(error?.code, 'invalid_request');
      expect(error?.details, {'bedrooms': 'must be between 1 and 10'});
    });

    test('returns null for anything else', () {
      expect(ApiError.fromEnvelope('<html>Bad gateway</html>'), isNull);
      expect(ApiError.fromEnvelope({'error': 'boom'}), isNull);
    });
  });
}
