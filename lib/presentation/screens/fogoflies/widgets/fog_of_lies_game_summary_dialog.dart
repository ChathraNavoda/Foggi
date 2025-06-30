import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/fogoflies/fog_of_lies_models.dart';

class FogOfLiesGameSummaryDialog extends StatelessWidget {
  final FogOfLiesPlayer player1;
  final FogOfLiesPlayer player2;
  final Map<String, int> scores;
  final List<FogOfLiesRound> rounds;
  final String currentUserId;

  const FogOfLiesGameSummaryDialog({
    super.key,
    required this.player1,
    required this.player2,
    required this.scores,
    required this.rounds,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final score1 = scores[player1.uid] ?? 0;
    final score2 = scores[player2.uid] ?? 0;

    final isDraw = score1 == score2;
    final winner = score1 > score2 ? player1 : player2;
    final isCurrentUserWinner = winner.uid == currentUserId;

    return AlertDialog(
      title: const Text("🎭 Fog of Lies - Game Over"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isDraw
                ? "🤝 It's a tie!"
                : isCurrentUserWinner
                    ? "🏆 You won! The truth shines through the fog."
                    : "😵 You lost! The fog clouded your judgment.",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Text("${player1.name}: $score1 pts"),
          Text("${player2.name}: $score2 pts"),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/home');
                },
                icon: const Icon(Icons.home),
                label: const Text("Home"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/fog_of_lies_leaderboard');
                },
                icon: const Icon(Icons.emoji_events),
                label: const Text("Leaderboard"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Optional: replace with your actual menu route
                  context.go('/fog-of-lies');
                },
                icon: const Icon(Icons.menu),
                label: const Text("Game Menu"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/fog_of_lies_review', extra: {
                    'rounds': rounds,
                    'currentUserId': currentUserId,
                  });
                },
                icon: const Icon(Icons.reviews),
                label: const Text("Review My Answers"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
