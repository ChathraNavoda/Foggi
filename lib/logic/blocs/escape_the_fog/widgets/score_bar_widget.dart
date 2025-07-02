import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final int score;
  final int minRequired;

  const ScoreBar({super.key, required this.score, required this.minRequired});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("🎯 Score: $score / $minRequired",
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("🔺🔷⚫️ = +10", style: TextStyle(fontSize: 14)),
            SizedBox(width: 10),
            Text("💀 = -5", style: TextStyle(fontSize: 14, color: Colors.red)),
          ],
        ),
      ],
    );
  }
}
