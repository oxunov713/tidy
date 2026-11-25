import 'dart:async';

import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// In-memory [WebSocketChannel]. Push server frames with [serverSend], drop the
/// connection with [serverClose], inspect what the client sent in [sent].
class FakeChannel extends StreamChannelMixin<dynamic>
    implements WebSocketChannel {
  FakeChannel({this.failHandshake = false, this.readyWhen});

  final bool failHandshake;

  /// When set, the handshake only completes once this future does.
  final Future<void>? readyWhen;
  bool closed = false;
  final List<String> sent = <String>[];
  final _incoming = StreamController<dynamic>();
  final _sink = _FakeSink();

  @override
  Future<void> get ready => failHandshake
      ? Future<void>.error(WebSocketChannelException('handshake failed'))
      : (readyWhen ?? Future<void>.value());

  @override
  Stream<dynamic> get stream => _incoming.stream;

  @override
  WebSocketSink get sink => _sink..owner = this;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  String? get protocol => null;

  void serverSend(String frame) => _incoming.add(frame);

  Future<void> serverClose() => _incoming.close();
}

class _FakeSink implements WebSocketSink {
  late FakeChannel owner;

  @override
  void add(dynamic data) => owner.sent.add(data as String);

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<dynamic> stream) => stream.forEach(add);

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    owner.closed = true;
  }

  @override
  Future<void> get done => Completer<void>().future;
}
