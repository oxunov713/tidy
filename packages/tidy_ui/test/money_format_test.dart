import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_ui/tidy_ui.dart';

void main() {
  group('poundsToPence', () {
    test('converts whole pounds and decimals exactly', () {
      expect(TidyFormat.poundsToPence('68'), 6800);
      expect(TidyFormat.poundsToPence('68.5'), 6850);
      expect(TidyFormat.poundsToPence('68.50'), 6850);
      expect(TidyFormat.poundsToPence('0.05'), 5);
      expect(TidyFormat.poundsToPence('0'), 0);
    });

    test('does not lose pennies to floating point', () {
      // 19.99 * 100 is 1998.9999999999998 as a double.
      expect(TidyFormat.poundsToPence('19.99'), 1999);
      expect(TidyFormat.poundsToPence('1.15'), 115);
      expect(TidyFormat.poundsToPence('0.29'), 29);
    });

    test('accepts a pound sign, spaces and thousands separators', () {
      expect(TidyFormat.poundsToPence(' £68.00 '), 6800);
      expect(TidyFormat.poundsToPence('1,250.00'), 125000);
    });

    test('rejects anything that is not a price', () {
      for (final bad in ['', 'abc', '-5', '1.234', '1.', '.5', '1..2', '£']) {
        expect(TidyFormat.poundsToPence(bad), isNull, reason: bad);
      }
    });
  });

  test('penceToPounds is the inverse for input fields', () {
    expect(TidyFormat.penceToPounds(6800), '68.00');
    expect(TidyFormat.penceToPounds(1999), '19.99');
    expect(TidyFormat.penceToPounds(5), '0.05');
    expect(TidyFormat.poundsToPence(TidyFormat.penceToPounds(123456)), 123456);
  });
}
