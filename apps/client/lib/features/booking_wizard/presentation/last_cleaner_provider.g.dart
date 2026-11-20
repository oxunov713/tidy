// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_cleaner_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The cleaner of the user's most recent completed booking, for "book Sarah
/// again". Null for someone who has not had a clean yet.

@ProviderFor(lastCleaner)
final lastCleanerProvider = LastCleanerProvider._();

/// The cleaner of the user's most recent completed booking, for "book Sarah
/// again". Null for someone who has not had a clean yet.

final class LastCleanerProvider
    extends
        $FunctionalProvider<
          AsyncValue<CleanerCard?>,
          CleanerCard?,
          FutureOr<CleanerCard?>
        >
    with $FutureModifier<CleanerCard?>, $FutureProvider<CleanerCard?> {
  /// The cleaner of the user's most recent completed booking, for "book Sarah
  /// again". Null for someone who has not had a clean yet.
  LastCleanerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastCleanerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastCleanerHash();

  @$internal
  @override
  $FutureProviderElement<CleanerCard?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CleanerCard?> create(Ref ref) {
    return lastCleaner(ref);
  }
}

String _$lastCleanerHash() => r'fcd5b6f1ede9128fb5640f4dffcb67225035e86a';
