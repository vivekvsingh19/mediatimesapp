import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFD32F2F), // Restrained red accent
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.merriweather(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.merriweather(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: GoogleFonts.merriweather(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD32F2F),
        secondary: Color(0xFFD32F2F),
        surface: Colors.white,
      ),
      dividerColor: Colors.grey[300],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFE53935),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.merriweather(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.merriweather(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: GoogleFonts.merriweather(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE53935),
        secondary: Color(0xFFE53935),
        surface: Color(0xFF1E1E1E),
      ),
      dividerColor: Colors.grey[800],
    );
  }
}
