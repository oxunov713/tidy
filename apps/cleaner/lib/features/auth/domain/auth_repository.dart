import 'package:tidy_core/tidy_core.dart';

/// Thrown when a phone number belongs to a client or admin account: the
/// cleaner app only works for cleaners.
class WrongRoleException implements Exception {
  const WrongRoleException();
}

abstract interface class AuthRepository {
  /// The signed-in user from stored tokens, or null when signed out.
  Future<User?> restore();

  Future<void> requestCode(String phone);

  /// Signs in and returns the full profile (with the cleaner status).
  /// Throws [WrongRoleException] for non-cleaner accounts.
  Future<User> verify({required String phone, required String code});

  Future<User> refreshProfile();

  Future<User> rename(String fullName);

  Future<void> signOut();
}
