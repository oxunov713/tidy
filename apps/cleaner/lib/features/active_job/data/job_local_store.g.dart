// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_local_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(jobLocalStore)
final jobLocalStoreProvider = JobLocalStoreProvider._();

final class JobLocalStoreProvider
    extends $FunctionalProvider<JobLocalStore, JobLocalStore, JobLocalStore>
    with $Provider<JobLocalStore> {
  JobLocalStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobLocalStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobLocalStoreHash();

  @$internal
  @override
  $ProviderElement<JobLocalStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JobLocalStore create(Ref ref) {
    return jobLocalStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobLocalStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobLocalStore>(value),
    );
  }
}

String _$jobLocalStoreHash() => r'a8f9e0f2e7f1ff9d4fee491d3fb8c84d9d7ef3bc';
