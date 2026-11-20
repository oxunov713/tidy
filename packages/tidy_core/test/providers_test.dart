import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

void main() {
  test('providers wire the client with the configured base url', () {
    final container = ProviderContainer(
      overrides: [
        tokenStorageProvider.overrideWithValue(InMemoryTokenStorage()),
        apiConfigProvider.overrideWithValue(
          const ApiConfig(baseUrl: 'https://tidy.test/'),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(bookingApiProvider), isA<BookingApi>());
    expect(container.read(realtimeClientProvider), isA<RealtimeClient>());
    expect(container.read(mapProviderProvider), isA<MapProvider>());
    expect(
      container.read(apiConfigProvider).restBase,
      'https://tidy.test/api/v1',
    );
  });

  test('default base url points at the local backend', () {
    expect(
      const ApiConfig.fromEnvironment().baseUrl,
      'http://localhost:8080',
    );
  });

  test('websocket uri swaps the scheme', () {
    const config = ApiConfig(baseUrl: 'http://10.0.2.2:8080');
    expect(
      config.websocketUri('abc').toString(),
      'ws://10.0.2.2:8080/api/v1/ws?token=abc',
    );
  });
}
