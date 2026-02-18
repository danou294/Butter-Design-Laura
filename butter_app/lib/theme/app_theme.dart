import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs
  static const Color backgroundColor = Color(0xFFFEFFFF); // Fond app
  static const Color cardBackground = Color(0xFFF1EFEB); // Warm grey
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF6D6D6D);
  static const Color chipBackground = Color(0xFFFFFFFF);
  static const Color chipBorder = Color(0xFFE0E0E0);
  static const Color accentColor = Color(0xFF1A1A1A);

  // Typographies
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      );

  // Pour les cards restaurant (Inria Sans)
  static TextStyle get cardInfo => GoogleFonts.inriaSans(
        fontSize: 11,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      );

  static TextStyle get chipText => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      );

  static TextStyle get tabLabel => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      );

  // ThemeData
  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.light(
          surface: backgroundColor,
          primary: accentColor,
        ),
        textTheme: TextTheme(
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thickness: WidgetStateProperty.all(2.0),
          radius: const Radius.circular(1.0),
          thumbColor: WidgetStateProperty.all(Colors.black26),
          minThumbLength: 30.0,
        ),
      );
}
