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

  List<Widget> _buildScoreItems() {
    List<Widget> items = [
      const Text('🔺 +10'),
      const SizedBox(width: 10),
      const Text('💀 -5'),
    ];

    if (level >= 2) {
      items.addAll([
        const SizedBox(width: 10),
        const Text('❓ Mystery'),
      ]);
    }

    if (level >= 3) {
      items.addAll([
        const SizedBox(width: 10),
        const Text('🫥 Vanish'),
      ]);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border(
          bottom: BorderSide(color: Colors.black26),
        ),
      ),
      child: Column(
        children: [
          Text(
            "🌫️ Escape the Fog  |  Level $level",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._buildScoreItems(),
              const SizedBox(width: 10),
              Text('🧮 Score: $currentScore / $requiredScore'),
            ],
          ),
        ],
      ),
    );
  }
}
