import 'package:tidy_admin/features/auth/domain/auth_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({
    required this.auth,
    required this.me,
    required this.storage,
    required this.sessionExpired,
  });

  final AuthApi auth;
  final MeApi me;
  final TokenStorage storage;

  @override
  final Stream<void> sessionExpired;

  @override
  Future<User?> restore() async {
    if (await storage.read() == null) return null;
    try {
      final user = await me.get();
      if (user.role != UserRole.admin) {
        await storage.clear();
        return null;
      }
      return user;
    } on UnauthorizedException {
      await storage.clear();
      return null;
    }
  }

  @override
  Future<void> requestOtp(String phone) => auth.requestOtp(phone);

  @override
  Future<User> verify({required String phone, required String code}) async {
    final session = await auth.verify(phone: phone, code: code);
    if (session.user.role != UserRole.admin) {
      await auth.logout();
      throw const NoAdminAccessException();
    }
    return session.user;
  }

  @override
  Future<void> logout() => auth.logout();
}
