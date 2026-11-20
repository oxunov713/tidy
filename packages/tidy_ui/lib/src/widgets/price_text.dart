import 'package:material_ui/material_ui.dart';

/// Shows an amount in pence as pounds, e.g. `6800` -> "£68.00".
class PriceText extends StatelessWidget {
  const PriceText(this.pence, {this.style, this.signed = false, super.key});

  final int pence;
  final TextStyle? style;

  /// Prefix positive amounts with "+", useful for tips and adjustments.
  final bool signed;

  /// Integer maths only: money never goes through a double.
  static String format(int pence, {bool signed = false}) {
    final negative = pence < 0;
    final abs = pence.abs();
    final pounds = (abs ~/ 100).toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    final fraction = (abs % 100).toString().padLeft(2, '0');
    final sign = negative ? '-' : (signed && pence > 0 ? '+' : '');
    return '$sign£$pounds.$fraction';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      format(pence, signed: signed),
      style: style,
      semanticsLabel: format(pence, signed: signed),
    );
  }
}
