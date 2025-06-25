import 'package:flutter/material.dart';
import 'package:foggi/core/theme/text_styles.dart';

import '../constants/colors.dart';

class AppButtonStyles {
  static ButtonStyle startButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.styleFrom(
      backgroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.styleFrom(
      backgroundColor:
          isDark ? AppColors.submitPinkDark : AppColors.submitPinkLight,
      foregroundColor: isDark ? AppColors.textLight : AppColors.textDark,
      textStyle: AppTextStyles.buttonGame.copyWith(
        color: isDark ? AppColors.textLight : AppColors.textDark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: isDark ? AppColors.textLight : AppColors.textDark,
          width: 2,
        ),
      ),
    );
  }

  static ButtonStyle nextButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.styleFrom(
      backgroundColor:
          isDark ? AppColors.nextGreenDark : AppColors.nextGreenLight,
      foregroundColor: isDark ? AppColors.textLight : AppColors.textDark,
      textStyle: AppTextStyles.buttonGame.copyWith(
        color: isDark ? AppColors.textLight : AppColors.textDark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: isDark ? AppColors.textLight : AppColors.textDark,
          width: 2,
        ),
      ),
    );
  }

  static ButtonStyle backToStart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.styleFrom(
      backgroundColor:
          isDark ? AppColors.backBlueDark : AppColors.backBlueLight,
      foregroundColor: isDark ? AppColors.textLight : AppColors.textDark,
      textStyle: AppTextStyles.buttonGame.copyWith(
        color: isDark ? AppColors.textLight : AppColors.textDark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: isDark ? AppColors.textLight : AppColors.textDark,
          width: 2,
        ),
      ),
    );
  }

  static ButtonStyle logoutButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.styleFrom(
      backgroundColor:
          isDark ? AppColors.logoutRedDark : AppColors.logoutRedLight,
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
}
