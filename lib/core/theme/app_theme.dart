import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

//class AppTheme {
// static ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   scaffoldBackgroundColor: AppColors.lightBackground,
//   primaryColor: AppColors.primary,
//   //elevatedButtonTheme: AppButtonStyles.,
//   textTheme: GoogleFonts.playTextTheme().apply(
//     bodyColor: AppColors.textDark,
//     displayColor: AppColors.textDark,
//   ),
//   appBarTheme: const AppBarTheme(
//     backgroundColor: AppColors.lightBackground,
//     foregroundColor: AppColors.textDark,
//     elevation: 0,
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: AppColors.lightSurface,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: AppColors.accentPink),
//     ),
//     labelStyle: const TextStyle(color: AppColors.textDark),
//   ),
// // );
// static ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light, // Must match ↓
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: AppColors.primary,
//     brightness: Brightness.light, // 👈 Important!
//     primary: AppColors.primary,
//     onPrimary: AppColors.textLight,
//     background: AppColors.lightBackground,
//     surface: AppColors.lightSurface,
//     onBackground: AppColors.textDark,
//     onSurface: AppColors.textDark,
//   ),
//   // Other theme setup...
// );

// static ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: AppColors.primaryDark,
//     brightness: Brightness.dark, // 👈 Match!
//     primary: AppColors.primaryDark,
//     onPrimary: AppColors.textLight,
//     background: AppColors.darkBackground,
//     surface: AppColors.darkSurface,
//     onBackground: AppColors.textLight,
//     onSurface: AppColors.textLight,
//   ),
//   // Other theme setup...
// );

// static ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   scaffoldBackgroundColor: AppColors.darkBackground,
//   primaryColor: AppColors.primary,
//   // elevatedButtonTheme: AppButtonStyles.arcadeButtonTheme,
//   textTheme: GoogleFonts.playTextTheme().apply(
//     bodyColor: AppColors.textLight,
//     displayColor: AppColors.textLight,
//   ),
//   appBarTheme: const AppBarTheme(
//     backgroundColor: AppColors.darkBackground,
//     foregroundColor: AppColors.textLight,
//     elevation: 0,
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: AppColors.darkSurface,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: AppColors.accentOrange),
//     ),
//     labelStyle: const TextStyle(color: AppColors.textLight),
//   ),
// );
//}
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.textDark,
      surface: AppColors.lightSurface,
      onSurface: AppColors.textDark,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primaryLight,
    textTheme: GoogleFonts.playTextTheme().apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.textDark,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.textDark),
      ),
      labelStyle: const TextStyle(color: AppColors.textDark),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.textLight,
      surface: AppColors.darkSurface,
      onSurface: AppColors.textLight,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primaryDark,
    textTheme: GoogleFonts.playTextTheme().apply(
      bodyColor: AppColors.textLight,
      displayColor: AppColors.textLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.textLight,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.textLight),
      ),
      labelStyle: const TextStyle(color: AppColors.textLight),
    ),
  );
}
