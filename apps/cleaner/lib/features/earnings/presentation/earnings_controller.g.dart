// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Earnings for one period. Kept alive so the Jobs header and the Earnings
/// tab share one request; `ref.invalidate` it to reload.

@ProviderFor(earnings)
final earningsProvider = EarningsFamily._();

/// Earnings for one period. Kept alive so the Jobs header and the Earnings
/// tab share one request; `ref.invalidate` it to reload.

final class EarningsProvider
    extends
        $FunctionalProvider<AsyncValue<Earnings>, Earnings, FutureOr<Earnings>>
    with $FutureModifier<Earnings>, $FutureProvider<Earnings> {
  /// Earnings for one period. Kept alive so the Jobs header and the Earnings
  /// tab share one request; `ref.invalidate` it to reload.
  EarningsProvider._({
    required EarningsFamily super.from,
    required EarningsPeriod super.argument,
  }) : super(
         retry: null,
         name: r'earningsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$earningsHash();

  @override
  String toString() {
    return r'earningsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Earnings> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Earnings> create(Ref ref) {
    final argument = this.argument as EarningsPeriod;
    return earnings(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EarningsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$earningsHash() => r'e2ee21cad2fd387ff01068b223888e2f0e936e21';

/// Earnings for one period. Kept alive so the Jobs header and the Earnings
/// tab share one request; `ref.invalidate` it to reload.

final class EarningsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Earnings>, EarningsPeriod> {
  EarningsFamily._()
    : super(
        retry: null,
        name: r'earningsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Earnings for one period. Kept alive so the Jobs header and the Earnings
  /// tab share one request; `ref.invalidate` it to reload.

  EarningsProvider call(EarningsPeriod period) =>
      EarningsProvider._(argument: period, from: this);

  @override
  String toString() => r'earningsProvider';
}

/// Week or month, chosen with the toggle on the Earnings screen.

@ProviderFor(SelectedPeriod)
final selectedPeriodProvider = SelectedPeriodProvider._();

/// Week or month, chosen with the toggle on the Earnings screen.
final class SelectedPeriodProvider
    extends $NotifierProvider<SelectedPeriod, EarningsPeriod> {
  /// Week or month, chosen with the toggle on the Earnings screen.
  SelectedPeriodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedPeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedPeriodHash();

  @$internal
  @override
  SelectedPeriod create() => SelectedPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EarningsPeriod value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EarningsPeriod>(value),
    );
  }
}

String _$selectedPeriodHash() => r'86f04ea58575c270801ef30f19491b071ceaa270';

/// Week or month, chosen with the toggle on the Earnings screen.

abstract class _$SelectedPeriod extends $Notifier<EarningsPeriod> {
  EarningsPeriod build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EarningsPeriod, EarningsPeriod>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EarningsPeriod, EarningsPeriod>,
              EarningsPeriod,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
