import 'package:flutter/material.dart';

/// Curated color palette for the meditation app.
/// Uses deep, calming tones with vibrant accents.
class AppColors {
  AppColors._();

  // ── Core Palette ──
  static const Color background = Color(0xFF0A0E21);
  static const Color surface = Color(0xFF141832);
  static const Color surfaceLight = Color(0xFF1C2144);
  static const Color surfaceCard = Color(0xFF1A1F3D);

  // ── Accent Colors ──
  static const Color primary = Color(0xFF7C5CFC);
  static const Color primaryLight = Color(0xFF9F85FF);
  static const Color secondary = Color(0xFF38B6FF);
  static const Color accent = Color(0xFFFF6B9D);

  // ── Text Colors ──
  static const Color textPrimary = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFF8E92B5);
  static const Color textMuted = Color(0xFF5A5F82);

  // ── Mood Colors ──
  static const Color moodCalm = Color(0xFF4FC3F7);
  static const Color moodGrounded = Color(0xFF66BB6A);
  static const Color moodEnergized = Color(0xFFFFCA28);
  static const Color moodSleepy = Color(0xFFAB47BC);

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C5CFC), Color(0xFF38B6FF)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF141832), Color(0xFF0A0E21)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C2144), Color(0xFF141832)],
  );

  /// Returns the color associated with a mood.
  static Color moodColor(int moodIndex) {
    switch (moodIndex) {
      case 0:
        return moodCalm;
      case 1:
        return moodGrounded;
      case 2:
        return moodEnergized;
      case 3:
        return moodSleepy;
      default:
        return primary;
    }
  }
}
