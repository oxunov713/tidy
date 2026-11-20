import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/core/realtime/realtime_gateway.dart';

part 'realtime_connection.g.dart';

/// Keeps the WebSocket open while the signed-in screens are on. Watch it from
/// the shell: it connects when the shell appears and disconnects when the
/// shell goes away (sign-out).
@riverpod
void realtimeConnection(Ref ref) {
  final gateway = ref.watch(realtimeGatewayProvider);
  unawaited(gateway.connect());
  ref.onDispose(() => unawaited(gateway.disconnect()));
}
