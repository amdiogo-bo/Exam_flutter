import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.aurora2,
      secondary: AppColors.aurora1,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkText,
      error: AppColors.aurora5,
    ),
    textTheme: _text(AppColors.darkText),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.darkText,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.darkText,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.aurora1,
        foregroundColor: AppColors.darkBg,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 0,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.aurora1,
      foregroundColor: AppColors.darkBg,
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: Color(0xFF00B4D8),
      surface: AppColors.lightCard,
      onSurface: AppColors.lightText,
    ),
    textTheme: _text(AppColors.lightText),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.lightText,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.lightText,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
    ),
  );

  static TextTheme _text(Color c) => TextTheme(
    displayLarge:  GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.w800, color: c),
    displayMedium: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w700, color: c),
    titleLarge:    GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: c),
    titleMedium:   GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w600, color: c),
    titleSmall:    GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: c),
    bodyLarge:     GoogleFonts.inter(fontSize: 16, color: c),
    bodyMedium:    GoogleFonts.inter(fontSize: 14, color: c),
    bodySmall:     GoogleFonts.inter(fontSize: 12, color: c.withValues(alpha: 0.7)),
    labelLarge:    GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: c),
  );
}
