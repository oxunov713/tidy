import 'package:tidy_core/tidy_core.dart';

/// Gaps shorter than this between two jobs are travel time, not free time.
const travelBufferLimit = Duration(minutes: 60);

sealed class TimelineEntry {
  const TimelineEntry(this.at);

  /// The instant the entry starts at.
  final DateTime at;
}

final class TimelineJob extends TimelineEntry {
  TimelineJob(this.job) : super(job.booking.start);

  final Job job;
}

final class TimelineFree extends TimelineEntry {
  const TimelineFree(super.at);
}

final class TimelineBuffer extends TimelineEntry {
  const TimelineBuffer(super.at, this.minutes);

  final int minutes;
}

/// Lays a day out as jobs with the gaps between them. [workStart] is where
/// the cleaner's working hours begin (null on a day off); a "Free" row is
/// shown there when the first job starts later.
List<TimelineEntry> buildTimeline({
  required List<Job> jobs,
  DateTime? workStart,
}) {
  final sorted = [...jobs]
    ..sort((a, b) => a.booking.start.compareTo(b.booking.start));
  final entries = <TimelineEntry>[];

  if (workStart != null &&
      (sorted.isEmpty || workStart.isBefore(sorted.first.booking.start))) {
    entries.add(TimelineFree(workStart));
  }
  for (final (i, job) in sorted.indexed) {
    entries.add(TimelineJob(job));
    if (i + 1 == sorted.length) break;
    final end = job.booking.end;
    final gap = sorted[i + 1].booking.start.difference(end);
    if (gap <= Duration.zero) continue;
    entries.add(
      gap < travelBufferLimit
          ? TimelineBuffer(end, gap.inMinutes)
          : TimelineFree(end),
    );
  }
  return entries;
}
