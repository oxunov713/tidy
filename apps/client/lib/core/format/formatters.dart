import 'package:intl/intl.dart';

/// Pure formatting helpers. They take the locale as an argument so they can be
/// used (and tested) without a widget tree.

/// `150` -> `2.5`, `120` -> `2`.
String hoursValue(int minutes) {
  final hours = minutes / 60;
  final text = hours.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}

/// The "2–3" in "2–3 h". The visit can run long, so the upper bound is half
/// as much again, rounded up.
String hoursRange(int minutes) {
  final low = (minutes / 60).floor().clamp(1, 99);
  final high = (minutes / 60 * 1.5).ceil();
  return high > low ? '$low–$high' : '$low';
}

/// `10:00`, in the device's time zone.
String formatClock(DateTime time) => DateFormat.Hm().format(time.toLocal());

/// `Wed 10 Dec`.
String formatDayShort(DateTime time, String locale) =>
    DateFormat('EEE d MMM', locale).format(time.toLocal());

/// `Wednesday, 3 December`.
String formatDayLong(DateTime time, String locale) =>
    DateFormat('EEEE, d MMMM', locale).format(time.toLocal());

/// `December 2026`.
String formatMonthYear(DateTime time, String locale) =>
    DateFormat('MMMM y', locale).format(time.toLocal());

/// `WED`.
String formatWeekdayShort(DateTime time, String locale) =>
    DateFormat('E', locale).format(time.toLocal()).toUpperCase();

bool isSameDay(DateTime a, DateTime b) {
  final x = a.toLocal();
  final y = b.toLocal();
  return x.year == y.year && x.month == y.month && x.day == y.day;
}
