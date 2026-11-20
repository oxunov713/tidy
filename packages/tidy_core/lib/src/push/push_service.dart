import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_service.g.dart';

/// Push notifications behind a small interface, so the apps build without any
/// Firebase config. To turn pushes on, implement this with
/// `firebase_messaging` and override [pushServiceProvider].
abstract interface class PushService {
  /// Asks for notification permission and starts listening. Called after
  /// sign in.
  Future<void> initialize();

  /// The device token to send to `POST /me/devices`, if there is one.
  Future<String?> token();

  /// Fires when the token is rotated, so it can be registered again.
  Stream<String> get tokenRefreshes;
}

/// Does nothing. The default until a real implementation is plugged in.
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
