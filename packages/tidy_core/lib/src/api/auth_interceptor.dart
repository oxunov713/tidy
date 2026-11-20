import 'dart:async';

import 'package:dio/dio.dart';
import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/auth/token_storage.dart';
import 'package:tidy_core/src/models/auth.dart';

/// Adds the bearer token and, on a 401, refreshes it once and retries.
///
/// Refreshing is single-flight: when several requests fail with 401 at the same
/// time, one `POST /auth/refresh` runs and the others wait for its result.
/// That matters because refresh tokens are rotated on every use; a second,
/// parallel refresh with the old token would be rejected and log the user out.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.storage,
    required this.dio,
    required this.refreshDio,
    this.onSessionExpired,
  });

  static const _generationKey = 'tidy.tokenGeneration';
  static const _retriedKey = 'tidy.retried';

  final TokenStorage storage;

  /// The client the interceptor is attached to; used to replay requests.
  final Dio dio;

  /// A separate client without this interceptor, used for the refresh call so
  /// it cannot recurse.
  final Dio refreshDio;

  /// Called after the server rejected the refresh token (401), once the stored tokens are cleared.
  final void Function()? onSessionExpired;

  Future<bool>? _inFlight;

  /// Bumped on every successful refresh. A request remembers the generation it
  /// was sent with, so a late 401 from the old token does not trigger a second
  /// refresh.
  int _generation = 0;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthKey] != true) {
      options.extra[_generationKey] = _generation;
      final tokens = await storage.read();
      if (tokens != null) {
        options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final canRetry =
        err.response?.statusCode == 401 &&
        request.extra[skipAuthKey] != true &&
        request.extra[_retriedKey] != true;
    if (!canRetry) return handler.next(err);

    final sentWith = request.extra[_generationKey] as int? ?? _generation;
    try {
      final ok = sentWith != _generation || await refresh();
      if (!ok) return handler.next(err);

      // onRequest runs again for the replay and picks up the new token.
      request.extra[_retriedKey] = true;
      handler.resolve(await dio.fetch<dynamic>(request));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// Refreshes the tokens now, joining a refresh that is already running.
  /// Returns false when the session could not be renewed.
  Future<bool> refresh() {
    final running = _inFlight;
    if (running != null) return running;
    final attempt = _doRefresh();
    _inFlight = attempt;
    return attempt.whenComplete(() => _inFlight = null);
  }

  Future<bool> _doRefresh() async {
    final current = await storage.read();
    if (current == null) return false;
    try {
      final response = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': current.refreshToken},
      );
      final tokens = TokenPair.fromJson(response.data!);
      await storage.write(tokens);
      _generation++;
      return true;
    } on DioException catch (e) {
      // Only a 401 means the refresh token is dead. Offline, 429 and 5xx are
      // temporary: keep the session and let the caller see the error.
      if (e.response?.statusCode != 401) rethrow;
      await storage.clear();
      onSessionExpired?.call();
      return false;
    }
  }
}
