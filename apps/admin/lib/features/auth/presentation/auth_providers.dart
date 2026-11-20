import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_admin/features/auth/data/api_auth_repository.dart';
import 'package:tidy_admin/features/auth/domain/auth_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'auth_providers.g.dart';

/// Id of the signed-in admin. Repositories watch it, so nothing cached for one
/// admin survives a sign-out.
@Riverpod(keepAlive: true)
String? currentAdminId(Ref ref) => ref.watch(authControllerProvider).value?.id;

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => ApiAuthRepository(
  auth: ref.watch(authApiProvider),
  me: ref.watch(meApiProvider),
  storage: ref.watch(tokenStorageProvider),
  sessionExpired: ref.watch(apiClientProvider).sessionExpired,
);

/// The signed-in admin, or null. The router listens to this.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<User?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final expired = repo.sessionExpired.listen(
      (_) => state = const AsyncData(null),
    );
    ref.onDispose(expired.cancel);
    return repo.restore();
  }

  void signedIn(User user) => state = AsyncData(user);

  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } finally {
      state = const AsyncData(null);
    }
  }

  /// Retry after the start-up check failed, e.g. the API was unreachable.
  void retry() => ref.invalidateSelf();
}
