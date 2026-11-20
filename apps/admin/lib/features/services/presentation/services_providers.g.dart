// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(servicesRepository)
final servicesRepositoryProvider = ServicesRepositoryProvider._();

final class ServicesRepositoryProvider
    extends
        $FunctionalProvider<
          ServicesRepository,
          ServicesRepository,
          ServicesRepository
        >
    with $Provider<ServicesRepository> {
  ServicesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'servicesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$servicesRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServicesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServicesRepository create(Ref ref) {
    return servicesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServicesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServicesRepository>(value),
    );
  }
}

String _$servicesRepositoryHash() =>
    r'b29ae11a874708073a7ed9d5b5576629c29256c0';

@ProviderFor(ServicesController)
final servicesControllerProvider = ServicesControllerProvider._();

final class ServicesControllerProvider
    extends $AsyncNotifierProvider<ServicesController, List<AdminService>> {
  ServicesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'servicesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$servicesControllerHash();

  @$internal
  @override
  ServicesController create() => ServicesController();
}

String _$servicesControllerHash() =>
    r'f74928cbf16ff96256956a47fe4b0e7bf77668fb';

abstract class _$ServicesController extends $AsyncNotifier<List<AdminService>> {
  FutureOr<List<AdminService>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<AdminService>>, List<AdminService>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AdminService>>, List<AdminService>>,
              AsyncValue<List<AdminService>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
