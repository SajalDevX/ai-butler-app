import 'package:flutter/material.dart';

/// Recall Butler color palette based on the blueprint
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFF8B5CF6); // Purple
  static const Color accent = Color(0xFF22D3EE); // Cyan

  // Background colors (dark theme)
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155);

  // Text colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);

  // Status colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Category colors
  static const Map<String, Color> categoryColors = {
    'Work': Color(0xFF3B82F6),
    'Personal': Color(0xFF8B5CF6),
    'Recipe': Color(0xFFF97316),
    'Shopping': Color(0xFF22C55E),
    'Travel': Color(0xFF06B6D4),
    'Health': Color(0xFFEC4899),
    'Finance': Color(0xFFEAB308),
    'Learning': Color(0xFF6366F1),
    'Other': Color(0xFF64748B),
  };

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, background],
  );
}
