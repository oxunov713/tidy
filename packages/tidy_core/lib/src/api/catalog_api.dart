import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/models/models.dart';

/// Public catalogue, no sign-in needed (no token is sent).
class CatalogApi {
  CatalogApi(this._http);

  final ApiTransport _http;

  Future<List<Service>> services() async {
    final list = await _http.getList('/services', skipAuth: true);
    return list.map(Service.fromJson).toList();
  }

  Future<List<Extra>> extras() async {
    final list = await _http.getList('/extras', skipAuth: true);
    return list.map(Extra.fromJson).toList();
  }
}
