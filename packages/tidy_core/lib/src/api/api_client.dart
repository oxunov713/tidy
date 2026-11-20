import 'dart:async';

import 'package:dio/dio.dart';
import 'package:tidy_core/src/api/admin_api.dart';
import 'package:tidy_core/src/api/api_config.dart';
import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/api/auth_api.dart';
import 'package:tidy_core/src/api/auth_interceptor.dart';
import 'package:tidy_core/src/api/booking_api.dart';
import 'package:tidy_core/src/api/catalog_api.dart';
import 'package:tidy_core/src/api/cleaner_api.dart';
import 'package:tidy_core/src/api/me_api.dart';
import 'package:tidy_core/src/auth/token_storage.dart';

/// Entry point to the REST API, split by area:
/// [auth], [me], [catalog], [bookings], [cleaner] and [admin].
class ApiClient {
  ApiClient({
    required ApiConfig config,
    required TokenStorage tokenStorage,
    HttpClientAdapter? httpClientAdapter,
    Duration timeout = const Duration(seconds: 20),
  }) {
    BaseOptions options() => BaseOptions(
      baseUrl: config.restBase,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      contentType: Headers.jsonContentType,
      headers: {Headers.acceptHeader: Headers.jsonContentType},
    );

    final dio = Dio(options());
    final refreshDio = Dio(options());
    if (httpClientAdapter != null) {
      dio.httpClientAdapter = httpClientAdapter;
      refreshDio.httpClientAdapter = httpClientAdapter;
    }
    dio.interceptors.add(
      AuthInterceptor(
        storage: tokenStorage,
        dio: dio,
        refreshDio: refreshDio,
        onSessionExpired: () => _sessionExpired.add(null),
      ),
    );
    _dio = dio;
    _refreshDio = refreshDio;

    final http = ApiTransport(dio);
    auth = AuthApi(http, tokenStorage);
    me = MeApi(http);
    catalog = CatalogApi(http);
    bookings = BookingApi(http);
    cleaner = CleanerApi(http);
    admin = AdminApi(http);
  }

  late final Dio _dio;
  late final Dio _refreshDio;
  final _sessionExpired = StreamController<void>.broadcast();

  late final AuthApi auth;
  late final MeApi me;
  late final CatalogApi catalog;
  late final BookingApi bookings;
  late final CleanerApi cleaner;
  late final AdminApi admin;

  /// Fires when a refresh was rejected and the stored tokens were cleared.
  /// Listen to it to send the user back to the sign-in screen.
  Stream<void> get sessionExpired => _sessionExpired.stream;

  void close() {
    _dio.close();
    _refreshDio.close();
    unawaited(_sessionExpired.close());
  }
}
