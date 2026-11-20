import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_admin/features/auth/presentation/auth_providers.dart';
import 'package:tidy_admin/features/services/data/api_services_repository.dart';
import 'package:tidy_admin/features/services/domain/services_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'services_providers.g.dart';

@Riverpod(keepAlive: true)
ServicesRepository servicesRepository(Ref ref) {
  ref.watch(currentAdminIdProvider);
  return ApiServicesRepository(ref.watch(adminApiProvider));
}

/// The body for `PUT /admin/services/{id}` built from a service as it is now.
/// The server replaces every field and rejects a missing `is_active`, so
/// every update starts from the whole service.
ServiceUpdate updateFrom(AdminService s, {bool? isActive}) => ServiceUpdate(
  title: s.title,
  basePrice: s.basePrice,
  perBedroom: s.perBedroom,
  perBathroom: s.perBathroom,
  baseMinutes: s.baseMinutes,
  minutesPerRoom: s.minutesPerRoom,
  isActive: isActive ?? s.isActive,
);

@Riverpod(keepAlive: true)
class ServicesController extends _$ServicesController {
  @override
  Future<List<AdminService>> build() =>
      ref.watch(servicesRepositoryProvider).list();

  /// Saves the edit form. Throws the `ApiException` so the dialog can show
  /// it next to the fields.
  Future<void> save(String id, ServiceUpdate update) async {
    final saved = await ref.read(servicesRepositoryProvider).update(id, update);
    _replace(saved);
  }

  /// Flips the active switch at once; puts it back when the call fails and
  /// rethrows for the page to report.
  Future<void> setActive(AdminService service, {required bool active}) async {
    final list = state.value;
    if (list == null) return;
    _replace(_copy(service, isActive: active));
    try {
      final saved = await ref
          .read(servicesRepositoryProvider)
          .update(service.id, updateFrom(service, isActive: active));
      _replace(saved);
    } on Object {
      _replace(service);
      rethrow;
    }
  }

  void _replace(AdminService next) {
    final list = state.value;
    if (list == null) return;
    state = AsyncData([
      for (final s in list)
        if (s.id == next.id) next else s,
    ]);
  }

  AdminService _copy(AdminService s, {required bool isActive}) =>
      s.copyWith(isActive: isActive);
}
