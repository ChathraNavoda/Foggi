import 'package:flutter/material.dart';

class ScoreBarWidget extends StatelessWidget {
  final int currentScore;
  final int requiredScore;
  final int level;

  const ScoreBarWidget({
    super.key,
    required this.currentScore,
    required this.requiredScore,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.black12,
      child: Column(
        children: [
          Text("🌫️ Escape the Fog  |  Level $level",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔺 Sigil: +10  '),
              const Text('💀 Curse: -5  '),
              Text('🧮 Score: $currentScore / $requiredScore'),
            ],
          ),
        ],
      ),
    );
  }
}
