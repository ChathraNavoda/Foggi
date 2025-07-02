import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final int score;
  final Set<String> collectedSigils;
  final int requiredScore;

  const ScoreBar({
    super.key,
    required this.score,
    required this.collectedSigils,
    required this.requiredScore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sigils Collected:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              collectedSigils.join(" "),
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              "Score: $score/$requiredScore",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
