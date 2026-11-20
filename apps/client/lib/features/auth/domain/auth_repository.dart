import 'package:tidy_core/tidy_core.dart';

abstract interface class AuthRepository {
  /// The signed-in user if tokens are stored and still work, otherwise null.
  Future<User?> restoreSession();

  Future<void> requestOtp(String phone);

  /// Signs in as a client; the role only matters for new phone numbers.
  Future<User> verify({required String phone, required String code});

  Future<User> updateProfile({String? fullName, String? email});

  Future<void> logout();
}
