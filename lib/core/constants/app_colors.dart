import 'package:flutter/material.dart';

/// Palette Aurora Cosmos — Design glassmorphism unique
class AppColors {
  AppColors._();

  // ─── DARK / COSMOS ───────────────────────────────────────
  static const Color darkBg      = Color(0xFF050B1A);
  static const Color darkBg2     = Color(0xFF0D1F3C);
  static const Color darkCard    = Color(0xFF0F1E35);
  static const Color darkGlass   = Color(0x1AFFFFFF);
  static const Color darkBorder  = Color(0x33FFFFFF);
  static const Color darkText    = Color(0xFFF0F8FF);
  static const Color darkTextSub = Color(0xFF8BA7C7);

  // Neon aurora colors
  static const Color aurora1 = Color(0xFF00F5A0); // menthe vif
  static const Color aurora2 = Color(0xFF00D9F5); // cyan électrique
  static const Color aurora3 = Color(0xFFB44FFF); // violet cosmos
  static const Color aurora4 = Color(0xFFFF6B35); // orange feu
  static const Color aurora5 = Color(0xFFFF3CAC); // rose néon

  // ─── LIGHT ───────────────────────────────────────────────
  static const Color lightBg      = Color(0xFFF0F6FF);
  static const Color lightCard    = Color(0xFFFFFFFF);
  static const Color lightBorder  = Color(0x440060CC);
  static const Color lightPrimary = Color(0xFF1565C0);
  static const Color lightText    = Color(0xFF0A1628);
  static const Color lightTextSub = Color(0xFF4A6080);

  // ─── SÉMANTIQUES ─────────────────────────────────────────
  static const Color success = Color(0xFF00F5A0);
  static const Color error   = Color(0xFFFF3CAC);
  static const Color warning = Color(0xFFFF6B35);

  static const Color tempCold = Color(0xFF00D9F5);
  static const Color tempMild = Color(0xFF00F5A0);
  static const Color tempHot  = Color(0xFFFF6B35);

  static const Color gaugeLow  = Color(0xFFFF3CAC);
  static const Color gaugeMid  = Color(0xFFFF6B35);
  static const Color gaugeHigh = Color(0xFF00F5A0);

  static const List<Color> darkGradient  = [Color(0xFF050B1A), Color(0xFF0D1F3C), Color(0xFF0A2040)];
  static const List<Color> lightGradient = [Color(0xFFBDD9FF), Color(0xFF6EB5FF), Color(0xFF3A95F5)];

  static Color temperatureColor(double temp) {
    if (temp < 10) return tempCold;
    if (temp <= 25) return tempMild;
    return tempHot;
  }

  static Color gaugeColor(double percent) {
    if (percent < 0.3) return gaugeLow;
    if (percent < 0.7) return gaugeMid;
    return gaugeHigh;
  }
}
