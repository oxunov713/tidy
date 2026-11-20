import 'package:flutter/painting.dart';

/// Corner radii: cards 20, controls 14, pills fully round.
abstract final class TidyRadii {
  static const double card = 20;
  static const double control = 14;
  static const double pill = 999;

  static const cardBorder = BorderRadius.all(Radius.circular(card));
  static const controlBorder = BorderRadius.all(Radius.circular(control));
  static const pillBorder = BorderRadius.all(Radius.circular(pill));
}
