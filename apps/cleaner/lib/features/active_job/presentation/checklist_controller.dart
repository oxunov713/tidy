import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/active_job/data/job_local_store.dart';

part 'checklist_controller.g.dart';

/// Ids of the checklist items ticked for a job. Saved on the phone, so the
/// ticks survive closing the app.
@riverpod
class ChecklistController extends _$ChecklistController {
  @override
  Set<String> build(String jobId) =>
      ref.read(jobLocalStoreProvider).checked(jobId);

  Future<void> toggle(String itemId) {
    final next = {...state};
    if (!next.remove(itemId)) next.add(itemId);
    state = next;
    return ref.read(jobLocalStoreProvider).saveChecked(jobId, next);
  }
}
