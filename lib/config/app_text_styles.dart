import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Font utama: Inter (judul & body). Font mono: JetBrains Mono (label kecil).
/// Ganti sesuai font yang kamu pakai di Figma.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _sans(double size, FontWeight w,
          {Color color = AppColors.textPrimary, double? height, double? ls}) =>
      GoogleFonts.inter(
          fontSize: size,
          fontWeight: w,
          color: color,
          height: height,
          letterSpacing: ls);

  static TextStyle mono(double size,
          {Color color = AppColors.textSecondary, double ls = 1.2}) =>
      GoogleFonts.jetBrainsMono(
          fontSize: size, color: color, letterSpacing: ls);

  static TextStyle get display => _sans(32, FontWeight.w800, height: 1.15, ls: -0.8);
  static TextStyle get h1 => _sans(28, FontWeight.w800, height: 1.15, ls: -0.6);
  static TextStyle get h2 => _sans(22, FontWeight.w800, ls: -0.4);
  static TextStyle get h3 => _sans(18, FontWeight.w700, ls: -0.2);
  static TextStyle get title => _sans(16, FontWeight.w600);
  static TextStyle get body => _sans(14, FontWeight.w400, height: 1.45);
  static TextStyle get bodySecondary =>
      _sans(14, FontWeight.w400, color: AppColors.textSecondary, height: 1.45);
  static TextStyle get label =>
      _sans(12, FontWeight.w400, color: AppColors.textSecondary);
  static TextStyle get labelBold => _sans(12, FontWeight.w600);
  static TextStyle get button => _sans(15, FontWeight.w600);
}
