// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_gateway.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(realtimeGateway)
final realtimeGatewayProvider = RealtimeGatewayProvider._();

final class RealtimeGatewayProvider
    extends
        $FunctionalProvider<RealtimeGateway, RealtimeGateway, RealtimeGateway>
    with $Provider<RealtimeGateway> {
  RealtimeGatewayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeGatewayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeGatewayHash();

  @$internal
  @override
  $ProviderElement<RealtimeGateway> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RealtimeGateway create(Ref ref) {
    return realtimeGateway(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RealtimeGateway value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RealtimeGateway>(value),
    );
  }
}

String _$realtimeGatewayHash() => r'534ce90f02e8c150f0963a7ad333e380962deef2';
