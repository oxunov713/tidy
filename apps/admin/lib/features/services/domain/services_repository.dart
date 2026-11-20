import 'package:tidy_core/tidy_core.dart';

abstract interface class ServicesRepository {
  Future<List<AdminService>> list();

  /// Replaces every field of the service, `is_active` included.
  Future<AdminService> update(String id, ServiceUpdate update);
}
