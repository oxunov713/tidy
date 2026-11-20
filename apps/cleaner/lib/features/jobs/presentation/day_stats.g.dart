// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_stats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Today's earnings come from the week's `days`, the job counts from the
/// schedule.

@ProviderFor(dayStats)
final dayStatsProvider = DayStatsProvider._();

/// Today's earnings come from the week's `days`, the job counts from the
/// schedule.

final class DayStatsProvider
    extends $FunctionalProvider<DayStats, DayStats, DayStats>
    with $Provider<DayStats> {
  /// Today's earnings come from the week's `days`, the job counts from the
  /// schedule.
  DayStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dayStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dayStatsHash();

  @$internal
  @override
  $ProviderElement<DayStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DayStats create(Ref ref) {
    return dayStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DayStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DayStats>(value),
    );
  }
}

String _$dayStatsHash() => r'2a1668f3374b83f2cbfc4070c682492e36f7ce77';
