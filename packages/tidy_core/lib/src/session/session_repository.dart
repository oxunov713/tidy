import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tidy_core/src/api/api_client.dart';
import 'package:tidy_core/src/api/api_exception.dart';
import 'package:tidy_core/src/auth/token_storage.dart';
import 'package:tidy_core/src/models/models.dart';
import 'package:tidy_core/src/push/push_service.dart';

/// Thrown when the account that signed in has another role than the app is
/// for. The account is signed out again before this is thrown.
class WrongRoleException implements Exception {
  const WrongRoleException({required this.expected, required this.actual});

  final UserRole expected;
  final UserRole actual;

  @override
  String toString() => 'WrongRoleException(expected $expected, got $actual)';
}

/// Sign-in, restore and sign-out for one app. The client, cleaner and admin
/// apps each build one with the role they are for, and all three behave the
/// same way:
///
/// * [restore] keeps the session when the network or server is down (the
///   error is rethrown so the app can offer a retry) and ends it only when
///   the server rejects the tokens or the account has the wrong role;
/// * [verify] sends the expected role, and signs out again if the server
///   answered with another one;
/// * [logout] stops pushes to this device, takes a cleaner offline, then
///   signs out. Local tokens are cleared whatever the server says.
class SessionRepository {
  SessionRepository({
    required this.expectedRole,
    required this._api,
    required this._storage,
    this._push = const NoopPushService(),
    this._platform,
  });

  final UserRole expectedRole;
  final ApiClient _api;
  final TokenStorage _storage;
  final PushService _push;
  final DevicePlatform? _platform;

  StreamSubscription<String>? _tokenRefreshes;

  /// The signed-in user from stored tokens, or null when signed out.
  ///
  /// Throws an [ApiException] (for example a [NetworkException]) when the
  /// check could not be made; the session is kept.
  Future<User?> restore() async {
    if (await _storage.read() == null) return null;
    final User user;
    try {
      user = await _api.me.get();
    } on UnauthorizedException {
      await _storage.clear();
      return null;
    }
    if (user.role != expectedRole) {
      await _dropSession();
      return null;
    }
    await _startPush();
    return user;
  }

  Future<void> requestOtp(String phone) => _api.auth.requestOtp(phone);

  /// Signs in and returns the full profile (the cleaner status included, which
  /// the verify response lacks).
  ///
  /// Throws a `ForbiddenException` with the server's message when the number is
  /// registered with another role, and [WrongRoleException] if a server that
  /// does not check the role let it through.
  Future<User> verify({required String phone, required String code}) async {
    final session = await _api.auth.verify(
      phone: phone,
      code: code,
      role: expectedRole,
    );
    if (session.user.role != expectedRole) {
      await _dropSession();
      throw WrongRoleException(
        expected: expectedRole,
        actual: session.user.role,
      );
    }
    final user = expectedRole == UserRole.cleaner
        ? await _api.me.get()
        : session.user;
    await _startPush();
    return user;
  }

  Future<User> refreshProfile() => _api.me.get();

  Future<User> updateProfile({String? fullName, String? email}) =>
      _api.me.update(fullName: fullName, email: email);

  /// Ends the session. Never throws for a failing server call.
  Future<void> logout() async {
    await _tokenRefreshes?.cancel();
    _tokenRefreshes = null;
    await _bestEffort(_unregisterDevice);
    if (expectedRole == UserRole.cleaner) {
      // Otherwise the dispatcher keeps offering jobs to a signed-out phone.
      await _bestEffort(() => _api.cleaner.setOnline(online: false));
    }
    await _dropSession();
  }

  Future<void> _dropSession() async {
    await _tokenRefreshes?.cancel();
    _tokenRefreshes = null;
    try {
      await _api.auth.logout();
    } on Object {
      // The local tokens are cleared by logout() either way.
    }
  }

  Future<void> _startPush() async {
    await _bestEffort(() async {
      await _push.initialize();
      await _registerDevice(await _push.token());
    });
    await _tokenRefreshes?.cancel();
    _tokenRefreshes = _push.tokenRefreshes.listen(
      (token) => unawaited(_bestEffort(() => _registerDevice(token))),
    );
  }

  Future<void> _registerDevice(String? token) async {
    if (token == null) return;
    await _api.me.registerDevice(token: token, platform: _devicePlatform());
  }

  Future<void> _unregisterDevice() async {
    final token = await _push.token();
    if (token == null) return;
    await _api.me.unregisterDevice(token);
  }

  DevicePlatform _devicePlatform() =>
      _platform ??
      (kIsWeb
          ? DevicePlatform.web
          : defaultTargetPlatform == TargetPlatform.iOS
          ? DevicePlatform.ios
          : DevicePlatform.android);

  /// Push and the offline switch are nice to have; they must never keep
  /// someone from signing in or out.
  Future<void> _bestEffort(Future<void> Function() action) async {
    try {
      await action();
    } on Object {
      // Ignored on purpose.
    }
  }
}
