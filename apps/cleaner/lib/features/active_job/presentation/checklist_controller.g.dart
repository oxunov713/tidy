// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ids of the checklist items ticked for a job. Saved on the phone, so the
/// ticks survive closing the app.

@ProviderFor(ChecklistController)
final checklistControllerProvider = ChecklistControllerFamily._();

/// Ids of the checklist items ticked for a job. Saved on the phone, so the
/// ticks survive closing the app.
final class ChecklistControllerProvider
    extends $NotifierProvider<ChecklistController, Set<String>> {
  /// Ids of the checklist items ticked for a job. Saved on the phone, so the
  /// ticks survive closing the app.
  ChecklistControllerProvider._({
    required ChecklistControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'checklistControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$checklistControllerHash();

  @override
  String toString() {
    return r'checklistControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChecklistController create() => ChecklistController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChecklistControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$checklistControllerHash() =>
    r'1e20297c04963d6fbd208ba912afd512b2af133d';

/// Ids of the checklist items ticked for a job. Saved on the phone, so the
/// ticks survive closing the app.

final class ChecklistControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChecklistController,
          Set<String>,
          Set<String>,
          Set<String>,
          String
        > {
  ChecklistControllerFamily._()
    : super(
        retry: null,
        name: r'checklistControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Ids of the checklist items ticked for a job. Saved on the phone, so the
  /// ticks survive closing the app.

  ChecklistControllerProvider call(String jobId) =>
      ChecklistControllerProvider._(argument: jobId, from: this);

  @override
  String toString() => r'checklistControllerProvider';
}

/// Ids of the checklist items ticked for a job. Saved on the phone, so the
/// ticks survive closing the app.

abstract class _$ChecklistController extends $Notifier<Set<String>> {
  late final _$args = ref.$arg as String;
  String get jobId => _$args;

  Set<String> build(String jobId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
