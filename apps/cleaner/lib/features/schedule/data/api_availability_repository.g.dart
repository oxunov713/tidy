// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_availability_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(availabilityRepository)
final availabilityRepositoryProvider = AvailabilityRepositoryProvider._();

final class AvailabilityRepositoryProvider
    extends
        $FunctionalProvider<
          AvailabilityRepository,
          AvailabilityRepository,
          AvailabilityRepository
        >
    with $Provider<AvailabilityRepository> {
  AvailabilityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availabilityRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availabilityRepositoryHash();

  @$internal
  @override
  $ProviderElement<AvailabilityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AvailabilityRepository create(Ref ref) {
    return availabilityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvailabilityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvailabilityRepository>(value),
    );
  }
}

String _$availabilityRepositoryHash() =>
    r'c64aa4f50145cb8441d57f0044b1591d2cf1fa3d';
