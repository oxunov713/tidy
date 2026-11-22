import 'package:flutter/painting.dart';

/// Colour tokens from the Tidy design canvas.
abstract final class TidyColors {
  static const primary = Color(0xFF0A7A55);
  static const primarySoft = Color(0xFFE3F3EC);
  static const ink = Color(0xFF10201B);
  static const muted = Color(0xFF5B6B66);
  static const surface = Color(0xFFF4F7F5);
  static const line = Color(0xFFE3E9E6);
  static const accent = Color(0xFFF5A524);
  static const white = Color(0xFFFFFFFF);

  /// Not in the canvas palette; used for destructive actions and errors.
  static const danger = Color(0xFFC8402F);
  static const dangerSoft = Color(0xFFFBE9E6);
  static const accentSoft = Color(0xFFFDF0D8);
  static const infoSoft = Color(0xFFE4EEF9);
  static const info = Color(0xFF2B6CB0);

  // -- Tones the cleaner app ("tidy pro") needs on its dark header and
  //    timeline. They live here so any app can use them.

  /// Light mint on the dark ink header (the "pro" wordmark, highlights).
  static const mint = Color(0xFF8FD9B6);

  /// Secondary text on ink backgrounds.
  static const onInkMuted = Color(0xFFB9C7C2);

  /// Track of a switch that is off, on an ink background.
  static const switchOff = Color(0xFF3E4F49);

  /// Amber text on [accentSoft] (offer badge, notes).
  static const onAccentSoft = Color(0xFF7A4B00);
  static const onAccentSoftDeep = Color(0xFF5A3800);

  /// Dashed hairlines on a timeline.
  static const dash = Color(0xFFD0DAD5);

  /// Text on a [primarySoft] block.
  static const onPrimarySoft = Color(0xFF33463F);
  static const primaryDeep = Color(0xFF075C40);
}
