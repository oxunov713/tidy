import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fake_adapter.dart';

ApiClient _client(FakeAdapter adapter) => ApiClient(
  config: const ApiConfig(baseUrl: 'http://test'),
  tokenStorage: InMemoryTokenStorage(),
  httpClientAdapter: adapter,
);

Map<String, Object> _error(String code, [String message = 'nope']) => {
  'error': {'code': code, 'message': message},
};

void main() {
  Future<Object?> failWith(FakeResponse response) async {
    final client = _client(FakeAdapter((_) => response));
    try {
      await client.catalog.services();
    } on Object catch (e) {
      return e;
    }
    return null;
  }

  test('maps documented error codes to subtypes', () async {
    expect(
      await failWith(FakeResponse(409, _error('slot_taken'))),
      isA<SlotTakenException>(),
    );
    expect(
      await failWith(FakeResponse(409, _error('invalid_transition'))),
      isA<InvalidTransitionException>(),
    );
    expect(
      await failWith(FakeResponse(403, _error('forbidden'))),
      isA<ForbiddenException>(),
    );
    expect(
      await failWith(FakeResponse(404, _error('not_found'))),
      isA<NotFoundException>(),
    );
    expect(
      await failWith(FakeResponse(409, _error('offer_gone'))),
      isA<OfferGoneException>(),
    );
    expect(
      await failWith(FakeResponse(429, _error('too_many_requests'))),
      isA<TooManyRequestsException>(),
    );
    final internal = await failWith(FakeResponse(500, _error('internal')));
    expect(internal, isA<ServerException>());
    expect((internal! as ServerException).code, 'internal');
  });

  test('keeps message and details for invalid_request', () async {
    final error = await failWith(
      const FakeResponse(400, {
        'error': {
          'code': 'invalid_request',
          'message': 'bad phone',
          'details': {'phone': 'required'},
        },
      }),
    );
    expect(error, isA<InvalidRequestException>());
    final e = error! as InvalidRequestException;
    expect(e.message, 'bad phone');
    expect(e.details, {'phone': 'required'});
  });

  test('falls back to the status when the body is not an envelope', () async {
    expect(
      await failWith(const FakeResponse(502, 'Bad gateway')),
      isA<ServerException>(),
    );
    expect(
      await failWith(const FakeResponse(404)),
      isA<NotFoundException>(),
    );
  });

  test('connection failures become NetworkException', () async {
    final client = _client(
      FakeAdapter(
        (o) => throw DioException.connectionError(
          requestOptions: o,
          reason: 'offline',
        ),
      ),
    );
    await expectLater(
      client.catalog.services(),
      throwsA(isA<NetworkException>()),
    );
  });

  test('typed endpoints decode lists', () async {
    final client = _client(
      FakeAdapter(
        (_) => const FakeResponse(200, [
          {
            'id': 'e1',
            'slug': 'oven',
            'title': 'Inside oven',
            'price': 2000,
          },
        ]),
      ),
    );
    final extras = await client.catalog.extras();
    expect(extras.single.price, 2000);
  });
}
