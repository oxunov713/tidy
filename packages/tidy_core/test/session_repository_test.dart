import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fake_adapter.dart';
import 'support/fixtures.dart';

const _tokens = TokenPair(accessToken: 'access', refreshToken: 'refresh');

class _Push implements PushService {
  _Push({this.deviceToken = 'fcm-1'});

  final String? deviceToken;
  final refreshes = StreamController<String>.broadcast();
  int initialised = 0;

  @override
  Future<void> initialize() async => initialised++;

  @override
  Future<String?> token() async => deviceToken;

  @override
  Stream<String> get tokenRefreshes => refreshes.stream;
}

Map<String, Object?> _verifyBody(String role) => {
  'access_token': 'new-access',
  'refresh_token': 'new-refresh',
  'user': userJson(role: role),
};

void main() {
  late InMemoryTokenStorage storage;
  late FakeAdapter adapter;
  late _Push push;

  SessionRepository repo(
    UserRole role,
    FakeHandler handler, {
    TokenPair? stored = _tokens,
  }) {
    storage = InMemoryTokenStorage(stored);
    adapter = FakeAdapter(handler);
    push = _Push();
    return SessionRepository(
      expectedRole: role,
      api: ApiClient(
        config: const ApiConfig(baseUrl: 'http://test'),
        tokenStorage: storage,
        httpClientAdapter: adapter,
      ),
      storage: storage,
      push: push,
      platform: DevicePlatform.android,
    );
  }

  String calls() =>
      adapter.requests.map((r) => '${r.method} ${r.path}').join(', ');

  group('restore', () {
    test('without tokens there is nothing to restore', () async {
      final session = repo(
        UserRole.client,
        (_) => const FakeResponse(500),
        stored: null,
      );
      expect(await session.restore(), isNull);
      expect(adapter.requests, isEmpty);
    });

    test('returns the user and registers the device', () async {
      final session = repo(UserRole.client, (o) {
        if (o.path == '/me') {
          return FakeResponse(200, userJson());
        }
        return const FakeResponse(204);
      });

      final user = await session.restore();

      expect(user?.id, clientId);
      expect(calls(), 'GET /me, POST /me/devices');
      expect(adapter.requests.last.data, {
        'token': 'fcm-1',
        'platform': 'android',
      });
    });

    test('offline keeps the session and rethrows for a retry', () async {
      final session = repo(UserRole.cleaner, (o) {
        throw DioException.connectionError(
          requestOptions: o,
          reason: 'offline',
        );
      });

      await expectLater(session.restore(), throwsA(isA<NetworkException>()));
      expect(await storage.read(), _tokens);
    });

    test('a 503 keeps the session and rethrows', () async {
      final session = repo(
        UserRole.cleaner,
        (_) => const FakeResponse(503, {
          'error': {'code': 'internal', 'message': 'down'},
        }),
      );
      await expectLater(session.restore(), throwsA(isA<ServerException>()));
      expect(await storage.read(), _tokens);
    });

    test('tokens the server rejects end the session', () async {
      final session = repo(
        UserRole.client,
        (_) => const FakeResponse(401, {
          'error': {'code': 'unauthorized', 'message': 'no'},
        }),
      );
      expect(await session.restore(), isNull);
      expect(await storage.read(), isNull);
    });

    test('an account with another role is signed out', () async {
      final session = repo(UserRole.cleaner, (o) {
        if (o.path == '/me') {
          return FakeResponse(200, userJson());
        }
        return const FakeResponse(204);
      });

      expect(await session.restore(), isNull);
      expect(await storage.read(), isNull);
      expect(calls(), contains('POST /auth/logout'));
    });
  });

  group('verify', () {
    for (final (role, name) in [
      (UserRole.client, 'client'),
      (UserRole.cleaner, 'cleaner'),
      (UserRole.admin, 'admin'),
    ]) {
      test('sends role "$name"', () async {
        final session = repo(role, (o) {
          if (o.path == '/auth/verify') {
            return FakeResponse(200, _verifyBody(name));
          }
          if (o.path == '/me') {
            return FakeResponse(200, userJson(role: name));
          }
          return const FakeResponse(204);
        }, stored: null);

        final user = await session.verify(
          phone: '+447700900123',
          code: '123456',
        );

        expect(user.role, role);
        expect(adapter.requests.first.data, {
          'phone': '+447700900123',
          'code': '123456',
          'role': name,
        });
        expect((await storage.read())?.accessToken, 'new-access');
      });
    }

    test('the cleaner profile comes from /me (verify has none)', () async {
      final session = repo(UserRole.cleaner, (o) {
        if (o.path == '/auth/verify') {
          return FakeResponse(200, _verifyBody('cleaner'));
        }
        if (o.path == '/me') {
          return FakeResponse(200, {
            ...userJson(role: 'cleaner'),
            'cleaner': cleanerJson(),
          });
        }
        return const FakeResponse(204);
      }, stored: null);

      final user = await session.verify(phone: '+447700900123', code: '1');
      expect(user.cleaner?.status, CleanerStatus.approved);
    });

    test(
      'a registered number with another role gets the server message',
      () async {
        final session = repo(
          UserRole.client,
          (_) => const FakeResponse(403, {
            'error': {
              'code': 'forbidden',
              'message': 'This number is registered as a cleaner.',
            },
          }),
          stored: null,
        );

        await expectLater(
          session.verify(phone: '+447700900123', code: '123456'),
          throwsA(
            isA<ForbiddenException>().having(
              (e) => e.message,
              'message',
              'This number is registered as a cleaner.',
            ),
          ),
        );
        expect(await storage.read(), isNull);
      },
    );

    test('an admin that is not one is refused (403)', () async {
      final session = repo(
        UserRole.admin,
        (_) => const FakeResponse(403, {
          'error': {'code': 'forbidden', 'message': 'Not an admin.'},
        }),
        stored: null,
      );
      await expectLater(
        session.verify(phone: '+447700900123', code: '123456'),
        throwsA(isA<ForbiddenException>()),
      );
    });

    test('a server that lets the wrong role through is caught here', () async {
      final session = repo(UserRole.client, (o) {
        if (o.path == '/auth/verify') {
          return FakeResponse(200, _verifyBody('cleaner'));
        }
        return const FakeResponse(204);
      }, stored: null);

      await expectLater(
        session.verify(phone: '+447700900123', code: '123456'),
        throwsA(
          isA<WrongRoleException>()
              .having((e) => e.expected, 'expected', UserRole.client)
              .having((e) => e.actual, 'actual', UserRole.cleaner),
        ),
      );
      expect(await storage.read(), isNull, reason: 'signed out again');
    });

    test('push that fails never blocks signing in', () async {
      final session = repo(UserRole.client, (o) {
        if (o.path == '/auth/verify') {
          return FakeResponse(200, _verifyBody('client'));
        }
        return const FakeResponse(500);
      }, stored: null);
      final user = await session.verify(phone: '+447700900123', code: '1');
      expect(user.role, UserRole.client);
    });
  });

  group('logout', () {
    test('a cleaner goes offline, drops the device, then signs out', () async {
      final session = repo(UserRole.cleaner, (_) => const FakeResponse(204));

      await session.logout();

      expect(
        calls(),
        [
          'DELETE /me/devices/fcm-1',
          'POST /cleaner/online',
          'POST /auth/logout',
        ].join(', '),
      );
      expect(adapter.requests[1].data, {'online': false});
      expect(await storage.read(), isNull);
    });

    test('a client does not touch the online switch', () async {
      final session = repo(UserRole.client, (_) => const FakeResponse(204));
      await session.logout();
      expect(calls(), 'DELETE /me/devices/fcm-1, POST /auth/logout');
    });

    test('server errors never keep a user signed in', () async {
      final session = repo(UserRole.cleaner, (_) => const FakeResponse(500));
      await session.logout();
      expect(await storage.read(), isNull);
      expect(adapter.requests.last.path, '/auth/logout');
    });

    test('offline: still signed out locally', () async {
      final session = repo(UserRole.cleaner, (o) {
        throw DioException.connectionError(
          requestOptions: o,
          reason: 'offline',
        );
      });
      await session.logout();
      expect(await storage.read(), isNull);
    });

    test('without a push token there is no device to delete', () async {
      final session = repo(UserRole.client, (_) => const FakeResponse(204));
      push = _Push(deviceToken: null);
      // Rebuild with a push service that has no token.
      final noToken = SessionRepository(
        expectedRole: UserRole.client,
        api: ApiClient(
          config: const ApiConfig(baseUrl: 'http://test'),
          tokenStorage: storage,
          httpClientAdapter: adapter,
        ),
        storage: storage,
        push: push,
      );
      await noToken.logout();
      expect(calls(), 'POST /auth/logout');
      expect(session.expectedRole, UserRole.client);
    });
  });

  test('a rotated push token is registered again', () async {
    final session = repo(UserRole.client, (o) {
      if (o.path == '/me') {
        return FakeResponse(200, userJson());
      }
      return const FakeResponse(204);
    });
    await session.restore();
    adapter.requests.clear();

    push.refreshes.add('fcm-2');
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(calls(), 'POST /me/devices');
    expect(adapter.requests.single.data, containsPair('token', 'fcm-2'));
  });

  test('NoopPushService registers nothing', () async {
    storage = InMemoryTokenStorage(_tokens);
    adapter = FakeAdapter((o) {
      if (o.path == '/me') {
        return FakeResponse(200, userJson());
      }
      return const FakeResponse(204);
    });
    final session = SessionRepository(
      expectedRole: UserRole.client,
      api: ApiClient(
        config: const ApiConfig(baseUrl: 'http://test'),
        tokenStorage: storage,
        httpClientAdapter: adapter,
      ),
      storage: storage,
    );
    await session.restore();
    expect(calls(), 'GET /me');
  });
}
