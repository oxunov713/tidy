// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reads `--dart-define=API_URL=...`; defaults to `http://localhost:8080`.

@ProviderFor(apiConfig)
final apiConfigProvider = ApiConfigProvider._();

/// Reads `--dart-define=API_URL=...`; defaults to `http://localhost:8080`.

final class ApiConfigProvider
    extends $FunctionalProvider<ApiConfig, ApiConfig, ApiConfig>
    with $Provider<ApiConfig> {
  /// Reads `--dart-define=API_URL=...`; defaults to `http://localhost:8080`.
  ApiConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiConfigHash();

  @$internal
  @override
  $ProviderElement<ApiConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiConfig create(Ref ref) {
    return apiConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiConfig>(value),
    );
  }
}

String _$apiConfigHash() => r'd6209511fd6c681a128b18fbbb928cba9ad64f6a';

/// Override with `InMemoryTokenStorage` in tests.

@ProviderFor(tokenStorage)
final tokenStorageProvider = TokenStorageProvider._();

/// Override with `InMemoryTokenStorage` in tests.

final class TokenStorageProvider
    extends $FunctionalProvider<TokenStorage, TokenStorage, TokenStorage>
    with $Provider<TokenStorage> {
  /// Override with `InMemoryTokenStorage` in tests.
  TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $ProviderElement<TokenStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStorage create(Ref ref) {
    return tokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorage>(value),
    );
  }
}

String _$tokenStorageHash() => r'dd46faaf319c003e67245b3421a841d3c20ae63a';

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'ec6faeed2ea905f34f3333674519fcc52c8307d1';

@ProviderFor(authApi)
final authApiProvider = AuthApiProvider._();

final class AuthApiProvider
    extends $FunctionalProvider<AuthApi, AuthApi, AuthApi>
    with $Provider<AuthApi> {
  AuthApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authApiHash();

  @$internal
  @override
  $ProviderElement<AuthApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthApi create(Ref ref) {
    return authApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthApi>(value),
    );
  }
}

String _$authApiHash() => r'4b8dd81f3bd739fbd34211df58363c269e3d46b0';

@ProviderFor(meApi)
final meApiProvider = MeApiProvider._();

final class MeApiProvider extends $FunctionalProvider<MeApi, MeApi, MeApi>
    with $Provider<MeApi> {
  MeApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meApiHash();

  @$internal
  @override
  $ProviderElement<MeApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MeApi create(Ref ref) {
    return meApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeApi>(value),
    );
  }
}

String _$meApiHash() => r'e72d1465d80825e4a43f65d898b730a0968b2eb5';

@ProviderFor(catalogApi)
final catalogApiProvider = CatalogApiProvider._();

final class CatalogApiProvider
    extends $FunctionalProvider<CatalogApi, CatalogApi, CatalogApi>
    with $Provider<CatalogApi> {
  CatalogApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogApiHash();

  @$internal
  @override
  $ProviderElement<CatalogApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CatalogApi create(Ref ref) {
    return catalogApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogApi>(value),
    );
  }
}

String _$catalogApiHash() => r'df2939525cd553d391805d7ebbad9102039bf7b1';

@ProviderFor(bookingApi)
final bookingApiProvider = BookingApiProvider._();

final class BookingApiProvider
    extends $FunctionalProvider<BookingApi, BookingApi, BookingApi>
    with $Provider<BookingApi> {
  BookingApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingApiHash();

  @$internal
  @override
  $ProviderElement<BookingApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BookingApi create(Ref ref) {
    return bookingApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingApi>(value),
    );
  }
}

String _$bookingApiHash() => r'b246fbf4d8f441310cbdc36b7472314d9158a57e';

@ProviderFor(cleanerApi)
final cleanerApiProvider = CleanerApiProvider._();

