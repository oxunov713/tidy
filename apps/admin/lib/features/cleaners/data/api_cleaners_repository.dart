import 'package:tidy_admin/features/cleaners/domain/cleaners_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class ApiCleanersRepository implements CleanersRepository {
  ApiCleanersRepository(this._admin);

  final AdminApi _admin;

  @override
  Future<List<User>> list() => _admin.cleaners();

  @override
  Future<void> approve(String id) => _admin.approveCleaner(id);

  @override
  Future<void> suspend(String id) => _admin.suspendCleaner(id);
}
