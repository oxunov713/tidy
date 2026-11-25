import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_client/features/auth/presentation/country.dart';

void main() {
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
