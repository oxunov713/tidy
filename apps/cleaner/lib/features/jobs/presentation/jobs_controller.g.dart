// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobs_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The cleaner's schedule: yesterday to two weeks ahead.
///
/// Rooms of the jobs that are still open are joined so a status change (for
/// example the client cancelling) shows up without a refresh.

@ProviderFor(JobsController)
final jobsControllerProvider = JobsControllerProvider._();

/// The cleaner's schedule: yesterday to two weeks ahead.
///
/// Rooms of the jobs that are still open are joined so a status change (for
/// example the client cancelling) shows up without a refresh.
final class JobsControllerProvider
    extends $AsyncNotifierProvider<JobsController, List<Job>> {
  /// The cleaner's schedule: yesterday to two weeks ahead.
  ///
  /// Rooms of the jobs that are still open are joined so a status change (for
  /// example the client cancelling) shows up without a refresh.
  JobsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobsControllerHash();

  @$internal
  @override
  JobsController create() => JobsController();
}

String _$jobsControllerHash() => r'238b89f14406d199e9a7adf80d6d38d5d4d31497';

/// The cleaner's schedule: yesterday to two weeks ahead.
///
/// Rooms of the jobs that are still open are joined so a status change (for
/// example the client cancelling) shows up without a refresh.

abstract class _$JobsController extends $AsyncNotifier<List<Job>> {
  FutureOr<List<Job>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Job>>, List<Job>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Job>>, List<Job>>,
              AsyncValue<List<Job>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
