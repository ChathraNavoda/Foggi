// lib/features/riddle/widgets/game_summary_dialog.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/button_styles.dart';

class GameSummaryDialog extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoToLeaderboard;
  final VoidCallback onReturnToMenu;

  const GameSummaryDialog({
    super.key,
    required this.score,
    required this.total,
    required this.onPlayAgain,
    required this.onGoToLeaderboard,
    required this.onReturnToMenu,
  });

  String _getMessage(int score, int total) {
    final percent = score / total;
    if (percent == 1.0) return "🎯 Perfect! You're a foggi master!";
    if (percent >= 0.7) return "🔥 Great job! You're almost there!";
    if (percent >= 0.4) return "😌 Not bad, try again!";
    return "👻 Fog got you this time!";
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: onReturnToMenu,
          child: const Text("🏠 Menu"),
        ),
        TextButton(
          onPressed: onGoToLeaderboard,
          child: const Text("👑 Leaderboard"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.replay),
          style: AppButtonStyles.backToStart(context),
          onPressed: onPlayAgain,
          label: const Text("Play Again"),
        ),
        // ElevatedButton.icon(
        //   onPressed: () {
        //     context.read<RiddleGameBloc>().add(ReturnToMenu());
        //   },
        //   icon: const Icon(Icons.replay),
        //   style: AppButtonStyles.backToStart(context),
        //   label: Text("Back To Start",
        //       style: AppTextStyles.buttonGame),
        // ),
      ],
    );
  }
}
