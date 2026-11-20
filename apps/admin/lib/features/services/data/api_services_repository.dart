import 'package:tidy_admin/features/services/domain/services_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class ApiServicesRepository implements ServicesRepository {
  ApiServicesRepository(this._admin);

  final AdminApi _admin;

  @override
  Future<List<AdminService>> list() => _admin.services();

  @override
  Future<AdminService> update(String id, ServiceUpdate update) =>
      _admin.updateService(id, update);
}
