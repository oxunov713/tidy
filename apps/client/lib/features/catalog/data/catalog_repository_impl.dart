import 'package:tidy_client/features/catalog/domain/catalog_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({required this._api});

  final CatalogApi _api;

  @override
  Future<List<Service>> services() => _api.services();

  @override
  Future<List<Extra>> extras() => _api.extras();
}
