import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/core/realtime/realtime_gateway.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/jobs/data/cleaner_repositories.dart';
import 'package:tidy_core/tidy_core.dart';

part 'jobs_controller.g.dart';

/// The cleaner's schedule: yesterday to two weeks ahead.
///
/// Rooms of the jobs that are still open are joined so a status change (for
/// example the client cancelling) shows up without a refresh.
@Riverpod(keepAlive: true)
class JobsController extends _$JobsController {
  final _rooms = <String>{};

  @override
  Future<List<Job>> build() async {
    ref.watch(currentUserIdProvider);
    final gateway = ref.watch(realtimeGatewayProvider);
    final events = gateway.events.listen(_onEvent);
    ref.onDispose(() {
      unawaited(events.cancel());
      _rooms
        ..forEach(gateway.unsubscribe)
        ..clear();
    });

    final jobs = _sorted(await ref.read(jobsRepositoryProvider).jobs());
    if (ref.mounted) _syncRooms(jobs);
    return jobs;
  }

  /// Pull to refresh. Keeps the old list if the request fails.
  Future<void> refresh() async {
    final jobs = _sorted(await ref.read(jobsRepositoryProvider).jobs());
    if (!ref.mounted) return;
    _syncRooms(jobs);
    state = AsyncData(jobs);
  }

  /// Puts the booking the server just returned into the list.
  void applyBooking(Booking booking) {
    final jobs = state.value;
    if (jobs == null) return;
    state = AsyncData([
      for (final job in jobs)
        if (job.booking.id == booking.id)
          job.copyWith(booking: booking)
        else
          job,
    ]);
  }

  void _onEvent(RealtimeEvent event) {
    if (event is! BookingStatusChanged) return;
    final jobs = state.value;
    if (jobs == null) return;
    final job = jobs.where((j) => j.booking.id == event.bookingId).firstOrNull;
    if (job == null || job.booking.status == event.status) return;
    applyBooking(job.booking.copyWith(status: event.status));
  }

  void _syncRooms(List<Job> jobs) {
    final gateway = ref.read(realtimeGatewayProvider);
    final wanted = {
      for (final job in jobs)
        if (job.booking.status.isActive) Rooms.booking(job.booking.id),
    };
    _rooms.difference(wanted).forEach(gateway.unsubscribe);
    wanted.difference(_rooms).forEach(gateway.subscribe);
    _rooms
      ..clear()
      ..addAll(wanted);
  }

  static List<Job> _sorted(List<Job> jobs) =>
      [...jobs]..sort((a, b) => a.booking.start.compareTo(b.booking.start));
}
