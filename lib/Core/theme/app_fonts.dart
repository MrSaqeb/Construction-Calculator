import 'package:flutter/material.dart';

class AppTheme {
  // 🟦 Font Family
  static const String _fontFamily = 'Poppins';

  // 🔵 App Colors
  static const Color primaryColor = Color(0xFFFF9C00);
  static const Color secondaryColor = Color(0xFFFF9C00);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Colors.black87;
  static const Color errorColor = Colors.redAccent;

  // 🔲 Border Radius
  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(12),
  );

  // 🌫️ Shadows
  static List<BoxShadow> boxShadow = [
    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
  ];

  // 📏 Spacing
  static const double spacingSmall = 8;
  static const double spacingMedium = 16;
  static const double spacingLarge = 24;

  // 📝 Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: textColor,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: textColor,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: textColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: textColor,
  );

  // 🎨 Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    textTheme: const TextTheme(
      displayLarge: headingLarge,
      displayMedium: headingMedium,
      bodyLarge: bodyRegular,
      bodyMedium: bodyRegular,
      bodySmall: caption,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  );

  // 🌙 Dark Theme (optional)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: primaryColor,
    textTheme: const TextTheme(
      displayLarge: headingLarge,
      displayMedium: headingMedium,
      bodyLarge: bodyRegular,
      bodyMedium: bodyRegular,
      bodySmall: caption,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
  );
}
