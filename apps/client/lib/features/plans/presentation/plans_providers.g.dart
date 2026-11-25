// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plans_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The client's active recurring cleans.

@ProviderFor(plans)
final plansProvider = PlansProvider._();

/// The client's active recurring cleans.

final class PlansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Plan>>,
          List<Plan>,
          FutureOr<List<Plan>>
        >
    with $FutureModifier<List<Plan>>, $FutureProvider<List<Plan>> {
  /// The client's active recurring cleans.
  PlansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plansHash();

  @$internal
  @override
  $FutureProviderElement<List<Plan>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Plan>> create(Ref ref) {
    return plans(ref);
  }
}

String _$plansHash() => r'888c76edc7c201dcebee4963c6a92f811e55e076';
