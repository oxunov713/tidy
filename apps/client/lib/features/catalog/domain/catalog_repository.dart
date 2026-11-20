import 'package:tidy_core/tidy_core.dart';

abstract interface class CatalogRepository {
  Future<List<Service>> services();
  Future<List<Extra>> extras();
}
