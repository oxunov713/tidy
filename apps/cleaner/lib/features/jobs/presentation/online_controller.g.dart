// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The online switch. Going online sends the current position so the server
/// can pick the nearest cleaners for an offer.

@ProviderFor(OnlineController)
final onlineControllerProvider = OnlineControllerProvider._();

/// The online switch. Going online sends the current position so the server
/// can pick the nearest cleaners for an offer.
final class OnlineControllerProvider
    extends $NotifierProvider<OnlineController, OnlineState> {
  /// The online switch. Going online sends the current position so the server
  /// can pick the nearest cleaners for an offer.
  OnlineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onlineControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onlineControllerHash();

  @$internal
  @override
  OnlineController create() => OnlineController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnlineState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnlineState>(value),
    );
  }
}

String _$onlineControllerHash() => r'f3a3c5b51c5ee96de6abfadef18f46a61195edf1';

/// The online switch. Going online sends the current position so the server
/// can pick the nearest cleaners for an offer.

abstract class _$OnlineController extends $Notifier<OnlineState> {
  OnlineState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OnlineState, OnlineState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnlineState, OnlineState>,
              OnlineState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
