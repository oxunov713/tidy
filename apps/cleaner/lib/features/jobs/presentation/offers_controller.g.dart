// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offers_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Open job offers: loaded on start, kept up to date by `offer.new` and
/// `offer.gone` over the WebSocket, and dropped when they expire.

@ProviderFor(OffersController)
final offersControllerProvider = OffersControllerProvider._();

/// Open job offers: loaded on start, kept up to date by `offer.new` and
/// `offer.gone` over the WebSocket, and dropped when they expire.
final class OffersControllerProvider
    extends $NotifierProvider<OffersController, OffersState> {
  /// Open job offers: loaded on start, kept up to date by `offer.new` and
  /// `offer.gone` over the WebSocket, and dropped when they expire.
  OffersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offersControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offersControllerHash();

  @$internal
  @override
  OffersController create() => OffersController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OffersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OffersState>(value),
    );
  }
}

String _$offersControllerHash() => r'befd6dd324771c9fb9b49e65393259fa885f9798';

/// Open job offers: loaded on start, kept up to date by `offer.new` and
/// `offer.gone` over the WebSocket, and dropped when they expire.

abstract class _$OffersController extends $Notifier<OffersState> {
  OffersState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OffersState, OffersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OffersState, OffersState>,
              OffersState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
