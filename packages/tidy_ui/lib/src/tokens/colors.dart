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
}
