// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_reporter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationReporter)
final locationReporterProvider = LocationReporterProvider._();

final class LocationReporterProvider
    extends
        $FunctionalProvider<
          LocationReporter,
          LocationReporter,
          LocationReporter
        >
    with $Provider<LocationReporter> {
  LocationReporterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationReporterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationReporterHash();

  @$internal
  @override
  $ProviderElement<LocationReporter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationReporter create(Ref ref) {
    return locationReporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationReporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationReporter>(value),
    );
  }
}

String _$locationReporterHash() => r'ea1278c7d42051c31add2e869ea9f0324c4237bb';

/// Whether the app is on screen. Position sharing is foreground only, so it
/// pauses when the cleaner leaves the app.

@ProviderFor(AppLifecycle)
final appLifecycleProvider = AppLifecycleProvider._();

/// Whether the app is on screen. Position sharing is foreground only, so it
/// pauses when the cleaner leaves the app.
final class AppLifecycleProvider
    extends $NotifierProvider<AppLifecycle, AppLifecycleState> {
  /// Whether the app is on screen. Position sharing is foreground only, so it
  /// pauses when the cleaner leaves the app.
  AppLifecycleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLifecycleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLifecycleHash();

  @$internal
  @override
  AppLifecycle create() => AppLifecycle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLifecycleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLifecycleState>(value),
    );
  }
}

String _$appLifecycleHash() => r'2ea7164a0734f2763f09ca5f137bac9c80dcb841';

/// Whether the app is on screen. Position sharing is foreground only, so it
/// pauses when the cleaner leaves the app.

abstract class _$AppLifecycle extends $Notifier<AppLifecycleState> {
  AppLifecycleState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppLifecycleState, AppLifecycleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLifecycleState, AppLifecycleState>,
              AppLifecycleState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Starts the reporter for the job that is `on_the_way` and stops it when
/// there is none or the app is in the background. Watch it from the shell.

@ProviderFor(locationReporting)
final locationReportingProvider = LocationReportingProvider._();

/// Starts the reporter for the job that is `on_the_way` and stops it when
/// there is none or the app is in the background. Watch it from the shell.

final class LocationReportingProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Starts the reporter for the job that is `on_the_way` and stops it when
  /// there is none or the app is in the background. Watch it from the shell.
  LocationReportingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationReportingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationReportingHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return locationReporting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$locationReportingHash() => r'd84670e7e044b114be3596d1985aad72c4f8345f';
