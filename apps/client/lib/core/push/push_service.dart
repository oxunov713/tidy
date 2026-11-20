import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_service.g.dart';

/// Push notifications behind a small interface, so the app builds without any
/// Firebase config. See the README for how to plug in `firebase_messaging`.
abstract interface class PushService {
  /// Asks for permission and starts listening. Called after sign in.
  Future<void> init();

  /// Current device token, when there is one.
  Future<String?> token();

  /// Called when the token changes, so it can be sent to `POST /me/devices`.
  void onTokenChanged(void Function(String token) listener);
}

/// Does nothing. The default until Firebase is configured.
class NoopPushService implements PushService {
  const NoopPushService();

  @override
  Future<void> init() async {}

  @override
  Future<String?> token() async => null;

  @override
  void onTokenChanged(void Function(String token) listener) {}
}

@Riverpod(keepAlive: true)
PushService pushService(Ref ref) => const NoopPushService();
