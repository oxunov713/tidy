import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fake_adapter.dart';
import 'support/fixtures.dart';

void main() {
  late FakeAdapter adapter;

  ApiClient clientFor(FakeHandler handler) {
    adapter = FakeAdapter(handler);
    return ApiClient(
      config: const ApiConfig(baseUrl: 'http://test'),
      tokenStorage: InMemoryTokenStorage(
        const TokenPair(accessToken: 'a', refreshToken: 'r'),
      ),
      httpClientAdapter: adapter,
    );
  }

  Map<String, Object?> cancelledJson({bool planEnded = false}) => {
    'booking': bookingJson(status: 'cancelled'),
    'refunded': true,
    'plan_ended': planEnded,
  };

  test('cancel sends the scope, visit by default', () async {
    final client = clientFor((_) => FakeResponse(200, cancelledJson()));

    final visit = await client.bookings.cancel('b1');
    final series = await client.bookings.cancel(
      'b1',
      scope: CancelScope.series,
    );

    expect(adapter.requests[0].data, {'scope': 'visit'});
    expect(adapter.requests[1].data, {'scope': 'series'});
    expect(visit.planEnded, isFalse);
    expect(series.refunded, isTrue);
  });

  test('cancel reports plan_ended', () async {
    final client = clientFor(
      (_) => FakeResponse(200, cancelledJson(planEnded: true)),
    );
    final result = await client.bookings.cancel(
      'b1',
      scope: CancelScope.series,
    );
    expect(result.planEnded, isTrue);
  });

  test('pay posts to /bookings/{id}/payment', () async {
    final client = clientFor(
      (_) => const FakeResponse(200, {
        'kind': 'payment',
        'client_secret': 'pi_9_secret',
      }),
    );
    final payment = await client.bookings.pay('b1');
    expect(adapter.requests.single.path, '/bookings/b1/payment');
    expect(adapter.requests.single.method, 'POST');
    expect(payment.kind, PaymentKind.payment);
    expect(payment.clientSecret, 'pi_9_secret');
  });

  test('plans lists GET /plans', () async {
    final client = clientFor(
      (_) => const FakeResponse(200, [
        {
          'id': 'p1',
          'frequency': 'weekly',
          'next_run_on': '2026-12-10',
          'service_title': 'Standard clean',
          'start_time': '09:30',
          'address_id': 'a1',
        },
      ]),
    );
    final plans = await client.bookings.plans();
    expect(adapter.requests.single.path, '/plans');
    expect(plans.single.id, 'p1');
    expect(plans.single.nextRunOn, DateTime(2026, 12, 10));
  });

  test('endPlan sends DELETE /plans/{id}', () async {
    final client = clientFor((_) => const FakeResponse(204));
    await client.bookings.endPlan('p1');
    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/plans/p1');
  });

  test('unregisterDevice sends DELETE /me/devices/{token}, escaped', () async {
    final client = clientFor((_) => const FakeResponse(204));
    await client.me.unregisterDevice('fcm:abc/def');
    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/me/devices/fcm%3Aabc%2Fdef');
  });

  test('verify can send the admin role', () async {
    final client = clientFor(
      (_) => FakeResponse(200, {
        'access_token': 'a',
        'refresh_token': 'r',
        'user': userJson(role: 'admin'),
      }),
    );
    await client.auth.verify(
      phone: '+447700900001',
      code: '123456',
      role: UserRole.admin,
    );
    expect(adapter.requests.single.data, containsPair('role', 'admin'));
  });

  test(
    'a role mismatch is a ForbiddenException with the server message',
    () async {
      final client = clientFor(
        (_) => const FakeResponse(403, {
          'error': {
            'code': 'forbidden',
            'message': 'This number is registered as a cleaner.',
          },
        }),
      );
      await expectLater(
        client.auth.verify(
          phone: '+447700900123',
          code: '123456',
          role: UserRole.client,
        ),
        throwsA(
          isA<ForbiddenException>().having(
            (e) => e.message,
            'message',
            'This number is registered as a cleaner.',
          ),
        ),
      );
    },
  );
}
