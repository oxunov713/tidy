// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaner_repositories.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(offersRepository)
final offersRepositoryProvider = OffersRepositoryProvider._();

final class OffersRepositoryProvider
    extends
        $FunctionalProvider<
          OffersRepository,
          OffersRepository,
          OffersRepository
        >
    with $Provider<OffersRepository> {
  OffersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offersRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offersRepositoryHash();

  @$internal
  @override
  $ProviderElement<OffersRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OffersRepository create(Ref ref) {
    return offersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OffersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OffersRepository>(value),
    );
  }
}

String _$offersRepositoryHash() => r'9ea609ace6a1323b2255624a0a36c4c93ec68021';

@ProviderFor(jobsRepository)
final jobsRepositoryProvider = JobsRepositoryProvider._();

final class JobsRepositoryProvider
    extends $FunctionalProvider<JobsRepository, JobsRepository, JobsRepository>
    with $Provider<JobsRepository> {
  JobsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobsRepositoryHash();

  @$internal
  @override
  $ProviderElement<JobsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JobsRepository create(Ref ref) {
    return jobsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobsRepository>(value),
    );
  }
}

String _$jobsRepositoryHash() => r'2006039e04dd5fbf2530175839cb1a1891684752';

@ProviderFor(presenceRepository)
final presenceRepositoryProvider = PresenceRepositoryProvider._();

final class PresenceRepositoryProvider
    extends
        $FunctionalProvider<
          PresenceRepository,
          PresenceRepository,
          PresenceRepository
        >
    with $Provider<PresenceRepository> {
  PresenceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'presenceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presenceRepositoryHash();

  @$internal
  @override
  $ProviderElement<PresenceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PresenceRepository create(Ref ref) {
    return presenceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PresenceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PresenceRepository>(value),
    );
  }
}

String _$presenceRepositoryHash() =>
    r'993f3af7c910f21a3b809e7765ac1df26dd89ff8';
