import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryRed = Color(0xFFB71C1C); // Red 900
  static const Color primaryRedLight = Color(0xFFD32F2F); // Red 700
  static const Color primaryRedDark = Color(0xFF8B0000); // Dark Red
  
  // Background Colors
  static const Color backgroundDark = Color(0xFF000000); // Black
  static const Color backgroundLight = Color(0xFFFFFFFF); // White
  
  // Surface Colors
  static const Color surfaceDark = Color(0xFF1A1A1A); // Dark Gray
  static const Color surfaceLight = Color(0xFFF5F5F5); // Light Gray
  
  // Card Colors
  static const Color cardDark = Color(0xFF1E1E1E); // Card Dark
  static const Color cardLight = Color(0xFFFFFFFF); // Card Light
  
  // Input Colors
  static const Color inputDark = Color(0xFF2A2A2A); // Input Dark
  static const Color inputLight = Color(0xFFF5F5F5); // Input Light
  
  // Text Colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White
  static const Color textSecondaryDark = Color(0xFF9E9E9E); // Gray 400
  static const Color textPrimaryLight = Color(0xFF000000); // Black
  static const Color textSecondaryLight = Color(0xFF757575); // Gray 600
  
  // Border Colors
  static const Color borderDark = Color(0xFF424242); // Gray 800
  static const Color borderLight = Color(0xFFE0E0E0); // Gray 300
  
  // Gradient Colors
  static const List<Color> appBarGradient = [
    primaryRed,
    backgroundDark,
  ];
  
  static const List<Color> cardGradient = [
    Colors.transparent,
    Colors.black54,
  ];
  
  // Shadow Colors
  static Color shadowRed = primaryRed.withValues(alpha: 0.3);
  
  // Get colors based on theme
  static Color getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? backgroundDark : backgroundLight;
  }
  
  static Color getSurfaceColor(bool isDarkMode) {
    return isDarkMode ? surfaceDark : surfaceLight;
  }
  
  static Color getTextColor(bool isDarkMode) {
    return isDarkMode ? textPrimaryDark : textPrimaryLight;
  }
  
  static Color getSecondaryTextColor(bool isDarkMode) {
    return isDarkMode ? textSecondaryDark : textSecondaryLight;
  }
  
  static Color getBorderColor(bool isDarkMode) {
    return isDarkMode ? borderDark : borderLight;
  }
  
  static Color getCardColor(bool isDarkMode) {
    return isDarkMode ? cardDark : cardLight;
  }
  
  static Color getInputColor(bool isDarkMode) {
    return isDarkMode ? inputDark : inputLight;
  }
}