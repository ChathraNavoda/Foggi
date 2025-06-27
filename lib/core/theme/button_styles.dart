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

  static Widget homeIconButton(BuildContext context, VoidCallback onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? AppColors.backBlueDark : AppColors.backBlueLight;
    final borderColor = isDark ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.home, size: 20, color: iconColor),
      label: Text("Home",
          style: AppTextStyles.buttonGame.copyWith(color: iconColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor:
            iconColor, // affects splash, ripple, and disabled state
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }

  static Widget leaderboardIconButton(
      BuildContext context, VoidCallback onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? AppColors.backBlueDark : AppColors.backBlueLight;
    final borderColor = isDark ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.emoji_events_sharp, size: 20, color: iconColor),
      label: Text("Leaderboard",
          style: AppTextStyles.buttonGame.copyWith(color: iconColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor:
            iconColor, // affects splash, ripple, and disabled state
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }

  static Widget reviewAnswersButton(
      BuildContext context, VoidCallback onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? AppColors.backBlueDark : AppColors.backBlueLight;
    final borderColor = isDark ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.scoreboard_sharp, size: 20, color: iconColor),
      label: Text("Review",
          style: AppTextStyles.buttonGame.copyWith(color: iconColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor:
            iconColor, // affects splash, ripple, and disabled state
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }

  static Widget menuIconButton(BuildContext context, VoidCallback onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? AppColors.backBlueDark : AppColors.backBlueLight;
    final borderColor = isDark ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.dashboard, size: 20, color: iconColor),
      label: Text("Menu",
          style: AppTextStyles.buttonGame.copyWith(color: iconColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor:
            iconColor, // affects splash, ripple, and disabled state
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }

  static Widget backToStartIconButton(
      BuildContext context, VoidCallback onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? AppColors.backBlueDark : AppColors.backBlueLight;
    final borderColor = isDark ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.replay, size: 20, color: iconColor),
      label: Text("Play Again",
          style: AppTextStyles.buttonGame.copyWith(color: iconColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor:
            iconColor, // affects splash, ripple, and disabled state
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: borderColor, width: 2),
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
