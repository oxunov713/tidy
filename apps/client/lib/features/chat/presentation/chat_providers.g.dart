// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'714b597b9cd93b38dddbcc7c2523de5d05253341';

/// Messages of one booking: history plus `message.new` events as they come.

@ProviderFor(Chat)
final chatProvider = ChatFamily._();

/// Messages of one booking: history plus `message.new` events as they come.
final class ChatProvider extends $AsyncNotifierProvider<Chat, List<Message>> {
  /// Messages of one booking: history plus `message.new` events as they come.
  ChatProvider._({
    required ChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatHash();

  @override
  String toString() {
    return r'chatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Chat create() => Chat();

  @override
  bool operator ==(Object other) {
    return other is ChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatHash() => r'1c0d961da6be3b12aa8334bdcaacac86a2ca3a30';

/// Messages of one booking: history plus `message.new` events as they come.

final class ChatFamily extends $Family
    with
        $ClassFamilyOverride<
          Chat,
          AsyncValue<List<Message>>,
          List<Message>,
          FutureOr<List<Message>>,
          String
        > {
  ChatFamily._()
    : super(
        retry: null,
        name: r'chatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Messages of one booking: history plus `message.new` events as they come.

  ChatProvider call(String bookingId) =>
      ChatProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'chatProvider';
}

/// Messages of one booking: history plus `message.new` events as they come.

abstract class _$Chat extends $AsyncNotifier<List<Message>> {
  late final _$args = ref.$arg as String;
  String get bookingId => _$args;

  FutureOr<List<Message>> build(String bookingId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Message>>, List<Message>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Message>>, List<Message>>,
              AsyncValue<List<Message>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Bookings with a cleaner, newest first, for the Chat tab. Names come from
/// the booking details, so this is capped to the latest few.

@ProviderFor(chatThreads)
final chatThreadsProvider = ChatThreadsProvider._();

/// Bookings with a cleaner, newest first, for the Chat tab. Names come from
/// the booking details, so this is capped to the latest few.

final class ChatThreadsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatThread>>,
          List<ChatThread>,
          FutureOr<List<ChatThread>>
        >
    with $FutureModifier<List<ChatThread>>, $FutureProvider<List<ChatThread>> {
  /// Bookings with a cleaner, newest first, for the Chat tab. Names come from
  /// the booking details, so this is capped to the latest few.
  ChatThreadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatThreadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatThreadsHash();

  @$internal
  @override
  $FutureProviderElement<List<ChatThread>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChatThread>> create(Ref ref) {
    return chatThreads(ref);
  }
}

String _$chatThreadsHash() => r'64f611294eed40e176093e67b576da4f0d36c22b';
