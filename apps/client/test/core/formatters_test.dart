import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/features/auth/presentation/country.dart';

void main() {
  test('hours are shown without a trailing .0', () {
    expect(hoursValue(120), '2');
    expect(hoursValue(150), '2.5');
  });

  test('hour ranges widen by half again', () {
    expect(hoursRange(120), '2–3');
    expect(hoursRange(240), '4–6');
    expect(hoursRange(300), '5–8');
  });

  group('phone numbers', () {
    test('drops the trunk zero and spaces', () {
      expect(toE164(Country.unitedKingdom, '07700 900123'), '+447700900123');
      expect(toE164(Country.unitedKingdom, '7700 900123'), '+447700900123');
    });

    test('rejects numbers that are too short', () {
      expect(isPlausiblePhone('+4477'), isFalse);
      expect(isPlausiblePhone('+447700900123'), isTrue);
    });
  });
}
