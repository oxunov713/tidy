// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_factory.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mapFactory)
final mapFactoryProvider = MapFactoryProvider._();

final class MapFactoryProvider
    extends $FunctionalProvider<MapFactory, MapFactory, MapFactory>
    with $Provider<MapFactory> {
  MapFactoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapFactoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapFactoryHash();

  @$internal
  @override
  $ProviderElement<MapFactory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapFactory create(Ref ref) {
    return mapFactory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapFactory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapFactory>(value),
    );
  }
}

String _$mapFactoryHash() => r'469f6188e3f0d9731dd7e7c5935bc1a672262601';
