// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Weekly working hours: weekday toggles and one from/to range, saved with
/// `PUT /cleaner/availability`.

@ProviderFor(AvailabilityController)
final availabilityControllerProvider = AvailabilityControllerProvider._();

/// Weekly working hours: weekday toggles and one from/to range, saved with
/// `PUT /cleaner/availability`.
final class AvailabilityControllerProvider
    extends $AsyncNotifierProvider<AvailabilityController, AvailabilityState> {
  /// Weekly working hours: weekday toggles and one from/to range, saved with
  /// `PUT /cleaner/availability`.
  AvailabilityControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availabilityControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availabilityControllerHash();

  @$internal
  @override
  AvailabilityController create() => AvailabilityController();
}

String _$availabilityControllerHash() =>
    r'617701d90c411c4a39a92f6ba36a6b6e569a8b1a';

/// Weekly working hours: weekday toggles and one from/to range, saved with
/// `PUT /cleaner/availability`.

abstract class _$AvailabilityController
    extends $AsyncNotifier<AvailabilityState> {
  FutureOr<AvailabilityState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AvailabilityState>, AvailabilityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AvailabilityState>, AvailabilityState>,
              AsyncValue<AvailabilityState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
