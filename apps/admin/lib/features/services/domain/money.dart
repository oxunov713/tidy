/// Prices are typed in pounds and sent as whole pence. Parsing works on the
/// digits of the text, never on a double, so 19.99 cannot become 1998.
///
/// Returns null for anything that is not a non-negative amount with at most
/// two decimals ("68", "68.5", "68.50", "£68", "1,250.00").
int? poundsToPence(String input) {
  final text = input.trim().replaceFirst('£', '').replaceAll(',', '').trim();
  final match = RegExp(r'^(\d{1,7})(?:\.(\d{1,2}))?$').firstMatch(text);
  if (match == null) return null;
  final pounds = int.parse(match.group(1)!);
  final fraction = (match.group(2) ?? '').padRight(2, '0');
  return pounds * 100 + int.parse(fraction.isEmpty ? '0' : fraction);
}

/// Pence as the text of an input field: `6800` -> "68.00".
String penceToPounds(int pence) {
  final pounds = pence ~/ 100;
  final fraction = (pence % 100).toString().padLeft(2, '0');
  return '$pounds.$fraction';
}
