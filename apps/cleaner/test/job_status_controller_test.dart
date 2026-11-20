import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidy_cleaner/features/active_job/domain/job_transitions.dart';
import 'package:tidy_cleaner/features/active_job/presentation/checklist_controller.dart';
import 'package:tidy_cleaner/features/active_job/presentation/job_status_controller.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fixtures.dart' as fx;
import 'support/harness.dart';

void main() {
  group('transitions', () {
    test('a cleaner can only move one step forward', () {
      expect(nextStatus(BookingStatus.assigned), BookingStatus.onTheWay);
      expect(nextStatus(BookingStatus.onTheWay), BookingStatus.inProgress);
      expect(nextStatus(BookingStatus.inProgress), BookingStatus.completed);
    });

    test('there is no step after completed or from other states', () {
      expect(nextStatus(BookingStatus.completed), isNull);
      expect(nextStatus(BookingStatus.cancelled), isNull);
      expect(nextStatus(BookingStatus.pending), isNull);
      expect(nextStatus(BookingStatus.confirmed), isNull);
    });

    test('every step the app takes is one the API accepts', () {
      for (final s in BookingStatus.values) {
        final next = nextStatus(s);
        if (next != null) {
          expect(BookingStatus.cleanerTransitions, contains(next));
        }
      }
    });

    test('the departure window opens 3 hours before the start', () {
      final b = fx.booking(start: DateTime.utc(2026, 12, 3, 13));
      expect(earliestDepartureTime(b), DateTime.utc(2026, 12, 3, 10));
    });
  });

  group('JobStatusController', () {
    late Harness h;
    late ProviderContainer c;

    Future<void> setUp0(List<Job> jobs) async {
      h = Harness();
      h.jobsRepo
        ..jobs_ = jobs
        ..onStatus = (id, status) => fx
            .booking(id: id, status: status)
            .copyWith(updatedAt: DateTime.utc(2026, 12, 3, 9, 40));
      c = await h.container();
      await c.read(jobsControllerProvider.future);
    }

    tearDown(() => c.dispose());

    BookingStatus statusOf(String id) => c
        .read(jobsControllerProvider)
        .value!
        .firstWhere((j) => j.booking.id == id)
        .booking
        .status;

    test('walks a job from assigned to completed', () async {
      await setUp0([fx.job()]);
      final controller = c.read(jobStatusControllerProvider('b1').notifier);

      await controller.advance();
      expect(statusOf('b1'), BookingStatus.onTheWay);
      await controller.advance();
      expect(statusOf('b1'), BookingStatus.inProgress);
      await controller.advance();
      expect(statusOf('b1'), BookingStatus.completed);

      expect(h.jobsRepo.statusCalls.map((e) => e.$2), [
        BookingStatus.onTheWay,
        BookingStatus.inProgress,
        BookingStatus.completed,
      ]);
      expect(c.read(jobStatusControllerProvider('b1')).failure, isNull);
    });

    test('does nothing once the job is completed', () async {
      await setUp0([fx.job(status: BookingStatus.completed)]);
      await c.read(jobStatusControllerProvider('b1').notifier).advance();
      expect(h.jobsRepo.statusCalls, isEmpty);
    });

    test('remembers when each step was reached', () async {
      await setUp0([fx.job()]);
      await c.read(jobStatusControllerProvider('b1').notifier).advance();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('job.b1.times'), contains('on_the_way'));
    });

    test(
      'invalid_transition on "on my way" explains the 3 hour rule',
      () async {
        final start = DateTime.utc(2026, 12, 3, 15);
        await setUp0([fx.job(start: start)]);
        h.jobsRepo.statusError = const InvalidTransitionException(
          message: 'too early',
        );

        await c.read(jobStatusControllerProvider('b1').notifier).advance();

        final failure = c.read(jobStatusControllerProvider('b1')).failure;
        expect(failure, isA<TooEarly>());
        expect(
          (failure! as TooEarly).availableFrom,
          DateTime.utc(2026, 12, 3, 12),
        );
        expect(statusOf('b1'), BookingStatus.assigned);
      },
    );

    test('invalid_transition later on means out of sync and reloads', () async {
      await setUp0([fx.job(status: BookingStatus.inProgress)]);
      h.jobsRepo.statusError = const InvalidTransitionException(
        message: 'cancelled',
      );
      final loads = h.jobsRepo.loads;

      await c.read(jobStatusControllerProvider('b1').notifier).advance();

      expect(
        c.read(jobStatusControllerProvider('b1')).failure,
        isA<OutOfSync>(),
      );
      expect(h.jobsRepo.loads, greaterThan(loads));
    });

    test('other errors are reported and the job stays as it was', () async {
      await setUp0([fx.job()]);
      h.jobsRepo.statusError = const NetworkException();

      await c.read(jobStatusControllerProvider('b1').notifier).advance();

      final failure = c.read(jobStatusControllerProvider('b1')).failure;
      expect(failure, isA<RequestFailed>());
      expect(statusOf('b1'), BookingStatus.assigned);
      expect(c.read(jobStatusControllerProvider('b1')).busy, isFalse);
    });

    test('a status pushed over the socket updates the job', () async {
      await setUp0([fx.job()]);
      h.gateway.emit(
        BookingStatusChanged(
          bookingId: 'b1',
          status: BookingStatus.cancelled,
          at: fx.now,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(statusOf('b1'), BookingStatus.cancelled);
    });

    test('rooms of open jobs are joined', () async {
      await setUp0([
        fx.job(),
        fx.job(id: 'b2', status: BookingStatus.completed),
      ]);
      expect(h.gateway.subscribed, [Rooms.booking('b1')]);
    });
  });

  group('checklist', () {
    test('ticks are written to preferences, per job', () async {
      final c = await Harness().container();
      final notifier = c.read(checklistControllerProvider('b1').notifier);
      await notifier.toggle('bath');
      await notifier.toggle('floors');
      await notifier.toggle('bath');

      expect(c.read(checklistControllerProvider('b1')), {'floors'});
      expect(c.read(checklistControllerProvider('b2')), isEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('job.b1.checklist'), ['floors']);
      c.dispose();
    });

    test('ticks saved earlier are there after a restart', () async {
      final c = await Harness().container(
        prefs: {
          'job.b1.checklist': ['kitchen', 'extra:e1'],
        },
      );
      expect(c.read(checklistControllerProvider('b1')), {
        'kitchen',
        'extra:e1',
      });
      c.dispose();
    });
  });
}
