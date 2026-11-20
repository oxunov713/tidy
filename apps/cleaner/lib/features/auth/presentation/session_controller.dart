import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/auth/data/api_auth_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'session_controller.g.dart';

/// The signed-in cleaner, or null. The router redirects on this.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  Future<User?> build() {
    // A rejected refresh token clears the tokens; send the user to sign-in.
    ref.listen(sessionExpiredProvider, (_, _) => state = const AsyncData(null));
    return ref.read(authRepositoryProvider).restore();
  }

  Future<void> signIn({required String phone, required String code}) async {
    final user = await ref
        .read(authRepositoryProvider)
        .verify(phone: phone, code: code);
    state = AsyncData(user);
  }

  /// Pulls the profile again, e.g. to see that an admin approved the account.
  /// Failures keep the current user.
  Future<void> refresh() async {
    final user = await ref.read(authRepositoryProvider).refreshProfile();
    state = AsyncData(user);
  }

  Future<void> rename(String fullName) async {
    final user = await ref.read(authRepositoryProvider).rename(fullName);
    final cleaner = state.value?.cleaner;
    state = AsyncData(user.copyWith(cleaner: user.cleaner ?? cleaner));
  }

  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } finally {
      state = const AsyncData(null);
    }
  }
}
