import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_service.g.dart';

/// Push notifications behind an interface. The app ships with
/// [NoopPushService]; see the README for plugging in `firebase_messaging`.
abstract interface class PushService {
  /// Asks for notification permission and starts listening.
  Future<void> initialize();

  /// The device token to send to `POST /me/devices`, if there is one.
  Future<String?> token();

  /// Fires when the token is rotated.
  Stream<String> get tokenRefreshes;
}

class NoopPushService implements PushService {
  const NoopPushService();

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get tokenRefreshes => const Stream.empty();
}

@Riverpod(keepAlive: true)
PushService pushService(Ref ref) => const NoopPushService();
