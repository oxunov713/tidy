import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/core/realtime/live_channel.dart';
import 'package:tidy_client/features/auth/data/auth_repository_impl.dart';
import 'package:tidy_client/features/auth/domain/auth_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  auth: ref.watch(authApiProvider),
  me: ref.watch(meApiProvider),
  storage: ref.watch(tokenStorageProvider),
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
    final user = await ref.watch(authRepositoryProvider).restoreSession();
    if (user != null) unawaited(_connectLive());
    return user;
  }

  Future<void> requestOtp(String phone) =>
      ref.read(authRepositoryProvider).requestOtp(phone);

  Future<void> verify({required String phone, required String code}) async {
    final user = await ref
        .read(authRepositoryProvider)
        .verify(phone: phone, code: code);
    state = AsyncData(user);
    unawaited(_connectLive());
  }

  Future<void> updateProfile({String? fullName, String? email}) async {
    final user = await ref
        .read(authRepositoryProvider)
        .updateProfile(fullName: fullName, email: email);
    state = AsyncData(user);
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } on ApiException {
      // Tokens are cleared locally either way.
    }
    await _endSession();
  }

  Future<void> _endSession() async {
    await ref.read(liveChannelProvider).disconnect();
    state = const AsyncData(null);
  }

  Future<void> _connectLive() async {
    try {
      await ref.read(liveChannelProvider).connect();
    } on Object {
      // The client reconnects by itself; sign in must not fail because of it.
    }
  }
}
