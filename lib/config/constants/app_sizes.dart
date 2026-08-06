import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  // Padding / Margins estándar
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Border Radius estándar
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusPill = 50.0;

// --- Espaciadores Horizontales (Gap Helpers) ---
  static const SizedBox gapH4 = SizedBox(width: xs);
  static const SizedBox gapH8 = SizedBox(width: sm);
  static const SizedBox gapH12 = SizedBox(width: 12.0);
  static const SizedBox gapH16 = SizedBox(width: md);
  static const SizedBox gapH20 = SizedBox(width: 20.0);
  static const SizedBox gapH24 = SizedBox(width: lg);
  static const SizedBox gapH32 = SizedBox(width: xl);

  // --- Espaciadores Verticales (Gap Helpers) ---
  static const SizedBox gapV4 = SizedBox(height: xs);
  static const SizedBox gapV8 = SizedBox(height: sm);
  static const SizedBox gapV12 = SizedBox(height: 12.0);
  static const SizedBox gapV16 = SizedBox(height: md);
  static const SizedBox gapV20 = SizedBox(height: 20.0);
  static const SizedBox gapV24 = SizedBox(height: lg);
  static const SizedBox gapV30 = SizedBox(height: 30.0);
  static const SizedBox gapV32 = SizedBox(height: xl);
}