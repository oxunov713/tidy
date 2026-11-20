// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_connection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps the WebSocket open while the signed-in screens are on. Watch it from
/// the shell: it connects when the shell appears and disconnects when the
/// shell goes away (sign-out).

@ProviderFor(realtimeConnection)
final realtimeConnectionProvider = RealtimeConnectionProvider._();

/// Keeps the WebSocket open while the signed-in screens are on. Watch it from
/// the shell: it connects when the shell appears and disconnects when the
/// shell goes away (sign-out).

final class RealtimeConnectionProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Keeps the WebSocket open while the signed-in screens are on. Watch it from
  /// the shell: it connects when the shell appears and disconnects when the
  /// shell goes away (sign-out).
  RealtimeConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeConnectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeConnectionHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return realtimeConnection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$realtimeConnectionHash() =>
    r'1009c09de3d9cc52ee5e3099dfb8fd5738f02379';
