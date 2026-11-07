import 'package:flutter/material.dart';

const Color kBg = Color(0xFF0A0A0A);
const Color kSurface = Color(0xFF161616);
const Color kSurfaceHigh = Color(0xFF202024);

abstract final class AuraColors {
  static const Color background = Color(0xFF0A0A0A);
  static const Color card = Color(0xFF161616);
  static const Color red = Color(0xFFE11D2E);
  static const Color redBorder = Color(0x33E11D2E);
  static const Color secondary = Color(0xFF9A9A9A);
}

ThemeData buildAuraTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.standard,
      scaffoldBackgroundColor: AuraColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AuraColors.red,
        secondary: AuraColors.red,
        surface: AuraColors.card,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0x000A0A0A),
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xF20A0A0A),
        indicatorColor: Color(0x24FFFFFF),
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xAA1A1A1D),
        selectedColor: AuraColors.red,
        side: const BorderSide(color: Color(0x30FFFFFF)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: const TextStyle(color: Colors.white),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AuraColors.red,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0x55FFFFFF)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AuraColors.red,
        inactiveTrackColor: const Color(0xFF38383D),
        thumbColor: Colors.white,
        overlayColor: const Color(0x22E11D2E),
        trackHeight: 3,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0x22FFFFFF),
        thickness: 0.5,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF252529),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
