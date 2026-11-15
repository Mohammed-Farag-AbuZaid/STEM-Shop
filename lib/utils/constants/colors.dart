import 'package:flutter/material.dart';

/// TF Unions Sovereign Editorial Palette (`stem_shop`)
class TColors {
  TColors._();

  // Brand Core
  static const Color primary = Color(0xFF002583);       // TF Royal Cobalt
  static const Color secondry = Color(0xFFD99B00);      // TF Academic Gold
  static const Color accent = Color(0xFF002583);        // Primary Cobalt Accent

  // Typography & Ink
  static const Color textprimary = Color(0xFF11141C);   // Deep Ink
  static const Color textsecondry = Color(0xFF525866);  // Readable Slate Copy
  static const Color textwhite = Colors.white;

  // Background Canvas Colors
  static const Color light = Color(0xFFF8F9FB);         // Elevated Canvas
  static const Color dark = Color(0xFF0B1120);
  static const Color primaryBackground = Color(0xFFF8F9FB);

  // Container & Card Surfaces
  static const Color lightContainer = Color(0xFFFFFFFF); // Pure White Card Surface
  static const Color surfaceAlt = Color(0xFFF3F5F8);
  static Color darkContainer = const Color(0xFF111827);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF002583);
  static const Color buttonSecondary = Color(0xFFD99B00);
  static const Color buttonDisabled = Color(0xFFC5CAD6);

  // Structural Border Colors
  static const Color borderPrimary = Color(0xFFE2E5EC);
  static const Color borderSecondary = Color(0xFFC5CAD6);

  // Semantics
  static const Color error = Color(0xFFB91C1C);
  static const Color success = Color(0xFF15803D);
  static const Color warning = Color(0xFFB45309);
  static const Color info = Color(0xFF002583);

  // Neutral Palette
  static const Color black = Color(0xFF11141C);
  static const Color darkerGrey = Color(0xFF2E3138);
  static const Color darkGrey = Color(0xFF525866);
  static const Color grey = Color(0xFF7A8191);
  static const Color softgrey = Color(0xFFF3F5F8);
  static const Color lightgrey = Color(0xFFF8F9FB);
  static const Color white = Color(0xFFFFFFFF);

  // Official Royal Surface Gradient
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF002583),
      Color(0xFF001B61),
    ],
  );
}
