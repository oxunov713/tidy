// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_wizard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// How long to wait after the last change before asking for a new price, so
/// tapping a stepper five times sends one request.

@ProviderFor(quoteDebounce)
final quoteDebounceProvider = QuoteDebounceProvider._();

/// How long to wait after the last change before asking for a new price, so
/// tapping a stepper five times sends one request.

final class QuoteDebounceProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// How long to wait after the last change before asking for a new price, so
  /// tapping a stepper five times sends one request.
  QuoteDebounceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quoteDebounceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quoteDebounceHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return quoteDebounce(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$quoteDebounceHash() => r'0fb95e9a88bc20a8a8b6c0b3461e8d029e4d1ad0';

@ProviderFor(BookingWizard)
final bookingWizardProvider = BookingWizardProvider._();

final class BookingWizardProvider
    extends $NotifierProvider<BookingWizard, BookingWizardState> {
  BookingWizardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingWizardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingWizardHash();

  @$internal
  @override
  BookingWizard create() => BookingWizard();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingWizardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingWizardState>(value),
    );
  }
}

String _$bookingWizardHash() => r'beaa6f4900711aa0285b29cf6df52531b9b20ec7';

abstract class _$BookingWizard extends $Notifier<BookingWizardState> {
  BookingWizardState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BookingWizardState, BookingWizardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingWizardState, BookingWizardState>,
              BookingWizardState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
