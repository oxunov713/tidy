import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/schedule/data/api_availability_repository.dart';
import 'package:tidy_cleaner/features/schedule/domain/availability.dart';

part 'availability_controller.g.dart';

class AvailabilityState {
  const AvailabilityState({
    required this.draft,
    required this.saved,
    this.saving = false,
  });

  /// What the screen shows.
  final AvailabilityDraft draft;

  /// What the server has.
  final AvailabilityDraft saved;
  final bool saving;

  bool get dirty => draft != saved;

  AvailabilityState copyWith({AvailabilityDraft? draft, bool? saving}) =>
      AvailabilityState(
        draft: draft ?? this.draft,
        saved: saved,
        saving: saving ?? this.saving,
      );
}

/// Weekly working hours: weekday toggles and one from/to range, saved with
/// `PUT /cleaner/availability`.
@Riverpod(keepAlive: true)
class AvailabilityController extends _$AvailabilityController {
  @override
  Future<AvailabilityState> build() async {
    ref.watch(currentUserIdProvider);
    final windows = await ref.read(availabilityRepositoryProvider).load();
    final saved = AvailabilityDraft.fromWindows(windows);
    // A cleaner without any hours gets nothing offered, so start from a
    // sensible week and let the "save" button nudge them.
    return AvailabilityState(
      draft: windows.isEmpty ? AvailabilityDraft.standard : saved,
      saved: saved,
    );
  }

  void toggleDay(int weekday) {
    _edit((d) {
      final days = {...d.weekdays};
      if (!days.remove(weekday)) days.add(weekday);
      return d.copyWith(weekdays: days);
    });
  }

  void setFrom(int minutes) => _edit((d) => d.copyWith(fromMinutes: minutes));

  void setTo(int minutes) => _edit((d) => d.copyWith(toMinutes: minutes));

  /// Throws on failure; the edit stays so the cleaner can try again.
  Future<void> save() async {
    final current = state.value;
    if (current == null || current.saving || !current.draft.isValid) return;
    state = AsyncData(current.copyWith(saving: true));
    try {
      final windows = await ref
          .read(availabilityRepositoryProvider)
          .save(current.draft.toWindows());
      if (!ref.mounted) return;
      final saved = AvailabilityDraft.fromWindows(windows);
      state = AsyncData(
        AvailabilityState(
          draft: windows.isEmpty ? current.draft : saved,
          saved: saved,
        ),
      );
    } on Object {
      if (ref.mounted) state = AsyncData(current.copyWith(saving: false));
      rethrow;
    }
  }

  void _edit(AvailabilityDraft Function(AvailabilityDraft) change) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(draft: change(current.draft)));
  }
}
