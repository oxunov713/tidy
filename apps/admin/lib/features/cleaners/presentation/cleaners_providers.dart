import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_admin/features/auth/presentation/auth_providers.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_admin/features/cleaners/data/api_cleaners_repository.dart';
import 'package:tidy_admin/features/cleaners/domain/cleaners_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'cleaners_providers.g.dart';

@Riverpod(keepAlive: true)
CleanersRepository cleanersRepository(Ref ref) {
  ref.watch(currentAdminIdProvider);
  return ApiCleanersRepository(ref.watch(adminApiProvider));
}

class CleanersState {
  const CleanersState({this.cleaners = const [], this.busy = const {}});

  final List<User> cleaners;

  /// Ids with a request in flight; their buttons are disabled.
  final Set<String> busy;

  List<User> withStatus(CleanerStatus status) => [
    for (final c in cleaners)
      if (c.cleaner?.status == status) c,
  ];

  int count(CleanerStatus status) => withStatus(status).length;

  CleanersState copyWith({List<User>? cleaners, Set<String>? busy}) =>
      CleanersState(
        cleaners: cleaners ?? this.cleaners,
        busy: busy ?? this.busy,
      );
}

/// All cleaners in one list; the tabs filter it by status.
@Riverpod(keepAlive: true)
class CleanersController extends _$CleanersController {
  @override
  Future<CleanersState> build() async {
    final list = await ref.watch(cleanersRepositoryProvider).list();
    return CleanersState(cleaners: list);
  }

  Future<void> approve(String id) => _change(id, CleanerStatus.approved);

  Future<void> suspend(String id) => _change(id, CleanerStatus.suspended);

  /// Moves the cleaner to its new tab at once and puts it back if the server
  /// says no. The error is rethrown for the page to show.
  Future<void> _change(String id, CleanerStatus target) async {
    final before = state.value;
    if (before == null || before.busy.contains(id)) return;
    state = AsyncData(
      before.copyWith(
        cleaners: [
          for (final c in before.cleaners)
            if (c.id == id) _with(c, target) else c,
        ],
        busy: {...before.busy, id},
      ),
    );
    final repo = ref.read(cleanersRepositoryProvider);
    try {
      await switch (target) {
        CleanerStatus.approved => repo.approve(id),
        CleanerStatus.suspended => repo.suspend(id),
        CleanerStatus.pending => throw ArgumentError('cannot set pending'),
      };
      ref.invalidate(statsControllerProvider);
    } on Object {
      _restore(id, before);
      rethrow;
    } finally {
      _release(id);
    }
  }

  void _restore(String id, CleanersState before) {
    final now = state.value;
    if (now == null) return;
    final original = before.cleaners.firstWhere((c) => c.id == id);
    state = AsyncData(
      now.copyWith(
        cleaners: [
          for (final c in now.cleaners)
            if (c.id == id) original else c,
        ],
      ),
    );
  }

  void _release(String id) {
    final now = state.value;
    if (now == null) return;
    state = AsyncData(now.copyWith(busy: {...now.busy}..remove(id)));
  }

  User _with(User user, CleanerStatus status) {
    final profile = user.cleaner;
    if (profile == null) return user;
    return user.copyWith(cleaner: profile.copyWith(status: status));
  }
}
