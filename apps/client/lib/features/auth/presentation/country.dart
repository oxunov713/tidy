/// A dial code the phone field can start with.
class Country {
  const Country(this.flag, this.name, this.dialCode);

  final String flag;
  final String name;
  final String dialCode;

  static const Country unitedKingdom = Country('🇬🇧', 'United Kingdom', '+44');

  static const List<Country> all = [
    unitedKingdom,
    Country('🇮🇪', 'Ireland', '+353'),
    Country('🇺🇸', 'United States', '+1'),
    Country('🇺🇿', 'Uzbekistan', '+998'),
    Country('🇷🇺', 'Russia', '+7'),
    Country('🇩🇪', 'Germany', '+49'),
    Country('🇫🇷', 'France', '+33'),
  ];
}

/// Builds the E.164 number the API expects: `+44` and `07700 900123` become
/// `+447700900123`. A leading trunk zero is dropped.
String toE164(Country country, String input) {
  final digits = input.replaceAll(RegExp(r'\D'), '');
  final national = digits.startsWith('0') ? digits.substring(1) : digits;
  return '${country.dialCode}$national';
}

/// Loose check: E.164 allows up to 15 digits, and anything under 7 is not a
/// phone number anywhere we sell to.
bool isPlausiblePhone(String e164) {
  final digits = e164.replaceAll(RegExp(r'\D'), '');
  return digits.length >= 9 && digits.length <= 15;
}
