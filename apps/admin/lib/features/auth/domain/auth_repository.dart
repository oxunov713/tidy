import 'package:tidy_core/tidy_core.dart';

/// Thrown when a phone number signs in fine but is not an admin.
class NoAdminAccessException implements Exception {
  const NoAdminAccessException();

  @override
  String toString() => 'NoAdminAccessException';
}

abstract interface class AuthRepository {
  /// The signed-in admin from stored tokens, or null when there are none or
  /// the server no longer accepts them.
  Future<User?> restore();

  Future<void> requestOtp(String phone);

  /// Signs in without a role. Throws [NoAdminAccessException] (and drops the
  /// tokens again) when the account is not an admin.
  Future<User> verify({required String phone, required String code});

  Future<void> logout();

  /// Fires when a refresh token was rejected.
  Stream<void> get sessionExpired;
}
