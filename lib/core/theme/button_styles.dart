import 'package:flutter/material.dart';
import 'package:foggi/core/theme/text_styles.dart';

import '../constants/colors.dart';

class AppButtonStyles {
  static final commonButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textLight,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    shadowColor: AppColors.accentOrange,
    elevation: 20,
    textStyle: AppTextStyles.buttonMain,
  );

  static final startButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.purple1,
    foregroundColor: AppColors.textLight,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: AppColors.textDark, width: 4),
    ),
    shadowColor: AppColors.accentOrange,
    elevation: 10,
    textStyle: AppTextStyles.buttonGame,
  );

  static final submitButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.accentBlue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.accentBlue, width: 1.5),
    ),
    elevation: 4,
    textStyle: AppTextStyles.buttonGame,
  );

  static final nextButton = OutlinedButton.styleFrom(
    foregroundColor: AppColors.accentLime,
    side: const BorderSide(color: AppColors.accentLime, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    textStyle: AppTextStyles.buttonGame,
  );

  static final backToStartButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.textLight,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.accentPink, width: 1),
    ),
    elevation: 3,
    textStyle: AppTextStyles.buttonGame,
  );

  static final logoutButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.red.shade700,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 4,
    textStyle: AppTextStyles.buttonGame,
  );
}
