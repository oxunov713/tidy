import 'package:intl/intl.dart';
import 'package:tidy_core/src/time/business_time.dart';

/// Date and time text for the screens.
///
/// Functions taking an `instant` convert it to the business zone first, see
/// [BusinessTime]. Functions taking a `day` expect a plain calendar date
/// (`DateTime(y, m, d)`) and print it as it is.
abstract final class TidyDates {
  /// `10:00`.
  static String clock(DateTime instant, [String? locale]) =>
      DateFormat.Hm(locale).format(BusinessTime.zoned(instant));

  /// `10:00 – 13:00`.
  static String timeRange(DateTime start, DateTime end, [String? locale]) =>
      '${clock(start, locale)} – ${clock(end, locale)}';

  /// `Wed 3 Dec`.
  static String dayShort(DateTime instant, [String? locale]) =>
      DateFormat('EEE d MMM', locale).format(BusinessTime.zoned(instant));

  /// `Wednesday, 3 December`.
  static String dayLong(DateTime instant, [String? locale]) =>
      DateFormat('EEEE, d MMMM', locale).format(BusinessTime.zoned(instant));

  /// `December 2026`.
  static String monthYear(DateTime instant, [String? locale]) =>
      DateFormat('MMMM y', locale).format(BusinessTime.zoned(instant));

  /// `WED`.
  static String weekdayUpper(DateTime instant, [String? locale]) =>
      DateFormat('E', locale).format(BusinessTime.zoned(instant)).toUpperCase();

  /// `Dec 3, 10:00` (the order depends on the locale).
  static String dateTime(DateTime instant, [String? locale]) =>
      DateFormat.MMMd(locale).add_Hm().format(BusinessTime.zoned(instant));

  /// `Wednesday, December 3`.
  static String dayFull(DateTime instant, [String? locale]) =>
      DateFormat.MMMMEEEEd(locale).format(BusinessTime.zoned(instant));

  // -- Calendar days ----------------------------------------------------------

  /// `Wed 3 Dec`.
  static String dayShortOf(DateTime day, [String? locale]) =>
      DateFormat('EEE d MMM', locale).format(day);

  /// `Wednesday, 3 Dec`.
  static String dayLongOf(DateTime day, [String? locale]) =>
      DateFormat('EEEE, d MMM', locale).format(day);

  /// `T`, for chart labels.
  static String weekdayNarrowOf(DateTime day, [String? locale]) =>
      DateFormat('EEEEE', locale).format(day);

  /// `Thu`.
  static String weekdayShortOf(DateTime day, [String? locale]) =>
      DateFormat('EEE', locale).format(day);

  /// `1 – 7 Dec`.
  static String dayRangeOf(DateTime from, DateTime to, [String? locale]) {
    final start = from.month == to.month
        ? DateFormat('d', locale).format(from)
        : DateFormat('d MMM', locale).format(from);
    return '$start – ${DateFormat('d MMM', locale).format(to)}';
  }

  /// `2026-12-03`, the format of `EarningsDay.date` and the `date` query.
  static String isoDay(DateTime day) => DateFormat('yyyy-MM-dd').format(day);
}
