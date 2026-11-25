import 'package:tidy_core/src/models/models.dart';
import 'package:tidy_core/src/session/session_repository.dart';

/// A [SessionRepository] for tests: [restoreResult], [verifyResult] and the
/// `*Error` fields decide what happens, calls are recorded.
class FakeSessionRepository implements SessionRepository {
  FakeSessionRepository({
    this.expectedRole = UserRole.client,
    this.restoreResult,
    this.verifyResult,
  });

  @override
  final UserRole expectedRole;

  User? restoreResult;
  User? verifyResult;
  Exception? restoreError;
  Exception? requestOtpError;
  Exception? verifyError;
  Exception? logoutError;

  final requestedPhones = <String>[];
  final verifyCalls = <({String phone, String code})>[];
  int restoreCalls = 0;
  int logoutCalls = 0;

  @override
  Future<User?> restore() async {
    restoreCalls++;
    if (restoreError != null) throw restoreError!;
    return restoreResult;
  }

  @override
  Future<void> requestOtp(String phone) async {
    requestedPhones.add(phone);
    if (requestOtpError != null) throw requestOtpError!;
  }

  @override
  Future<User> verify({required String phone, required String code}) async {
    verifyCalls.add((phone: phone, code: code));
    if (verifyError != null) throw verifyError!;
    return verifyResult!;
  }

  @override
  Future<User> refreshProfile() async => restoreResult ?? verifyResult!;

  @override
  Future<User> updateProfile({String? fullName, String? email}) async =>
      (restoreResult ?? verifyResult!).copyWith(
        fullName: fullName ?? (restoreResult ?? verifyResult!).fullName,
        email: email ?? (restoreResult ?? verifyResult!).email,
      );

  @override
  Future<void> logout() async {
    logoutCalls++;
    if (logoutError != null) throw logoutError!;
  }
}
