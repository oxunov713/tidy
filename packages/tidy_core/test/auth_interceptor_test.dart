import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fake_adapter.dart';
import 'support/fixtures.dart';

const _old = TokenPair(accessToken: 'old-access', refreshToken: 'old-refresh');

Map<String, Object?> _servicesJson() => addressJson();

void main() {
  late InMemoryTokenStorage storage;

  setUp(() => storage = InMemoryTokenStorage(_old));

  ApiClient clientFor(FakeAdapter adapter) => ApiClient(
    config: const ApiConfig(baseUrl: 'http://test'),
    tokenStorage: storage,
    httpClientAdapter: adapter,
  );

  test('sends the bearer token', () async {
    final adapter = FakeAdapter((_) => const FakeResponse(200, <Object>[]));
    await clientFor(adapter).me.addresses();
    expect(
      adapter.requests.single.headers['Authorization'],
      'Bearer old-access',
    );
  });

  test('public catalogue calls carry no token', () async {
    final adapter = FakeAdapter(
      (o) => o.path == '/quotes'
          ? const FakeResponse(200, {
              'subtotal': 4500,
              'discount': 0,
              'total': 4500,
              'minutes': 120,
              'lines': <Object>[],
            })
          : const FakeResponse(200, <Object>[]),
    );
    final client = clientFor(adapter);
    await client.catalog.services();
    await client.catalog.extras();
    await client.bookings.quote(
      const QuoteRequest(serviceId: 's1', bedrooms: 1, bathrooms: 1),
    );
    expect(adapter.requests, hasLength(3));
    expect(
      adapter.requests.map((r) => r.headers['Authorization']),
      everyElement(isNull),
    );
  });

  test('refreshes once on 401 and retries with the new token', () async {
    final adapter = FakeAdapter((o) {
      if (o.path == '/auth/refresh') {
        return const FakeResponse(200, {
          'access_token': 'new-access',
          'refresh_token': 'new-refresh',
        });
      }
      return o.headers['Authorization'] == 'Bearer new-access'
          ? FakeResponse(200, [_servicesJson()])
          : const FakeResponse(401, {
              'error': {'code': 'unauthorized', 'message': 'expired'},
            });
    });
    final client = clientFor(adapter);

    final services = await client.me.addresses();

    expect(services, hasLength(1));
    expect(adapter.count('/auth/refresh'), 1);
    expect(adapter.count('/me/addresses'), 2);
    final stored = await storage.read();
    expect(stored?.accessToken, 'new-access');
    expect(stored?.refreshToken, 'new-refresh');
  });

  test('concurrent 401s share a single refresh', () async {
    final gate = Completer<void>();
    final adapter = FakeAdapter((o) async {
      if (o.path == '/auth/refresh') {
        // Hold the refresh open so every request is already waiting on it.
        await gate.future;
        return const FakeResponse(200, {
          'access_token': 'new-access',
          'refresh_token': 'new-refresh',
        });
      }
      return o.headers['Authorization'] == 'Bearer new-access'
          ? FakeResponse(200, [_servicesJson()])
          : const FakeResponse(401, {
              'error': {'code': 'unauthorized', 'message': 'expired'},
            });
    });
    final client = clientFor(adapter);

    final calls = [for (var i = 0; i < 5; i++) client.me.addresses()];
    // Let all five reach their 401 before the refresh may finish.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(adapter.count('/auth/refresh'), 1);
    gate.complete();
    final results = await Future.wait(calls);

    expect(results, everyElement(hasLength(1)));
    expect(adapter.count('/auth/refresh'), 1);
    expect(adapter.count('/me/addresses'), 10);
  });

  test('a late 401 from the old token does not refresh again', () async {
    final slow = Completer<void>();
    var firstServicesCall = true;
    final adapter = FakeAdapter((o) async {
      if (o.path == '/auth/refresh') {
        return const FakeResponse(200, {
          'access_token': 'new-access',
          'refresh_token': 'new-refresh',
        });
      }
      if (o.headers['Authorization'] == 'Bearer new-access') {
        return FakeResponse(200, [_servicesJson()]);
      }
      // The first request answers 401 immediately, the second one only after
      // the refresh is done.
      if (firstServicesCall) {
        firstServicesCall = false;
      } else {
        await slow.future;
      }
      return const FakeResponse(401, {
        'error': {'code': 'unauthorized', 'message': 'expired'},
      });
    });
    final client = clientFor(adapter);

    final first = client.me.addresses();
    final second = client.me.addresses();
    await first;
    slow.complete();
    await second;

    expect(adapter.count('/auth/refresh'), 1);
  });

  test(
    'failed refresh clears tokens, signals and throws Unauthorized',
    () async {
      final adapter = FakeAdapter((o) {
        return FakeResponse(401, {
          'error': {
            'code': 'unauthorized',
            'message': o.path == '/auth/refresh' ? 'revoked' : 'expired',
          },
        });
      });
      final client = clientFor(adapter);
      var expired = 0;
      client.sessionExpired.listen((_) => expired++);

      await expectLater(
        client.me.addresses(),
        throwsA(isA<UnauthorizedException>()),
      );
      await Future<void>.delayed(Duration.zero);

      expect(await storage.read(), isNull);
      expect(expired, 1);
      expect(adapter.count('/me/addresses'), 1);
    },
  );

  test(
    'does not retry a request that fails with 401 again after refresh',
    () async {
      final adapter = FakeAdapter((o) {
        if (o.path == '/auth/refresh') {
          return const FakeResponse(200, {
            'access_token': 'new-access',
            'refresh_token': 'new-refresh',
          });
        }
        return const FakeResponse(401, {
          'error': {'code': 'unauthorized', 'message': 'still no'},
        });
      });
      final client = clientFor(adapter);

      await expectLater(
        client.me.addresses(),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(adapter.count('/me/addresses'), 2);
      expect(adapter.count('/auth/refresh'), 1);
    },
  );

  test('auth endpoints never trigger a refresh', () async {
    final adapter = FakeAdapter(
      (_) => const FakeResponse(401, {
        'error': {'code': 'unauthorized', 'message': 'bad code'},
      }),
    );
    final client = clientFor(adapter);

    await expectLater(
      client.auth.verify(
        phone: '+447700900123',
        code: '000000',
        role: UserRole.client,
      ),
      throwsA(isA<UnauthorizedException>()),
    );
    expect(adapter.count('/auth/refresh'), 0);
    expect(
      adapter.requests.single.headers.containsKey('Authorization'),
      isFalse,
    );
  });

  test('verify stores the returned tokens', () async {
    storage = InMemoryTokenStorage();
    final adapter = FakeAdapter(
      (_) => FakeResponse(200, {
        'access_token': 'a',
        'refresh_token': 'r',
        'user': userJson(),
      }),
    );
    final session = await clientFor(adapter).auth.verify(
      phone: '+447700900123',
      code: '123456',
      role: UserRole.client,
    );
    expect(session.user.id, clientId);
    expect((await storage.read())?.refreshToken, 'r');
    expect(adapter.requests.single.data, {
      'phone': '+447700900123',
      'code': '123456',
      'role': 'client',
    });
  });

  test('verify without a role (existing accounts, admin) omits it', () async {
    storage = InMemoryTokenStorage();
    final adapter = FakeAdapter(
      (_) => FakeResponse(200, {
        'access_token': 'a',
        'refresh_token': 'r',
        'user': userJson(role: 'admin'),
      }),
    );
    final session = await clientFor(adapter).auth.verify(
      phone: '+447700900001',
      code: '123456',
    );
    expect(session.user.role, UserRole.admin);
    expect(adapter.requests.single.data, {
      'phone': '+447700900001',
      'code': '123456',
    });
  });
}
