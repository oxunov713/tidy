import 'package:tidy_client/features/auth/domain/auth_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._auth,
    required this._me,
    required this._storage,
  });

  final AuthApi _auth;
  final MeApi _me;
  final TokenStorage _storage;

  @override
  Future<User?> restoreSession() async {
    if (await _storage.read() == null) return null;
    try {
      return await _me.get();
    } on UnauthorizedException {
      await _storage.clear();
      return null;
    }
  }

  @override
  Future<void> requestOtp(String phone) => _auth.requestOtp(phone);

  @override
  Future<User> verify({required String phone, required String code}) async {
    final session = await _auth.verify(
      phone: phone,
      code: code,
      role: UserRole.client,
    );
    return session.user;
  }

  @override
  Future<User> updateProfile({String? fullName, String? email}) =>
      _me.update(fullName: fullName, email: email);

  @override
  Future<void> logout() => _auth.logout();
}
