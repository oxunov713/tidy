/// Where the backend lives.
///
/// The base URL is the server origin, without `/api/v1`. Override it at build
/// time: `flutter run --dart-define=API_URL=https://tidy.example.com`.
class ApiConfig {
  const ApiConfig({required this.baseUrl});

  /// 10.0.2.2 is the host machine as seen from the Android emulator; iOS
  /// simulators and web can use localhost, so pass `API_URL` when needed.
  const ApiConfig.fromEnvironment()
    : baseUrl = const String.fromEnvironment(
        'API_URL',
        defaultValue: 'http://localhost:8080',
      );

  final String baseUrl;

  String get _origin => baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;

  /// Base for every REST call.
  String get restBase => '$_origin/api/v1';

  /// WebSocket endpoint with the access token in the query string.
  Uri websocketUri(String accessToken) {
    final http = Uri.parse('$restBase/ws');
    return http.replace(
      scheme: http.scheme == 'https' ? 'wss' : 'ws',
      queryParameters: {'token': accessToken},
    );
  }
}
