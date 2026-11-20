// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogRepository)
final catalogRepositoryProvider = CatalogRepositoryProvider._();

final class CatalogRepositoryProvider
    extends
        $FunctionalProvider<
          CatalogRepository,
          CatalogRepository,
          CatalogRepository
        >
    with $Provider<CatalogRepository> {
  CatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<CatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogRepository create(Ref ref) {
    return catalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogRepository>(value),
    );
  }
}

String _$catalogRepositoryHash() => r'e0eb739c519255eaaa327a46fa823103880acb6f';

@ProviderFor(services)
final servicesProvider = ServicesProvider._();

final class ServicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Service>>,
          List<Service>,
          FutureOr<List<Service>>
        >
    with $FutureModifier<List<Service>>, $FutureProvider<List<Service>> {
  ServicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'servicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$servicesHash();

  @$internal
  @override
  $FutureProviderElement<List<Service>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Service>> create(Ref ref) {
    return services(ref);
  }
}

String _$servicesHash() => r'3ccf77452f88411205a021548bf08a6d38eb627b';

@ProviderFor(extras)
final extrasProvider = ExtrasProvider._();

final class ExtrasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Extra>>,
          List<Extra>,
          FutureOr<List<Extra>>
        >
    with $FutureModifier<List<Extra>>, $FutureProvider<List<Extra>> {
  ExtrasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extrasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extrasHash();

  @$internal
  @override
  $FutureProviderElement<List<Extra>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Extra>> create(Ref ref) {
    return extras(ref);
  }
}

String _$extrasHash() => r'a045a553e6cabaec70a96d77431cde880a21864c';
