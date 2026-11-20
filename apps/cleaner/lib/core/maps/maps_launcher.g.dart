// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maps_launcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mapsLauncher)
final mapsLauncherProvider = MapsLauncherProvider._();

final class MapsLauncherProvider
    extends $FunctionalProvider<MapsLauncher, MapsLauncher, MapsLauncher>
    with $Provider<MapsLauncher> {
  MapsLauncherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapsLauncherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapsLauncherHash();

  @$internal
  @override
  $ProviderElement<MapsLauncher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapsLauncher create(Ref ref) {
    return mapsLauncher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapsLauncher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapsLauncher>(value),
    );
  }
}

String _$mapsLauncherHash() => r'46d3515ecfcebf7d4dbb6839cfe0962038ba7d28';
