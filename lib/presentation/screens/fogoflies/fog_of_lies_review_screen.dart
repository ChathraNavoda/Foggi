import 'package:flutter/material.dart';

import '../../../data/models/fogoflies/fog_of_lies_models.dart';

class FogOfLiesReviewScreen extends StatelessWidget {
  final List<FogOfLiesRound> rounds;
  final String currentUserId;

  const FogOfLiesReviewScreen({
    super.key,
    required this.rounds,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final myGuessingRounds = rounds.where((round) {
      return round.guesserUid == currentUserId;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Review My Answers")),
      body: ListView.builder(
        itemCount: myGuessingRounds.length,
        itemBuilder: (context, index) {
          final round = myGuessingRounds[index];
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
