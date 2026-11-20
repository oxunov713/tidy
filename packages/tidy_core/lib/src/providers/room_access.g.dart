// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_access.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// True once the server told us we lost access to [room] (the booking was
/// reassigned or cancelled, the cleaner was suspended). Watch it from a screen
/// that shows a booking to say so and close the conversation.

@ProviderFor(RoomAccessRevoked)
final roomAccessRevokedProvider = RoomAccessRevokedFamily._();

/// True once the server told us we lost access to [room] (the booking was
/// reassigned or cancelled, the cleaner was suspended). Watch it from a screen
/// that shows a booking to say so and close the conversation.
final class RoomAccessRevokedProvider
    extends $NotifierProvider<RoomAccessRevoked, bool> {
  /// True once the server told us we lost access to [room] (the booking was
  /// reassigned or cancelled, the cleaner was suspended). Watch it from a screen
  /// that shows a booking to say so and close the conversation.
  RoomAccessRevokedProvider._({
    required RoomAccessRevokedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'roomAccessRevokedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomAccessRevokedHash();

  @override
  String toString() {
    return r'roomAccessRevokedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RoomAccessRevoked create() => RoomAccessRevoked();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RoomAccessRevokedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomAccessRevokedHash() => r'4e69a4ffb034ca2c3da2c869d9a4264bc60b7c88';

/// True once the server told us we lost access to [room] (the booking was
/// reassigned or cancelled, the cleaner was suspended). Watch it from a screen
/// that shows a booking to say so and close the conversation.

final class RoomAccessRevokedFamily extends $Family
    with $ClassFamilyOverride<RoomAccessRevoked, bool, bool, bool, String> {
  RoomAccessRevokedFamily._()
    : super(
        retry: null,
        name: r'roomAccessRevokedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// True once the server told us we lost access to [room] (the booking was
  /// reassigned or cancelled, the cleaner was suspended). Watch it from a screen
  /// that shows a booking to say so and close the conversation.

  RoomAccessRevokedProvider call(String room) =>
      RoomAccessRevokedProvider._(argument: room, from: this);

  @override
  String toString() => r'roomAccessRevokedProvider';
}

/// True once the server told us we lost access to [room] (the booking was
/// reassigned or cancelled, the cleaner was suspended). Watch it from a screen
/// that shows a booking to say so and close the conversation.

abstract class _$RoomAccessRevoked extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get room => _$args;

  bool build(String room);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
