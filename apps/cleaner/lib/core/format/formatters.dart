import 'package:intl/intl.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Date and money helpers. Times from the API are UTC; the screens always show
/// the phone's local time.
abstract final class Fmt {
  static String time(DateTime utc, [String? locale]) =>
      DateFormat.Hm(locale).format(utc.toLocal());

  static String timeRange(DateTime start, DateTime end, [String? locale]) =>
      '${time(start, locale)} – ${time(end, locale)}';

  /// "T" (narrow weekday, for chart labels).
  static String weekdayNarrow(DateTime local, [String? locale]) =>
      DateFormat('EEEEE', locale).format(local);

  /// "Thu"
  static String weekdayShort(DateTime local, [String? locale]) =>
      DateFormat('EEE', locale).format(local);

  /// "Thu 4 Dec"
  static String shortDate(DateTime utc, [String? locale]) =>
      DateFormat('EEE d MMM', locale).format(utc.toLocal());

  /// "Wednesday, 3 Dec"
  static String longDate(DateTime local, [String? locale]) =>
      DateFormat('EEEE, d MMM', locale).format(local);

  /// "1 – 7 Dec"
  static String dayRange(DateTime from, DateTime to, [String? locale]) {
    final sameMonth = from.month == to.month;
    final start = sameMonth
        ? DateFormat('d', locale).format(from)
        : DateFormat('d MMM', locale).format(from);
    return '$start – ${DateFormat('d MMM', locale).format(to)}';
  }

  /// `yyyy-MM-dd`, the format of `EarningsDay.date`.
  static String isoDay(DateTime local) =>
      DateFormat('yyyy-MM-dd').format(local);

  static DateTime dayOf(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Whole pounds for tight spots, "£96". Pence are dropped by rounding down.
  static String poundsShort(int pence) =>
      PriceText.format(pence).replaceFirst(RegExp(r'\.\d\d$'), '');

  /// "£84" for whole pounds, "£84.50" otherwise.
  static String payout(int pence) =>
      pence % 100 == 0 ? poundsShort(pence) : pounds(pence);

  /// "£22.60".
  static String pounds(int pence) => PriceText.format(pence);

  /// Minutes as hours with one decimal: 1290 -> "21.5".
  static String hours(int minutes) {
    final tenths = (minutes * 10 / 60).round();
    return '${tenths ~/ 10}.${tenths % 10}';
  }

  /// Pence per hour from a total in pence and minutes worked. Integer maths.
  static int perHour(int pence, int minutes) =>
      minutes <= 0 ? 0 : (pence * 60 / minutes).round();

  /// "2:05" for a countdown.
  static String countdown(Duration remaining) {
    final secs = remaining.inSeconds.clamp(0, 359999);
    final m = secs ~/ 60;
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
