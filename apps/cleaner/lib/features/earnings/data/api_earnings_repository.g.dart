// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_earnings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(earningsRepository)
final earningsRepositoryProvider = EarningsRepositoryProvider._();

final class EarningsRepositoryProvider
    extends
        $FunctionalProvider<
          EarningsRepository,
          EarningsRepository,
          EarningsRepository
        >
    with $Provider<EarningsRepository> {
  EarningsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'earningsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$earningsRepositoryHash();

  @$internal
  @override
  $ProviderElement<EarningsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EarningsRepository create(Ref ref) {
    return earningsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EarningsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EarningsRepository>(value),
    );
  }
}

String _$earningsRepositoryHash() =>
    r'f16fadbd8eac229130b3a98bed09c4a92f1802ce';
