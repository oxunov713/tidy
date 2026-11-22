import 'package:tidy_ui/src/widgets/price_text.dart';

/// Money and duration text. Everything is integer maths: pence never go
/// through a double, so 19.99 cannot become 1998.
abstract final class TidyFormat {
  /// `6800` -> "£68.00".
  static String pounds(int pence, {bool signed = false}) =>
      PriceText.format(pence, signed: signed);

  /// Whole pounds for tight spots, "£96". Pence are dropped by rounding down.
  static String poundsShort(int pence) =>
      PriceText.format(pence).replaceFirst(RegExp(r'\.\d\d$'), '');

  /// "£84" for whole pounds, "£84.50" otherwise.
  static String payout(int pence) =>
      pence % 100 == 0 ? poundsShort(pence) : pounds(pence);

  /// Minutes as hours with one decimal, dropping ".0": `150` -> "2.5",
  /// `120` -> "2".
  static String hoursValue(int minutes) {
    final tenths = (minutes * 10 / 60).round();
    final whole = tenths ~/ 10;
    final fraction = tenths % 10;
    return fraction == 0 ? '$whole' : '$whole.$fraction';
  }

  /// Minutes as hours with a fixed decimal: `1290` -> "21.5", `120` -> "2.0".
  static String hours(int minutes) {
    final tenths = (minutes * 10 / 60).round();
    return '${tenths ~/ 10}.${tenths % 10}';
  }

  /// The "2–3" in "2–3 h". A visit can run long, so the upper bound is half
  /// as much again, rounded up.
  static String hoursRange(int minutes) {
    final low = (minutes / 60).floor().clamp(1, 99);
    final high = (minutes / 60 * 1.5).ceil();
    return high > low ? '$low–$high' : '$low';
  }

  /// Pence per hour from a total in pence and the minutes worked.
  static int perHour(int pence, int minutes) =>
      minutes <= 0 ? 0 : (pence * 60 / minutes).round();

  /// "2:05" for a countdown.
  static String countdown(Duration remaining) {
    final secs = remaining.inSeconds.clamp(0, 359999);
    final m = secs ~/ 60;
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Parses an amount typed in pounds into pence, working on the digits only.
  /// Returns null for anything that is not a non-negative amount with at most
  /// two decimals ("68", "68.5", "68.50", "£68", "1,250.00").
  static int? poundsToPence(String input) {
    final text = input.trim().replaceFirst('£', '').replaceAll(',', '').trim();
    final match = RegExp(r'^(\d{1,7})(?:\.(\d{1,2}))?$').firstMatch(text);
    if (match == null) return null;
    final pounds = int.parse(match.group(1)!);
    final fraction = (match.group(2) ?? '').padRight(2, '0');
    return pounds * 100 + int.parse(fraction.isEmpty ? '0' : fraction);
  }

  /// Pence as the text of an input field: `6800` -> "68.00".
  static String penceToPounds(int pence) {
    final pounds = pence ~/ 100;
    final fraction = (pence % 100).toString().padLeft(2, '0');
    return '$pounds.$fraction';
  }
}
