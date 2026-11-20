// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A booking's details kept live: `booking.status` and `cleaner.location`
/// events from the `booking:<id>` room update the state as they arrive.

@ProviderFor(Tracking)
final trackingProvider = TrackingFamily._();

/// A booking's details kept live: `booking.status` and `cleaner.location`
/// events from the `booking:<id>` room update the state as they arrive.
final class TrackingProvider
    extends $AsyncNotifierProvider<Tracking, TrackingState> {
  /// A booking's details kept live: `booking.status` and `cleaner.location`
  /// events from the `booking:<id>` room update the state as they arrive.
  TrackingProvider._({
    required TrackingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'trackingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trackingHash();

  @override
  String toString() {
    return r'trackingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Tracking create() => Tracking();

  @override
  bool operator ==(Object other) {
    return other is TrackingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trackingHash() => r'799b4225c958220a49dacc444ff02afaf6ca9a00';

/// A booking's details kept live: `booking.status` and `cleaner.location`
/// events from the `booking:<id>` room update the state as they arrive.

final class TrackingFamily extends $Family
    with
        $ClassFamilyOverride<
          Tracking,
          AsyncValue<TrackingState>,
          TrackingState,
          FutureOr<TrackingState>,
          String
        > {
  TrackingFamily._()
    : super(
        retry: null,
        name: r'trackingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A booking's details kept live: `booking.status` and `cleaner.location`
  /// events from the `booking:<id>` room update the state as they arrive.

  TrackingProvider call(String bookingId) =>
      TrackingProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'trackingProvider';
}

/// A booking's details kept live: `booking.status` and `cleaner.location`
/// events from the `booking:<id>` room update the state as they arrive.

abstract class _$Tracking extends $AsyncNotifier<TrackingState> {
  late final _$args = ref.$arg as String;
  String get bookingId => _$args;

  FutureOr<TrackingState> build(String bookingId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TrackingState>, TrackingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TrackingState>, TrackingState>,
              AsyncValue<TrackingState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
