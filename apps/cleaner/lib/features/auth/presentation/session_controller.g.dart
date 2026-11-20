// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sign-in for the cleaner app: only cleaner accounts get in, and signing out
/// takes the cleaner offline first.

@ProviderFor(sessionRepository)
final sessionRepositoryProvider = SessionRepositoryProvider._();

/// Sign-in for the cleaner app: only cleaner accounts get in, and signing out
/// takes the cleaner offline first.

final class SessionRepositoryProvider
    extends
        $FunctionalProvider<
          SessionRepository,
          SessionRepository,
          SessionRepository
        >
    with $Provider<SessionRepository> {
  /// Sign-in for the cleaner app: only cleaner accounts get in, and signing out
  /// takes the cleaner offline first.
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

String _$sessionRepositoryHash() => r'9e660a373464a2f2cc1db15f8066742dc0f4ca0d';

/// The signed-in cleaner, or null. The router redirects on this.
///
/// While the start-up check is running, or when it failed because the network
/// is down (the state is then an error), the router keeps the splash screen
/// with a retry button instead of sending the user to sign-in.

@ProviderFor(SessionController)
final sessionControllerProvider = SessionControllerProvider._();

/// The signed-in cleaner, or null. The router redirects on this.
///
/// While the start-up check is running, or when it failed because the network
/// is down (the state is then an error), the router keeps the splash screen
/// with a retry button instead of sending the user to sign-in.
final class SessionControllerProvider
    extends $AsyncNotifierProvider<SessionController, User?> {
  /// The signed-in cleaner, or null. The router redirects on this.
  ///
  /// While the start-up check is running, or when it failed because the network
  /// is down (the state is then an error), the router keeps the splash screen
  /// with a retry button instead of sending the user to sign-in.
  SessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @$internal
  @override
  SessionController create() => SessionController();
}

String _$sessionControllerHash() => r'1fb0f76d567c8c2463dc0319c6282fda3255a8f8';

/// The signed-in cleaner, or null. The router redirects on this.
///
/// While the start-up check is running, or when it failed because the network
/// is down (the state is then an error), the router keeps the splash screen
/// with a retry button instead of sending the user to sign-in.

abstract class _$SessionController extends $AsyncNotifier<User?> {
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

/// Id of the signed-in cleaner. Controllers that hold per-user data watch it,
/// so they start fresh after a sign-out and sign-in as someone else.

@ProviderFor(currentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

/// Id of the signed-in cleaner. Controllers that hold per-user data watch it,
/// so they start fresh after a sign-out and sign-in as someone else.

final class CurrentUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Id of the signed-in cleaner. Controllers that hold per-user data watch it,
  /// so they start fresh after a sign-out and sign-in as someone else.
  CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserIdHash() => r'f1091518e712415a96c057ca65148bc339135880';
