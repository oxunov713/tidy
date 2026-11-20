import 'package:dio/dio.dart';
import 'package:tidy_core/src/api/api_exception.dart';

typedef Json = Map<String, dynamic>;

/// Thin layer over dio used by all API groups. It decodes JSON and turns every
/// failure into an [ApiException], so callers never see a [DioException].
class ApiTransport {
  ApiTransport(this.dio);

  final Dio dio;

  Future<Json> getObject(String path, {Json? query}) =>
      _send<Json>('GET', path, query: query).then(_object);

  Future<List<Json>> getList(
    String path, {
    Json? query,
    bool skipAuth = false,
  }) => _send<List<dynamic>>(
    'GET',
    path,
    query: query,
    skipAuth: skipAuth,
  ).then(_list);

  Future<Json> postObject(String path, {Object? body}) =>
      _send<Json>('POST', path, body: body).then(_object);

  Future<List<Json>> putList(String path, {Object? body}) =>
      _send<List<dynamic>>('PUT', path, body: body).then(_list);

  Future<Json> putObject(String path, {Object? body}) =>
      _send<Json>('PUT', path, body: body).then(_object);

  /// For endpoints documented as `204` or whose body the app does not need.
  Future<void> postVoid(String path, {Object? body, bool skipAuth = false}) =>
      _send<Object>('POST', path, body: body, skipAuth: skipAuth);

  Future<Json> patchObject(String path, {Object? body}) =>
      _send<Json>('PATCH', path, body: body).then(_object);

  Future<void> deleteVoid(String path) => _send<Object>('DELETE', path);

  /// Like [postObject] but for calls that skip the bearer header
  /// (login, refresh).
  Future<Json> postObjectPublic(String path, {Object? body}) =>
      _send<Json>('POST', path, body: body, skipAuth: true).then(_object);

  Future<T?> _send<T>(
    String method,
    String path, {
    Json? query,
    Object? body,
    bool skipAuth = false,
  }) async {
    try {
      final response = await dio.request<T>(
        path,
        data: body,
        queryParameters: query,
        options: Options(
          method: method,
          extra: {if (skipAuth) skipAuthKey: true},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Json _object(Object? data) {
    if (data is Json) return data;
    throw const UnknownApiException(message: 'Expected a JSON object');
  }

  List<Json> _list(Object? data) {
    if (data is List) return data.cast<Json>();
    throw const UnknownApiException(message: 'Expected a JSON array');
  }
}

/// `RequestOptions.extra` flag: do not attach a bearer token and do not try to
/// refresh on 401.
const skipAuthKey = 'tidy.skipAuth';
