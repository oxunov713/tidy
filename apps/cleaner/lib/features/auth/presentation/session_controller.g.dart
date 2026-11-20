// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in cleaner, or null. The router redirects on this.

@ProviderFor(SessionController)
final sessionControllerProvider = SessionControllerProvider._();

/// The signed-in cleaner, or null. The router redirects on this.
final class SessionControllerProvider
    extends $AsyncNotifierProvider<SessionController, User?> {
  /// The signed-in cleaner, or null. The router redirects on this.
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

String _$sessionControllerHash() => r'7fbbfc664691fcb9e233382b88624fcd1efa234a';

/// The signed-in cleaner, or null. The router redirects on this.

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
