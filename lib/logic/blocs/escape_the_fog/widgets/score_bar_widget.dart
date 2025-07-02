import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final int score;
  final int required;

  const ScoreBar({super.key, required this.score, required this.required});

  @override
  Widget build(BuildContext context) {
    final color = score >= required ? Colors.green : Colors.red;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Score: ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("$score / $required",
            style: TextStyle(color: color, fontSize: 16)),
        const SizedBox(width: 10),
        const Text("(🔺 +2, 💀 -1)", style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
