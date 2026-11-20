import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tidy_core/tidy_core.dart';

void main() {
  setUpAll(initializeDateFormatting);
  tearDown(BusinessTime.reset);

  group('BusinessTime', () {
    test('defaults to Europe/London', () {
      expect(BusinessTime.zoneName, 'Europe/London');
    });

    test('a winter instant is shown as UTC', () {
      final noon = DateTime.utc(2026, 12, 3, 12);
      expect(TidyDates.clock(noon), '12:00');
    });

    test('a summer instant is shown one hour ahead (BST)', () {
      final noon = DateTime.utc(2026, 7, 1, 12);
      expect(TidyDates.clock(noon), '13:00');
    });

    test('the device zone makes no difference', () {
      // Same instant, built as UTC and as a "local" value: both give London.
      final utc = DateTime.utc(2026, 7, 1, 8, 30);
      final local = utc.toLocal();
      expect(TidyDates.clock(utc), '09:30');
      expect(TidyDates.clock(local), '09:30');
    });

    test('BUSINESS_TZ can point somewhere else', () {
      BusinessTime.useZone('America/New_York');
      expect(TidyDates.clock(DateTime.utc(2026, 12, 3, 12)), '07:00');
      expect(BusinessTime.zoneName, 'America/New_York');
    });

    test('the day changes at local midnight, not at UTC midnight', () {
      // 23:30 UTC in July is 00:30 the next day in London.
      final late = DateTime.utc(2026, 7, 1, 23, 30);
      expect(BusinessTime.dayOf(late), DateTime(2026, 7, 2));
      expect(
        BusinessTime.isSameDay(late, DateTime.utc(2026, 7, 2, 10)),
        isTrue,
      );
      expect(
        BusinessTime.isSameDay(late, DateTime.utc(2026, 7, 1, 10)),
        isFalse,
      );
      expect(BusinessTime.isOnDay(late, DateTime(2026, 7, 2)), isTrue);
    });

    test('instantAt is the inverse across a clock change', () {
      // Clocks go forward on 29 March 2026 at 01:00 UTC.
      final before = BusinessTime.instantAt(DateTime(2026, 3, 28), hour: 9);
      final after = BusinessTime.instantAt(DateTime(2026, 3, 30), hour: 9);
      expect(before, DateTime.utc(2026, 3, 28, 9));
      expect(after, DateTime.utc(2026, 3, 30, 8));
      expect(BusinessTime.minuteOfDay(after), 9 * 60);
    });

    test('parseDay reads a calendar date', () {
      expect(BusinessTime.parseDay('2026-12-03'), DateTime(2026, 12, 3));
    });
  });

  group('TidyDates', () {
    final start = DateTime.utc(2026, 7, 1, 8);
    final end = DateTime.utc(2026, 7, 1, 11);

    test('time range and day labels use the business zone', () {
      expect(TidyDates.timeRange(start, end), '09:00 – 12:00');
      expect(TidyDates.dayShort(start, 'en'), 'Wed 1 Jul');
      expect(TidyDates.dayLong(start, 'en'), 'Wednesday, 1 July');
      expect(TidyDates.monthYear(start, 'en'), 'July 2026');
      expect(TidyDates.weekdayUpper(start, 'en'), 'WED');
    });

    test('calendar days are printed as they are', () {
      final day = DateTime(2026, 12, 3);
      expect(TidyDates.dayShortOf(day, 'en'), 'Thu 3 Dec');
      expect(TidyDates.isoDay(day), '2026-12-03');
      expect(
        TidyDates.dayRangeOf(day, DateTime(2026, 12, 9), 'en'),
        '3 – 9 Dec',
      );
      expect(
        TidyDates.dayRangeOf(
          DateTime(2026, 11, 30),
          DateTime(2026, 12, 6),
          'en',
        ),
        '30 Nov – 6 Dec',
      );
    });
  });
}
