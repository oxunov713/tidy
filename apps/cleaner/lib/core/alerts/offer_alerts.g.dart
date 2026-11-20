// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_alerts.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(offerAlerts)
final offerAlertsProvider = OfferAlertsProvider._();

final class OfferAlertsProvider
    extends $FunctionalProvider<OfferAlerts, OfferAlerts, OfferAlerts>
    with $Provider<OfferAlerts> {
  OfferAlertsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offerAlertsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offerAlertsHash();

  @$internal
  @override
  $ProviderElement<OfferAlerts> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OfferAlerts create(Ref ref) {
    return offerAlerts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfferAlerts value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfferAlerts>(value),
    );
  }
}

String _$offerAlertsHash() => r'14d10322382d615f144380b9e2ae8b187702b822';
