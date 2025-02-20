import 'package:flutter/material.dart';

class ThemeConfig {
  static Color primaryColor = const Color(0xFF2196F3);    // Blue
  static Color darkBlue = const Color(0xFF1565C0);        // Darker Blue
  static Color darkestBlue = const Color(0xFF0D47A1);     // Darkest Blue
  static Color backgroundColor = const Color(0xFF121212);  // Dark Background
  static Color surfaceColor = const Color(0xFF1E1E1E);    // Slightly lighter black
  static Color lightColor = const Color(0xFFFFFFFF);  // White
  
  static const Color appBarColor = Color(0xFF2C3639);
  static const Color expenseRed = Color(0xFFE74C3C);
  static const Color categoryColors = Color(0xFF3498DB);

  static LinearGradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, surfaceColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: darkBlue,
      background: backgroundColor,
      surface: surfaceColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,  // Changed from Colors.black to backgroundColor
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 28, // Increased icon size
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
        size: 28, // Increased icon size
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 26, // Changed font size from 24 to 26
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      elevation: 0,
      centerTitle: false, // Changed from true to false
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}