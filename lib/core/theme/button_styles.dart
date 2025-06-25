import 'package:flutter/material.dart';
import 'package:foggi/core/theme/text_styles.dart';

import '../constants/colors.dart';

class AppButtonStyles {
  static ButtonStyle startButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.styleFrom(
      backgroundColor: isDark ? AppColors.primaryDark : AppColors.purple1,
      foregroundColor: isDark ? AppColors.textLight : AppColors.textDark,
      textStyle: AppTextStyles.buttonGame.copyWith(
        color: isDark ? AppColors.textLight : AppColors.textDark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: isDark ? AppColors.textLight : AppColors.textDark,
          width: 4,
        ),
      ),
    );
  }

  static ButtonStyle submitButton(BuildContext context) {
    return ElevatedButton.styleFrom(
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
  }

  static ButtonStyle nextButton(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.accentLime,
      side: const BorderSide(color: AppColors.accentLime, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      textStyle: AppTextStyles.buttonGame,
    );
  }

  static ButtonStyle backToStartButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton.styleFrom(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      foregroundColor: isDark ? AppColors.textLight : AppColors.textDark,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.accentPink,
          width: 1,
        ),
      ),
      elevation: 3,
      textStyle: AppTextStyles.buttonGame.copyWith(
        color: isDark ? AppColors.textLight : AppColors.textDark,
      ),
    );
  }

  static ButtonStyle logoutButton(BuildContext context) {
    return ElevatedButton.styleFrom(
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
}
