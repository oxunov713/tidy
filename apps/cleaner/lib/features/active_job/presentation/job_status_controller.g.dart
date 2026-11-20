// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Moves one job along: assigned, on the way, in progress, completed.

@ProviderFor(JobStatusController)
final jobStatusControllerProvider = JobStatusControllerFamily._();

/// Moves one job along: assigned, on the way, in progress, completed.
final class JobStatusControllerProvider
    extends $NotifierProvider<JobStatusController, JobActionState> {
  /// Moves one job along: assigned, on the way, in progress, completed.
  JobStatusControllerProvider._({
    required JobStatusControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'jobStatusControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jobStatusControllerHash();

  @override
  String toString() {
    return r'jobStatusControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  JobStatusController create() => JobStatusController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobActionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobActionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JobStatusControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jobStatusControllerHash() =>
    r'0ab97bbd640ceb7e20751cab49a6be151e953f83';

/// Moves one job along: assigned, on the way, in progress, completed.

final class JobStatusControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          JobStatusController,
          JobActionState,
          JobActionState,
          JobActionState,
          String
        > {
  JobStatusControllerFamily._()
    : super(
        retry: null,
        name: r'jobStatusControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Moves one job along: assigned, on the way, in progress, completed.

  JobStatusControllerProvider call(String bookingId) =>
      JobStatusControllerProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'jobStatusControllerProvider';
}

/// Moves one job along: assigned, on the way, in progress, completed.

abstract class _$JobStatusController extends $Notifier<JobActionState> {
  late final _$args = ref.$arg as String;
  String get bookingId => _$args;

  JobActionState build(String bookingId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<JobActionState, JobActionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JobActionState, JobActionState>,
              JobActionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
