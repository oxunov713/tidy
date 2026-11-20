// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Id of the signed-in admin. Repositories watch it, so nothing cached for one
/// admin survives a sign-out.

@ProviderFor(currentAdminId)
final currentAdminIdProvider = CurrentAdminIdProvider._();

/// Id of the signed-in admin. Repositories watch it, so nothing cached for one
/// admin survives a sign-out.

final class CurrentAdminIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Id of the signed-in admin. Repositories watch it, so nothing cached for one
  /// admin survives a sign-out.
  CurrentAdminIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAdminIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAdminIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentAdminId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentAdminIdHash() => r'cb326627353fe76d6d098d3e753e6d6c579dd831';

/// Sign-in for the admin panel. The server never creates an admin account, so
/// a phone that is not one is refused with a 403.

@ProviderFor(sessionRepository)
final sessionRepositoryProvider = SessionRepositoryProvider._();

/// Sign-in for the admin panel. The server never creates an admin account, so
/// a phone that is not one is refused with a 403.

final class SessionRepositoryProvider
    extends
        $FunctionalProvider<
          SessionRepository,
          SessionRepository,
          SessionRepository
        >
    with $Provider<SessionRepository> {
  /// Sign-in for the admin panel. The server never creates an admin account, so
  /// a phone that is not one is refused with a 403.
  SessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionRepository create(Ref ref) {
    return sessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionRepository>(value),
    );
  }
}

String _$sessionRepositoryHash() => r'76481ff629efc188291f99a88ed1fe573e7b0483';

/// The signed-in admin, or null. The router listens to this.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// The signed-in admin, or null. The router listens to this.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, User?> {
  /// The signed-in admin, or null. The router listens to this.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'0c3422c5f910182522b8a382c3c3317b6824495a';

/// The signed-in admin, or null. The router listens to this.

abstract class _$AuthController extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
