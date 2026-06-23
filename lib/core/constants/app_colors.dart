import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette — Blue
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1565C0);

  // Accent
  static const Color accent = Color(0xFFFFB347);
  static const Color accentLight = Color(0xFFFFD08A);

  // Backgrounds
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEEF4FB);

  // Text
  static const Color textPrimary = Color(0xFF1A1F2E);
  static const Color textSecondary = Color(0xFF6B7A99);
  static const Color textHint = Color(0xFFB0BEC5);

  // Status
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Nav
  static const Color navBackground = Color(0xFFFFFFFF);
  static const Color navSelected = Color(0xFF2196F3);
  static const Color navUnselected = Color(0xFFB0BEC5);

  // Divider & shadow
  static const Color divider = Color(0xFFE8EDF5);
  static const Color shadow = Color(0x0F2196F3);

  // Card gradients — Blue gradient (matching your design)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFFB347), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}