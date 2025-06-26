// lib/features/riddle/widgets/game_summary_dialog.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/button_styles.dart';

class GameSummaryDialog extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoToLeaderboard;
  final VoidCallback onReturnToMenu;
  final VoidCallback onReturnToHome;

  const GameSummaryDialog({
    super.key,
    required this.score,
    required this.total,
    required this.onPlayAgain,
    required this.onGoToLeaderboard,
    required this.onReturnToMenu,
    required this.onReturnToHome,
  });

  String _getMessage(int score, int total) {
    final percent = score / total;

    if (percent == 1.0) {
      return "🌟 Brilliant! You've cleared all the fog and guided Míro back to the light!";
    }
    if (percent >= 0.7) {
      return "✨ So close! The mist is lifting, and Míro can almost see clearly...";
    }
    if (percent >= 0.4) {
      return "💭 You cleared some of the fog. Míro whispers from beyond, waiting for more clues...";
    }
    return "🌫️ The fog thickens... Míro is still lost in the haze. Try again, brave soul!";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("🎉 Game Over"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("You scored $score out of $total!",
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          Text(_getMessage(score, total),
              style:
                  const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          const SizedBox(height: 24),

          /// 🟦 Action Buttons Section
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              AppButtonStyles.homeIconButton(context, onReturnToHome),
              AppButtonStyles.leaderboardIconButton(context, onGoToLeaderboard),
              AppButtonStyles.menuIconButton(context, onReturnToMenu),
              AppButtonStyles.backToStartIconButton(context, onPlayAgain),
            ],
          ),
        ],
      ),
    );
  }
}
