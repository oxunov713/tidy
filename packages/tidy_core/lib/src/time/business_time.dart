import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// The zone the business runs in.
///
/// The server speaks UTC but every visit happens in one place, so the apps
/// show and compare times in that place's zone, not in the zone of the phone:
/// a client travelling abroad still sees "10:00" for a 10:00 London visit.
///
/// The zone is `Europe/London` unless the app was built with
/// `--dart-define=BUSINESS_TZ=<IANA name>`.
///
/// Two kinds of values appear here:
///
/// * an *instant* is a normal [DateTime] from the API (UTC);
/// * a *day* is a plain `DateTime(year, month, day)` that only carries a
///   calendar date, the way date pickers and day strips use it.
abstract final class BusinessTime {
  static const _configured = String.fromEnvironment(
    'BUSINESS_TZ',
    defaultValue: 'Europe/London',
  );

  static String _name = _configured;
  static tz.Location? _location;
  static var _loaded = false;

  /// Name of the zone in use, for example `Europe/London`.
  static String get zoneName => _name;

  static tz.Location get location {
    if (!_loaded) {
      tzdata.initializeTimeZones();
      _loaded = true;
    }
    return _location ??= tz.getLocation(_name);
  }

  /// Tests only: pretend the business is in another zone. Call [reset] after.
  static void useZone(String name) {
    _name = name;
    _location = null;
  }

  /// Tests only: back to the configured zone.
  static void reset() => useZone(_configured);

  /// [instant] as wall-clock time in the business zone. The result's `hour`,
  /// `day`, `weekday` and so on are the ones to show.
  static tz.TZDateTime zoned(DateTime instant) =>
      tz.TZDateTime.from(instant, location);

  /// The calendar day [instant] falls on in the business zone.
  static DateTime dayOf(DateTime instant) {
    final z = zoned(instant);
    return DateTime(z.year, z.month, z.day);
  }

  /// Today's date in the business zone, given the current instant.
  static DateTime today(DateTime now) => dayOf(now);

  /// Whether two instants are on the same business day.
  static bool isSameDay(DateTime a, DateTime b) => dayOf(a) == dayOf(b);

  /// Whether the instant [value] is on the calendar [day].
  static bool isOnDay(DateTime value, DateTime day) =>
      dayOf(value) == DateTime(day.year, day.month, day.day);

  /// The instant (UTC) at which the business clock shows [hour]:[minute] on
  /// the calendar [day].
  static DateTime instantAt(DateTime day, {int hour = 0, int minute = 0}) =>
      tz.TZDateTime(
        location,
        day.year,
        day.month,
        day.day,
        hour,
        minute,
      ).toUtc();

  /// Minutes since midnight on the business clock.
  static int minuteOfDay(DateTime instant) {
    final z = zoned(instant);
    return z.hour * 60 + z.minute;
  }

  /// `2026-12-03` as a calendar day.
  static DateTime parseDay(String value) {
    final parts = value.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
