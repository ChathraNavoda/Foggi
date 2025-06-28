import 'package:flutter/material.dart';

import '../../../data/models/fogoflies/fog_of_lies_models.dart';

class FogOfLiesReviewScreen extends StatelessWidget {
  final List<FogOfLiesRound> rounds;

  const FogOfLiesReviewScreen({super.key, required this.rounds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review My Answers")),
      body: ListView.builder(
        itemCount: rounds.length,
        itemBuilder: (context, index) {
          final round = rounds[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Riddle ${index + 1}: ${round.riddle}"),
                  const SizedBox(height: 8),
                  Text("Correct Answer: ${round.correctAnswer}"),
                  Text("Fake Answer: ${round.fakeAnswer}"),
                  Text("You Chose: ${round.chosenAnswer}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: round.isCorrect ? Colors.green : Colors.red)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
