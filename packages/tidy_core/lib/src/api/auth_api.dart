import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/auth/token_storage.dart';
import 'package:tidy_core/src/models/models.dart';

/// Phone + one-time-code sign in.
///
/// [verify] stores the returned tokens and [logout] clears them, so the rest of
/// the app never touches [TokenStorage] directly.
class AuthApi {
  AuthApi(this._http, this._storage);

  final ApiTransport _http;
  final TokenStorage _storage;

  /// `POST /auth/otp`. In dev the code is printed in the backend log.
  Future<void> requestOtp(String phone) =>
      _http.postVoid('/auth/otp', body: {'phone': phone}, skipAuth: true);

  /// `POST /auth/verify`.
  ///
  /// [role] is only used when the phone number is new; pass `client` or
  /// `cleaner` from the matching app. Existing accounts keep their role, and
  /// admins sign in without one (the server rejects `admin`).
  Future<AuthSession> verify({
    required String phone,
    required String code,
    UserRole? role,
  }) async {
    assert(role != UserRole.admin, 'Admins sign in without a role');
    final json = await _http.postObjectPublic(
      '/auth/verify',
      body: VerifyRequest(phone: phone, code: code, role: role).toJson(),
    );
    final session = AuthSession.fromJson(json);
    await _storage.write(
      TokenPair(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      ),
    );
    return session;
  }

  /// `POST /auth/logout`. Local tokens are cleared even if the call fails.
  Future<void> logout() async {
    final tokens = await _storage.read();
    try {
      if (tokens != null) {
        await _http.postVoid(
          '/auth/logout',
          body: {'refresh_token': tokens.refreshToken},
          skipAuth: true,
        );
      }
    } finally {
      await _storage.clear();
    }
  }
}
