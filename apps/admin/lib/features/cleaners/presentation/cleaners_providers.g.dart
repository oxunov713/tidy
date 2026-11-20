// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaners_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cleanersRepository)
final cleanersRepositoryProvider = CleanersRepositoryProvider._();

final class CleanersRepositoryProvider
    extends
        $FunctionalProvider<
          CleanersRepository,
          CleanersRepository,
          CleanersRepository
        >
    with $Provider<CleanersRepository> {
  CleanersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cleanersRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cleanersRepositoryHash();

  @$internal
  @override
  $ProviderElement<CleanersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CleanersRepository create(Ref ref) {
    return cleanersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CleanersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CleanersRepository>(value),
    );
  }
}

String _$cleanersRepositoryHash() =>
    r'62cbc9b62244b5731008b9ccf71e4e2fa5730b06';

/// All cleaners in one list; the tabs filter it by status.

@ProviderFor(CleanersController)
final cleanersControllerProvider = CleanersControllerProvider._();

/// All cleaners in one list; the tabs filter it by status.
final class CleanersControllerProvider
    extends $AsyncNotifierProvider<CleanersController, CleanersState> {
  /// All cleaners in one list; the tabs filter it by status.
  CleanersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cleanersControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cleanersControllerHash();

  @$internal
  @override
  CleanersController create() => CleanersController();
}

String _$cleanersControllerHash() =>
    r'e2190f7eca54f533aa1af468905aa87d4102aa4e';

/// All cleaners in one list; the tabs filter it by status.

abstract class _$CleanersController extends $AsyncNotifier<CleanersState> {
  FutureOr<CleanersState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CleanersState>, CleanersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CleanersState>, CleanersState>,
              AsyncValue<CleanersState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
