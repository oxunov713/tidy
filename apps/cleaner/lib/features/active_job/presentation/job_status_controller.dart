import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/active_job/data/job_local_store.dart';
import 'package:tidy_cleaner/features/active_job/domain/job_transitions.dart';
import 'package:tidy_cleaner/features/jobs/data/cleaner_repositories.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_core/tidy_core.dart';

part 'job_status_controller.g.dart';

sealed class JobFailure {
  const JobFailure();
}

/// `on_the_way` was refused because the job starts in more than 3 hours.
final class TooEarly extends JobFailure {
  const TooEarly(this.availableFrom);

  final DateTime availableFrom;
}

/// The server and the phone disagree about the status, for example the
/// client cancelled. The schedule has been reloaded.
final class OutOfSync extends JobFailure {
  const OutOfSync();
}

final class RequestFailed extends JobFailure {
  const RequestFailed(this.error);

  final Object error;
}

class JobActionState {
  const JobActionState({this.busy = false, this.failure});

  final bool busy;
  final JobFailure? failure;
}

/// Moves one job along: assigned, on the way, in progress, completed.
@riverpod
class JobStatusController extends _$JobStatusController {
  @override
  JobActionState build(String bookingId) => const JobActionState();

  Future<void> advance() async {
    if (state.busy) return;
    final job = ref
        .read(jobsControllerProvider)
        .value
        ?.where((j) => j.booking.id == bookingId)
        .firstOrNull;
    final next = job == null ? null : nextStatus(job.booking.status);
    if (job == null || next == null) return;

    state = const JobActionState(busy: true);
    try {
      final booking = await ref
          .read(jobsRepositoryProvider)
          .setStatus(bookingId, next);
      if (!ref.mounted) return;
      await ref
          .read(jobLocalStoreProvider)
          .saveTime(bookingId, next, booking.updatedAt);
      ref.read(jobsControllerProvider.notifier).applyBooking(booking);
      state = const JobActionState();
    } on InvalidTransitionException {
      if (!ref.mounted) return;
      // Only the first step has a time rule; for the others the phone is
      // simply behind the server.
      final failure = next == BookingStatus.onTheWay
          ? TooEarly(earliestDepartureTime(job.booking))
          : const OutOfSync();
      if (failure is OutOfSync) {
        await ref
            .read(jobsControllerProvider.notifier)
            .refresh()
            .onError<Object>(
              (_, _) {},
            );
      }
      if (ref.mounted) state = JobActionState(failure: failure);
    } on Object catch (e) {
      if (ref.mounted) state = JobActionState(failure: RequestFailed(e));
    }
  }

  void consumeFailure() => state = const JobActionState();
}