final class CleanerApiProvider
    extends $FunctionalProvider<CleanerApi, CleanerApi, CleanerApi>
    with $Provider<CleanerApi> {
  CleanerApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cleanerApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cleanerApiHash();

  @$internal
  @override
  $ProviderElement<CleanerApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CleanerApi create(Ref ref) {
    return cleanerApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CleanerApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CleanerApi>(value),
    );
  }
}

String _$cleanerApiHash() => r'4e1698f7e52ea9154f8891a7c49616c30b116faa';

@ProviderFor(adminApi)
final adminApiProvider = AdminApiProvider._();

final class AdminApiProvider
    extends $FunctionalProvider<AdminApi, AdminApi, AdminApi>
    with $Provider<AdminApi> {
  AdminApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminApiHash();

  @$internal
  @override
  $ProviderElement<AdminApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdminApi create(Ref ref) {
    return adminApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminApi>(value),
    );
  }
}

String _$adminApiHash() => r'f2459d20691317a4c9d3e9883e6e00671968aa18';

/// Emits when the refresh token was rejected; route back to sign-in.

@ProviderFor(sessionExpired)
final sessionExpiredProvider = SessionExpiredProvider._();

/// Emits when the refresh token was rejected; route back to sign-in.

final class SessionExpiredProvider
    extends $FunctionalProvider<AsyncValue<void>, void, Stream<void>>
    with $FutureModifier<void>, $StreamProvider<void> {
  /// Emits when the refresh token was rejected; route back to sign-in.
  SessionExpiredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionExpiredProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionExpiredHash();

  @$internal
  @override
  $StreamProviderElement<void> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<void> create(Ref ref) {
    return sessionExpired(ref);
  }
}

String _$sessionExpiredHash() => r'b9a20e8ac15d4cc74162f542078621fb4c7490b0';

/// The shared WebSocket. Call `connect()` after sign-in and `disconnect()`
/// on sign-out.

@ProviderFor(realtimeClient)
final realtimeClientProvider = RealtimeClientProvider._();

/// The shared WebSocket. Call `connect()` after sign-in and `disconnect()`
/// on sign-out.

final class RealtimeClientProvider
    extends $FunctionalProvider<RealtimeClient, RealtimeClient, RealtimeClient>
    with $Provider<RealtimeClient> {
  /// The shared WebSocket. Call `connect()` after sign-in and `disconnect()`
  /// on sign-out.
  RealtimeClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeClientHash();

  @$internal
  @override
  $ProviderElement<RealtimeClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RealtimeClient create(Ref ref) {
    return realtimeClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RealtimeClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RealtimeClient>(value),
    );
  }
}

String _$realtimeClientHash() => r'5abdc7fec158f94cf3011bb99938eda371c7e5b4';

@ProviderFor(realtimeEvents)
final realtimeEventsProvider = RealtimeEventsProvider._();

final class RealtimeEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<RealtimeEvent>,
          RealtimeEvent,
          Stream<RealtimeEvent>
        >
    with $FutureModifier<RealtimeEvent>, $StreamProvider<RealtimeEvent> {
  RealtimeEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeEventsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeEventsHash();

  @$internal
  @override
  $StreamProviderElement<RealtimeEvent> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RealtimeEvent> create(Ref ref) {
    return realtimeEvents(ref);
  }
}

String _$realtimeEventsHash() => r'36694b38883e870ab83d41a9497e2127b46ebac4';

/// Swap this override to change the map SDK.

@ProviderFor(mapProvider)
final mapProviderProvider = MapProviderProvider._();

/// Swap this override to change the map SDK.

final class MapProviderProvider
    extends $FunctionalProvider<MapProvider, MapProvider, MapProvider>
    with $Provider<MapProvider> {
  /// Swap this override to change the map SDK.
  MapProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapProviderHash();

  @$internal
  @override
  $ProviderElement<MapProvider> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapProvider create(Ref ref) {
    return mapProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapProvider value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapProvider>(value),
    );
  }
}

String _$mapProviderHash() => r'4d1a05af27e3cfe6d015ea58240b16fc946d8ec2';
