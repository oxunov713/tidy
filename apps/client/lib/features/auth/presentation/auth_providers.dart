import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_core/tidy_core.dart';

part 'auth_providers.g.dart';

/// Sign-in for the client app: only client accounts get in.
@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) => SessionRepository(
  expectedRole: UserRole.client,
  api: ref.watch(apiClientProvider),
  storage: ref.watch(tokenStorageProvider),
  push: ref.watch(pushServiceProvider),
);

/// The signed-in user, or null when signed out. The router redirects on it.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<User?> build() async {
    // A rejected refresh token means the session is over.
    ref.listen(sessionExpiredProvider, (_, next) {
      if (next.hasValue) unawaited(_endSession());
    });
    final user = await ref.watch(sessionRepositoryProvider).restore();
    if (user != null) unawaited(_connectLive());
    return user;
  }

  Future<void> requestOtp(String phone) =>
      ref.read(sessionRepositoryProvider).requestOtp(phone);

  Future<void> verify({required String phone, required String code}) async {
    final user = await ref
        .read(sessionRepositoryProvider)
        .verify(phone: phone, code: code);
    state = AsyncData(user);
    unawaited(_connectLive());
  }

  Future<void> updateProfile({String? fullName, String? email}) async {
    final user = await ref
        .read(sessionRepositoryProvider)
        .updateProfile(fullName: fullName, email: email);
    state = AsyncData(user);
  }

  Future<void> logout() async {
    try {
      await ref.read(sessionRepositoryProvider).logout();
    } on ApiException {
      // Tokens are cleared locally either way.
    }
    await _endSession();
  }

  Future<void> _endSession() async {
    await ref.read(realtimeClientProvider).disconnect();
    state = const AsyncData(null);
  }

  Future<void> _connectLive() async {
    try {
      await ref.read(realtimeClientProvider).connect();
    } on Object {
      // The client reconnects by itself; sign in must not fail because of it.
    }
  }
}

/// Id of the signed-in user. Providers that hold per-user data watch this so
/// they start over after sign out and sign in as someone else.
@Riverpod(keepAlive: true)
String? currentUserId(Ref ref) => ref.watch(authControllerProvider).value?.id;

@Riverpod(keepAlive: true)
User? currentUser(Ref ref) => ref.watch(authControllerProvider).value;
