// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingRepository)
final bookingRepositoryProvider = BookingRepositoryProvider._();

final class BookingRepositoryProvider
    extends
        $FunctionalProvider<
          BookingRepository,
          BookingRepository,
          BookingRepository
        >
    with $Provider<BookingRepository> {
  BookingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingRepository create(Ref ref) {
    return bookingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingRepository>(value),
    );
  }
}

String _$bookingRepositoryHash() => r'08beae54271edb61053fd8fa6a64ae3e889a3a50';

/// Upcoming or past bookings, fetched page by page with the server's cursor.

@ProviderFor(BookingsList)
final bookingsListProvider = BookingsListFamily._();

/// Upcoming or past bookings, fetched page by page with the server's cursor.
final class BookingsListProvider
    extends $AsyncNotifierProvider<BookingsList, PagedBookings> {
  /// Upcoming or past bookings, fetched page by page with the server's cursor.
  BookingsListProvider._({
    required BookingsListFamily super.from,
    required BookingScope super.argument,
  }) : super(
         retry: null,
         name: r'bookingsListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingsListHash();

  @override
  String toString() {
    return r'bookingsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookingsList create() => BookingsList();

  @override
  bool operator ==(Object other) {
    return other is BookingsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingsListHash() => r'fe125d9af4ad2cb1411927eaca92640692d4559a';

/// Upcoming or past bookings, fetched page by page with the server's cursor.

final class BookingsListFamily extends $Family
    with
        $ClassFamilyOverride<
          BookingsList,
          AsyncValue<PagedBookings>,
          PagedBookings,
          FutureOr<PagedBookings>,
          BookingScope
        > {
  BookingsListFamily._()
    : super(
        retry: null,
        name: r'bookingsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Upcoming or past bookings, fetched page by page with the server's cursor.

  BookingsListProvider call(BookingScope scope) =>
      BookingsListProvider._(argument: scope, from: this);

  @override
  String toString() => r'bookingsListProvider';
}

/// Upcoming or past bookings, fetched page by page with the server's cursor.

abstract class _$BookingsList extends $AsyncNotifier<PagedBookings> {
  late final _$args = ref.$arg as BookingScope;
  BookingScope get scope => _$args;

  FutureOr<PagedBookings> build(BookingScope scope);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PagedBookings>, PagedBookings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PagedBookings>, PagedBookings>,
              AsyncValue<PagedBookings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// One booking with its address, cleaner, events and review.

@ProviderFor(bookingDetails)
final bookingDetailsProvider = BookingDetailsFamily._();

/// One booking with its address, cleaner, events and review.

final class BookingDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<BookingDetails>,
          BookingDetails,
          FutureOr<BookingDetails>
        >
    with $FutureModifier<BookingDetails>, $FutureProvider<BookingDetails> {
  /// One booking with its address, cleaner, events and review.
  BookingDetailsProvider._({
    required BookingDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookingDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingDetailsHash();

  @override
  String toString() {
    return r'bookingDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<BookingDetails> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BookingDetails> create(Ref ref) {
    final argument = this.argument as String;
    return bookingDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingDetailsHash() => r'92fe598aca6baa78e14e04324abfe27f98f16907';

/// One booking with its address, cleaner, events and review.

final class BookingDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<BookingDetails>, String> {
  BookingDetailsFamily._()
    : super(
        retry: null,
        name: r'bookingDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One booking with its address, cleaner, events and review.

  BookingDetailsProvider call(String id) =>
      BookingDetailsProvider._(argument: id, from: this);

  @override
  String toString() => r'bookingDetailsProvider';
}

/// The booking to show on Home as "current": a cleaner is on the way, working,
/// or has accepted. Null when there is none.

@ProviderFor(activeBooking)
final activeBookingProvider = ActiveBookingProvider._();

/// The booking to show on Home as "current": a cleaner is on the way, working,
/// or has accepted. Null when there is none.

final class ActiveBookingProvider
    extends $FunctionalProvider<Booking?, Booking?, Booking?>
    with $Provider<Booking?> {
  /// The booking to show on Home as "current": a cleaner is on the way, working,
  /// or has accepted. Null when there is none.
  ActiveBookingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeBookingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeBookingHash();

  @$internal
  @override
  $ProviderElement<Booking?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Booking? create(Ref ref) {
    return activeBooking(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Booking? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Booking?>(value),
    );
  }
}

String _$activeBookingHash() => r'6afebb660aee19c3c6ff0c7d23055c6181b8e1eb';
