import 'package:flutter/material.dart';

class UndercoverTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF0F2027);      // Very deep slate blue
  static const Color accentNavy = Color(0xFF203A43);       // Navy blue
  static const Color royalBlue = Color(0xFF2C5364);        // Steel blue accent
  static const Color vibrantBlue = Color(0xFF2563EB);      // Primary Action Blue
  static const Color skyBlue = Color(0xFF38BDF8);          // Highlight cyan/sky
  static const Color backgroundDark = Color(0xFF0F172A);   // Dark slate surface

  // Role Colors
  static const Color civilianGreen = Color(0xFF10B981);
  static const Color undercoverRed = Color(0xFFEF4444);
  static const Color mrWhitePurple = Color(0xFF8B5CF6);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: vibrantBlue,
      colorScheme: const ColorScheme.dark(
        primary: vibrantBlue,
        secondary: skyBlue,
        surface: Color(0xFF1E293B),
        background: backgroundDark,
        onPrimary: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E293B),
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vibrantBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: skyBlue,
          side: const BorderSide(color: skyBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF334155),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: vibrantBlue, width: 2),
        ),
        hintStyle: const TextStyle(color: Colors.white38),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // Background Gradient decoration
  static BoxDecoration get mainBackgroundGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0F172A), // Deep Slate
          Color(0xFF1E1B4B), // Very deep royal tint
          Color(0xFF0F172A),
        ],
      ),
    );
  }

  static BoxDecoration get headerCardGradient {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1E3A8A), // Navy Blue
          Color(0xFF2563EB), // Vibrant Blue
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: vibrantBlue.withOpacity(0.3),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
