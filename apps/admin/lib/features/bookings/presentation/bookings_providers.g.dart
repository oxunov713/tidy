// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingsRepository)
final bookingsRepositoryProvider = BookingsRepositoryProvider._();

final class BookingsRepositoryProvider
    extends
        $FunctionalProvider<
          BookingsRepository,
          BookingsRepository,
          BookingsRepository
        >
    with $Provider<BookingsRepository> {
  BookingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingsRepository create(Ref ref) {
    return bookingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingsRepository>(value),
    );
  }
}

String _$bookingsRepositoryHash() =>
    r'442cdfa5a4ccc887fad488af3e6dfad8312dca0a';

/// How often the KPI tiles refresh. A provider so tests can shorten it.

@ProviderFor(statsRefreshInterval)
final statsRefreshIntervalProvider = StatsRefreshIntervalProvider._();

/// How often the KPI tiles refresh. A provider so tests can shorten it.

final class StatsRefreshIntervalProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// How often the KPI tiles refresh. A provider so tests can shorten it.
  StatsRefreshIntervalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsRefreshIntervalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsRefreshIntervalHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return statsRefreshInterval(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$statsRefreshIntervalHash() =>
    r'fe75a3c7806df2722d9b58e17bcaadb31e5b4ea4';

@ProviderFor(StatsController)
final statsControllerProvider = StatsControllerProvider._();

final class StatsControllerProvider
    extends $AsyncNotifierProvider<StatsController, AdminStats> {
  StatsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsControllerHash();

  @$internal
  @override
  StatsController create() => StatsController();
}

String _$statsControllerHash() => r'8d6746c019e41564bbefea57925db9b9143c863e';

abstract class _$StatsController extends $AsyncNotifier<AdminStats> {
  FutureOr<AdminStats> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AdminStats>, AdminStats>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdminStats>, AdminStats>,
              AsyncValue<AdminStats>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BookingFilterController)
final bookingFilterControllerProvider = BookingFilterControllerProvider._();

final class BookingFilterControllerProvider
    extends $NotifierProvider<BookingFilterController, BookingFilter> {
  BookingFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingFilterControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingFilterControllerHash();

  @$internal
  @override
  BookingFilterController create() => BookingFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingFilter>(value),
    );
  }
}

String _$bookingFilterControllerHash() =>
    r'6ceefdb4afb1f7d68894ccdcbda370a96ca61f72';

abstract class _$BookingFilterController extends $Notifier<BookingFilter> {
  BookingFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BookingFilter, BookingFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingFilter, BookingFilter>,
              BookingFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The first page for the current filter, plus whatever "load more" added.

@ProviderFor(BookingsController)
final bookingsControllerProvider = BookingsControllerProvider._();

/// The first page for the current filter, plus whatever "load more" added.
final class BookingsControllerProvider
    extends $AsyncNotifierProvider<BookingsController, BookingsState> {
  /// The first page for the current filter, plus whatever "load more" added.
  BookingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingsControllerHash();

  @$internal
  @override
  BookingsController create() => BookingsController();
}

String _$bookingsControllerHash() =>
    r'9c643a9d392aa867c074801a89b74ff80887f3ce';

/// The first page for the current filter, plus whatever "load more" added.

abstract class _$BookingsController extends $AsyncNotifier<BookingsState> {
  FutureOr<BookingsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BookingsState>, BookingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookingsState>, BookingsState>,
              AsyncValue<BookingsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BookingDetailController)
final bookingDetailControllerProvider = BookingDetailControllerFamily._();

final class BookingDetailControllerProvider
    extends $AsyncNotifierProvider<BookingDetailController, BookingDetails> {
  BookingDetailControllerProvider._({
    required BookingDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookingDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingDetailControllerHash();

  @override
  String toString() {
    return r'bookingDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookingDetailController create() => BookingDetailController();

  @override
  bool operator ==(Object other) {
    return other is BookingDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingDetailControllerHash() =>
    r'6363ecce74b4a1bf5b9db5c1603137cf34104327';

final class BookingDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BookingDetailController,
          AsyncValue<BookingDetails>,
          BookingDetails,
          FutureOr<BookingDetails>,
          String
        > {
  BookingDetailControllerFamily._()
    : super(
        retry: null,
        name: r'bookingDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookingDetailControllerProvider call(String id) =>
      BookingDetailControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'bookingDetailControllerProvider';
}

abstract class _$BookingDetailController
    extends $AsyncNotifier<BookingDetails> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<BookingDetails> build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BookingDetails>, BookingDetails>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookingDetails>, BookingDetails>,
              AsyncValue<BookingDetails>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
