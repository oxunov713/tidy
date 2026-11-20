import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

void main() {
  test('Quote parses the API.md example and round-trips', () {
    const json = {
      'subtotal': 8000,
      'discount': 1200,
      'total': 6800,
      'minutes': 150,
      'lines': [
        {'label': 'Standard clean · 2 bed, 1 bath', 'amount': 6000},
        {'label': 'Inside oven', 'amount': 2000},
        {'label': 'Weekly discount (15%)', 'amount': -1200},
      ],
    };
    final quote = Quote.fromJson(json);
    expect(quote.total, 6800);
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

  test('Slot parses RFC 3339 UTC times', () {
    final slot = Slot.fromJson({
      'start': '2026-12-03T08:00:00Z',
      'available': true,
    });
    expect(slot.start, DateTime.utc(2026, 12, 3, 8));
    expect(slot.start.isUtc, isTrue);
  });

  test('Booking with nested cleaner, location and events round-trips', () {
    final json = {
      'id': 'b1',
      'status': 'on_the_way',
      'start': '2026-12-03T08:00:00.000Z',
      'code': 'TD-1042',
      'service_id': 's1',
      'service_title': 'Standard clean',
      'bedrooms': 2,
      'bathrooms': 1,
      'frequency': 'weekly',
      'end': null,
      'minutes': 150,
      'subtotal': 8000,
      'discount': 1200,
      'total': 6800,
      'extras': <Object>[],
      'address': {
        'id': 'a1',
        'line1': '12 Baker Street',
        'city': 'London',
        'postcode': 'NW1 6XE',
        'lat': 51.52,
        'lng': -0.15,
        'line2': '',
        'access_notes': 'Key under the mat',
      },
      'cleaner': {
        'id': 'c1',
        'full_name': 'Sarah Jones',
        'phone': null,
        'avatar_url': null,
        'status': 'approved',
        'bio': '',
        'rating': 4.9,
        'rating_count': 120,
        'online': true,
      },
      'client': null,
      'cleaner_location': {
        'lat': 51.5,
        'lng': -0.1,
        'eta_minutes': 12,
        'at': null,
      },
      'events': [
        {'status': 'assigned', 'at': '2026-12-02T10:00:00.000Z'},
      ],
    };
    final booking = Booking.fromJson(json);
    expect(booking.status, BookingStatus.onTheWay);
    expect(booking.cleaner?.fullName, 'Sarah Jones');
    expect(booking.cleanerLocation?.etaMinutes, 12);
    expect(booking.events.single.status, BookingStatus.assigned);
    expect(jsonDecode(jsonEncode(booking.toJson())), json);
  });

  test('CreateBookingRequest omits nothing the API needs', () {
    final request = CreateBookingRequest(
      serviceId: 's1',
      bedrooms: 2,
      bathrooms: 1,
      addressId: 'a1',
      start: DateTime.utc(2026, 12, 3, 8),
      extraIds: const ['e1'],
      frequency: Frequency.weekly,
    );
    final json = request.toJson();
    expect(json['service_id'], 's1');
    expect(json['address_id'], 'a1');
    expect(json['extra_ids'], ['e1']);
    expect(json['frequency'], 'weekly');
    expect(json['start'], '2026-12-03T08:00:00.000Z');
  });

  test('User with a cleaner object decodes', () {
    final user = User.fromJson({
      'id': 'u1',
      'role': 'cleaner',
      'phone': '+447700900123',
      'full_name': 'Sarah',
      'cleaner': {'id': 'u1', 'status': 'pending'},
    });
    expect(user.role, UserRole.cleaner);
    expect(user.cleaner?.status, CleanerStatus.pending);
    expect(user.cleaner?.online, isFalse);
  });

  group('ApiError.fromEnvelope', () {
    test('reads the documented envelope', () {
      final error = ApiError.fromEnvelope({
        'error': {
          'code': 'slot_taken',
          'message': 'This time was just booked by someone else.',
        },
      });
      expect(error?.code, 'slot_taken');
    });

    test('returns null for anything else', () {
      expect(ApiError.fromEnvelope('<html>Bad gateway</html>'), isNull);
      expect(ApiError.fromEnvelope({'error': 'boom'}), isNull);
    });
  });
}
