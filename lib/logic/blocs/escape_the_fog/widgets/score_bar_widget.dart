import 'package:flutter/material.dart';

class ScoreBarWidget extends StatelessWidget {
  final int currentScore;
  final int requiredScore;

  const ScoreBarWidget({
    super.key,
    required this.currentScore,
    required this.requiredScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔺 Sigil: +10  ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('💀 Curse: -5  ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            '🧮 Score: $currentScore / $requiredScore',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
