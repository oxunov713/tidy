import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_core/tidy_core.dart';

part 'session_controller.g.dart';

/// Sign-in for the cleaner app: only cleaner accounts get in, and signing out
/// takes the cleaner offline first.
@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) => SessionRepository(
  expectedRole: UserRole.cleaner,
  api: ref.watch(apiClientProvider),
  storage: ref.watch(tokenStorageProvider),
  push: ref.watch(pushServiceProvider),
);

/// The signed-in cleaner, or null. The router redirects on this.
///
/// While the start-up check is running, or when it failed because the network
/// is down (the state is then an error), the router keeps the splash screen
/// with a retry button instead of sending the user to sign-in.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  Future<User?> build() {
    // A rejected refresh token clears the tokens; send the user to sign-in.
    ref.listen(sessionExpiredProvider, (_, _) => state = const AsyncData(null));
    return ref.read(sessionRepositoryProvider).restore();
  }

  Future<void> signIn({required String phone, required String code}) async {
    final user = await ref
        .read(sessionRepositoryProvider)
        .verify(phone: phone, code: code);
    state = AsyncData(user);
  }

  /// Pulls the profile again, e.g. to see that an admin approved the account.
  /// Failures keep the current user.
  Future<void> refresh() async {
    final user = await ref.read(sessionRepositoryProvider).refreshProfile();
    state = AsyncData(user);
  }

  Future<void> rename(String fullName) async {
    final user = await ref
        .read(sessionRepositoryProvider)
        .updateProfile(fullName: fullName);
    final cleaner = state.value?.cleaner;
    state = AsyncData(user.copyWith(cleaner: user.cleaner ?? cleaner));
  }

  Future<void> signOut() async {
    try {
      await ref.read(sessionRepositoryProvider).logout();
    } finally {
      state = const AsyncData(null);
    }
  }
}

/// Id of the signed-in cleaner. Controllers that hold per-user data watch it,
/// so they start fresh after a sign-out and sign-in as someone else.
@Riverpod(keepAlive: true)
String? currentUserId(Ref ref) =>
    ref.watch(sessionControllerProvider.select((s) => s.value?.id));
