// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Messages of one booking: history from the API, new ones from
/// `message.new` over the WebSocket.

@ProviderFor(ChatController)
final chatControllerProvider = ChatControllerFamily._();

/// Messages of one booking: history from the API, new ones from
/// `message.new` over the WebSocket.
final class ChatControllerProvider
    extends $AsyncNotifierProvider<ChatController, List<Message>> {
  /// Messages of one booking: history from the API, new ones from
  /// `message.new` over the WebSocket.
  ChatControllerProvider._({
    required ChatControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @override
  String toString() {
    return r'chatControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatController create() => ChatController();

  @override
  bool operator ==(Object other) {
    return other is ChatControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatControllerHash() => r'6e5e1622c0df1a3c69a5413ddd9c3ac7622a0846';

/// Messages of one booking: history from the API, new ones from
/// `message.new` over the WebSocket.

final class ChatControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatController,
          AsyncValue<List<Message>>,
          List<Message>,
          FutureOr<List<Message>>,
          String
        > {
  ChatControllerFamily._()
    : super(
        retry: null,
        name: r'chatControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Messages of one booking: history from the API, new ones from
  /// `message.new` over the WebSocket.

  ChatControllerProvider call(String bookingId) =>
      ChatControllerProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'chatControllerProvider';
}

/// Messages of one booking: history from the API, new ones from
/// `message.new` over the WebSocket.

abstract class _$ChatController extends $AsyncNotifier<List<Message>> {
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
