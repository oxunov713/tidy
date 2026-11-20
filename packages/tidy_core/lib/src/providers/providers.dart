import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_core/src/api/admin_api.dart';
import 'package:tidy_core/src/api/api_client.dart';
import 'package:tidy_core/src/api/api_config.dart';
import 'package:tidy_core/src/api/auth_api.dart';
import 'package:tidy_core/src/api/booking_api.dart';
import 'package:tidy_core/src/api/catalog_api.dart';
import 'package:tidy_core/src/api/cleaner_api.dart';
import 'package:tidy_core/src/api/me_api.dart';
import 'package:tidy_core/src/auth/token_storage.dart';
import 'package:tidy_core/src/map/map_provider.dart';
import 'package:tidy_core/src/map/yandex_map_provider.dart';
import 'package:tidy_core/src/realtime/realtime_client.dart';
import 'package:tidy_core/src/realtime/realtime_event.dart';

part 'providers.g.dart';

/// Reads `--dart-define=API_URL=...`; defaults to `http://localhost:8080`.
@Riverpod(keepAlive: true)
ApiConfig apiConfig(Ref ref) => const ApiConfig.fromEnvironment();

/// Override with `InMemoryTokenStorage` in tests.
@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) => SecureTokenStorage();

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final client = ApiClient(
    config: ref.watch(apiConfigProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
  ref.onDispose(client.close);
  return client;
}

@Riverpod(keepAlive: true)
AuthApi authApi(Ref ref) => ref.watch(apiClientProvider).auth;

@Riverpod(keepAlive: true)
MeApi meApi(Ref ref) => ref.watch(apiClientProvider).me;

@Riverpod(keepAlive: true)
CatalogApi catalogApi(Ref ref) => ref.watch(apiClientProvider).catalog;

@Riverpod(keepAlive: true)
BookingApi bookingApi(Ref ref) => ref.watch(apiClientProvider).bookings;

@Riverpod(keepAlive: true)
CleanerApi cleanerApi(Ref ref) => ref.watch(apiClientProvider).cleaner;

@Riverpod(keepAlive: true)
AdminApi adminApi(Ref ref) => ref.watch(apiClientProvider).admin;

/// Emits when the refresh token was rejected; route back to sign-in.
@Riverpod(keepAlive: true)
Stream<void> sessionExpired(Ref ref) =>
    ref.watch(apiClientProvider).sessionExpired;

/// The shared WebSocket. Call `connect()` after sign-in and `disconnect()`
/// on sign-out.
@Riverpod(keepAlive: true)
RealtimeClient realtimeClient(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final client = RealtimeClient(
    config: ref.watch(apiConfigProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
    onHandshakeFailed: api.refreshSession,
  );
  ref.onDispose(client.dispose);
  return client;
}

@Riverpod(keepAlive: true)
Stream<RealtimeEvent> realtimeEvents(Ref ref) =>
    ref.watch(realtimeClientProvider).events;

/// Swap this override to change the map SDK.
@Riverpod(keepAlive: true)
MapProvider mapProvider(Ref ref) => const YandexMapProvider();
