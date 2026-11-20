import 'package:tidy_core/src/api/api_transport.dart';
import 'package:tidy_core/src/models/models.dart';

/// Public catalogue, no sign-in needed.
class CatalogApi {
  CatalogApi(this._http);

  final ApiTransport _http;

  Future<List<Service>> services() async {
    final list = await _http.getList('/services');
    return list.map(Service.fromJson).toList();
  }

  Future<List<Extra>> extras() async {
    final list = await _http.getList('/extras');
    return list.map(Extra.fromJson).toList();
  }
}
