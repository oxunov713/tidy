import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/core/push/push_service.dart';
import 'package:tidy_cleaner/features/auth/domain/auth_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'api_auth_repository.g.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({
    required this.api,
    required this.tokens,
    required this.push,
  });

  final ApiClient api;
  final TokenStorage tokens;
  final PushService push;

  @override
  Future<User?> restore() async {
    if (await tokens.read() == null) return null;
    try {
      final user = await api.me.get();
      if (user.role != UserRole.cleaner) {
        await signOut();
        return null;
      }
      await _registerDevice();
      return user;
    } on UnauthorizedException {
      await tokens.clear();
      return null;
    }
  }

  @override
  Future<void> requestCode(String phone) => api.auth.requestOtp(phone);

  @override
  Future<User> verify({required String phone, required String code}) async {
    final session = await api.auth.verify(
      phone: phone,
      code: code,
      role: UserRole.cleaner,
    );
    if (session.user.role != UserRole.cleaner) {
      await signOut();
      throw const WrongRoleException();
    }
    // The verify response has no cleaner profile, and the status decides
    // which screen comes next.
    final user = await api.me.get();
    await _registerDevice();
    return user;
  }

  @override
  Future<User> refreshProfile() => api.me.get();

  @override
  Future<User> rename(String fullName) => api.me.update(fullName: fullName);

  @override
  Future<void> signOut() => api.auth.logout();

  Future<void> _registerDevice() async {
    try {
      await push.initialize();
      final token = await push.token();
      if (token == null) return;
      await api.me.registerDevice(
        token: token,
        platform: defaultTargetPlatform == TargetPlatform.iOS
            ? DevicePlatform.ios
            : DevicePlatform.android,
      );
    } on Object {
      // Push is a nice-to-have; never block signing in on it.
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => ApiAuthRepository(
  api: ref.watch(apiClientProvider),
  tokens: ref.watch(tokenStorageProvider),
  push: ref.watch(pushServiceProvider),
);
