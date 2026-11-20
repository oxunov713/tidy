import 'package:flutter/painting.dart';

/// Colours only the cleaner app uses, taken from the "tidy pro" design. If
/// the client or admin app needs one, move it into `TidyColors`.
abstract final class ProColors {
  /// Light mint on the dark ink header (the "pro" wordmark, highlights).
  static const mint = Color(0xFF8FD9B6);

  /// Secondary text on ink backgrounds.
  static const onInkMuted = Color(0xFFB9C7C2);

  /// Track of the online switch while offline.
  static const switchOff = Color(0xFF3E4F49);

  /// Amber text on `TidyColors.accentSoft` (offer badge, notes).
  static const onAccentSoft = Color(0xFF7A4B00);
  static const onAccentSoftDeep = Color(0xFF5A3800);

  /// Dashed hairlines on the schedule timeline.
  static const dash = Color(0xFFD0DAD5);

  /// Text on the mint-tinted booking block of the schedule.
  static const onPrimarySoft = Color(0xFF33463F);
  static const primaryDeep = Color(0xFF075C40);
}
