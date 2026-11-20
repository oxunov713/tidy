import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_core/tidy_core.dart';

part 'auth_providers.g.dart';

/// Id of the signed-in admin. Repositories watch it, so nothing cached for one
/// admin survives a sign-out.
@Riverpod(keepAlive: true)
String? currentAdminId(Ref ref) => ref.watch(authControllerProvider).value?.id;

/// Sign-in for the admin panel. The server never creates an admin account, so
/// a phone that is not one is refused with a 403.
@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) => SessionRepository(
  expectedRole: UserRole.admin,
  api: ref.watch(apiClientProvider),
  storage: ref.watch(tokenStorageProvider),
  push: ref.watch(pushServiceProvider),
);

/// The signed-in admin, or null. The router listens to this.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<User?> build() async {
    // A rejected refresh token means the session is over.
    ref.listen(sessionExpiredProvider, (_, next) {
      if (next.hasValue) state = const AsyncData(null);
    });
    return ref.watch(sessionRepositoryProvider).restore();
  }

  void signedIn(User user) => state = AsyncData(user);

  Future<void> signOut() async {
    try {
      await ref.read(sessionRepositoryProvider).logout();
    } finally {
      state = const AsyncData(null);
    }
  }

  /// Retry after the start-up check failed, e.g. the API was unreachable.
  void retry() => ref.invalidateSelf();
}
