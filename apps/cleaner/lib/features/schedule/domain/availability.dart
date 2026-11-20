import 'package:flutter/foundation.dart';
import 'package:tidy_core/tidy_core.dart';

/// Working hours as the screen edits them: the same start and end on every
/// working day. Times are minutes after midnight.
@immutable
class AvailabilityDraft {
  const AvailabilityDraft({
    required this.weekdays,
    required this.fromMinutes,
    required this.toMinutes,
  });

  factory AvailabilityDraft.fromWindows(List<AvailabilityWindow> windows) {
    if (windows.isEmpty) {
      return const AvailabilityDraft(
        weekdays: {},
        fromMinutes: 8 * 60,
        toMinutes: 17 * 60,
      );
    }
    // The API allows different hours per day; the screen edits one range, so
    // the first window sets it.
    final first = windows.first;
    return AvailabilityDraft(
      weekdays: {for (final w in windows) w.weekday},
      fromMinutes: parseMinutes(first.startTime),
      toMinutes: parseMinutes(first.endTime),
    );
  }

  /// Monday to Friday, 08:00 to 17:00: what a new cleaner starts from.
  static const standard = AvailabilityDraft(
    weekdays: {0, 1, 2, 3, 4},
    fromMinutes: 8 * 60,
    toMinutes: 17 * 60,
  );

  /// 0 = Monday, as in the API.
  final Set<int> weekdays;
  final int fromMinutes;
  final int toMinutes;

  bool get isValid => toMinutes > fromMinutes;

  List<AvailabilityWindow> toWindows() => [
    for (final day in ([...weekdays]..sort()))
      AvailabilityWindow(
        weekday: day,
        startTime: formatMinutes(fromMinutes),
        endTime: formatMinutes(toMinutes),
      ),
  ];

  AvailabilityDraft copyWith({
    Set<int>? weekdays,
    int? fromMinutes,
    int? toMinutes,
  }) => AvailabilityDraft(
    weekdays: weekdays ?? this.weekdays,
    fromMinutes: fromMinutes ?? this.fromMinutes,
    toMinutes: toMinutes ?? this.toMinutes,
  );

  @override
  bool operator ==(Object other) =>
      other is AvailabilityDraft &&
      other.fromMinutes == fromMinutes &&
      other.toMinutes == toMinutes &&
      other.weekdays.length == weekdays.length &&
      other.weekdays.containsAll(weekdays);

  @override
  int get hashCode => Object.hash(fromMinutes, toMinutes, weekdays.length);

  /// "08:30" -> 510
  static int parseMinutes(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  /// 510 -> "08:30"
  static String formatMinutes(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
      '${(minutes % 60).toString().padLeft(2, '0')}';
}

abstract interface class AvailabilityRepository {
  Future<List<AvailabilityWindow>> load();

  Future<List<AvailabilityWindow>> save(List<AvailabilityWindow> windows);
}
