import 'package:flutter/material.dart';

class AppColors {
  // === Base Purples ===
  static const primary = Color(0xFF7B52AB);
  static const primaryDark = Color(0xFF3D2E5A);
  static const primaryLight = Color(0xFFBDA2E3);

  // === Backgrounds ===
  static const lightBackground = Color(0xFFF5F0FF);
  static const lightSurface = Color(0xFFEDE3FF);
  static const darkBackground = Color(0xFF1C162D);
  static const darkSurface = Color(0xFF2A223E);

  // === Text ===
  static const textDark = Color(0xFF1C1C1C);
  static const textLight = Color(0xFFF3EFFB);

  // === Accent Variants by Function ===

  // 🎮 Start Button (Primary Purple - fog themed)
  static const startPurpleLight = Color(0xFFB585F0);
  static const startPurpleDark = Color(0xFF5F42A3);

  // ✅ Submit Button (Pink)
  static const submitPinkLight = Color(0xFFF8BBD0);
  static const submitPinkDark = Color(0xFFE57399);

  // ⏭️ Next Button (Green)
  static const nextGreenLight = Color.fromARGB(255, 125, 230, 139);
  static const nextGreenDark = Color.fromARGB(255, 76, 130, 85);

  // 🔄 Back to Start (Muted Blue)
  static const backBlueLight = Color(0xFFB5CCFF);
  static const backBlueDark = Color.fromARGB(255, 61, 82, 129);

  // 🔐 Logout Button (Alert Red)
  static const logoutRedLight = Color(0xFFFFB4AB);
  static const logoutRedDark = Color(0xFFEF4C6A);

  // Optional subtle glow color
  static const fogGlow = Color(0xFFE9E0FF);

  //hint colors
  static const wrong = Color.fromARGB(255, 219, 34, 34);
  static const correct = Color.fromARGB(255, 27, 152, 35);
}
