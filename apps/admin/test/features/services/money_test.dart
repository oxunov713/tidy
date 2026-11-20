import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_admin/features/services/domain/money.dart';

void main() {
  group('poundsToPence', () {
    test('converts whole pounds and decimals exactly', () {
      expect(poundsToPence('68'), 6800);
      expect(poundsToPence('68.5'), 6850);
      expect(poundsToPence('68.50'), 6850);
      expect(poundsToPence('0.05'), 5);
      expect(poundsToPence('0'), 0);
    });

    test('does not lose pennies to floating point', () {
      // 19.99 * 100 is 1998.9999999999998 as a double.
      expect(poundsToPence('19.99'), 1999);
      expect(poundsToPence('1.15'), 115);
      expect(poundsToPence('0.29'), 29);
    });

    test('accepts a pound sign, spaces and thousands separators', () {
      expect(poundsToPence(' £68.00 '), 6800);
      expect(poundsToPence('1,250.00'), 125000);
    });

    test('rejects anything that is not a price', () {
      for (final bad in ['', 'abc', '-5', '1.234', '1.', '.5', '1..2', '£']) {
        expect(poundsToPence(bad), isNull, reason: bad);
      }
    });
  });

  test('penceToPounds is the inverse for input fields', () {
    expect(penceToPounds(6800), '68.00');
    expect(penceToPounds(1999), '19.99');
    expect(penceToPounds(5), '0.05');
    expect(poundsToPence(penceToPounds(123456)), 123456);
  });
}
