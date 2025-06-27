import 'package:flutter/material.dart';

import '../../../data/models/riddle_results.dart';

class RiddleReviewScreen extends StatelessWidget {
  final List<RiddleResult> results;

  const RiddleReviewScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    // If there are no results, avoid reduce() on an empty iterable:
    final totalSeconds =
        results.fold<int>(0, (sum, r) => sum + r.timeTaken.inSeconds);
    final averageTime = results.isNotEmpty ? totalSeconds / results.length : 0;

    return Scaffold(
      appBar: AppBar(title: const Text("🧠 Review Answers")),
      body: results.isEmpty
          ? const Center(child: Text("No answers to review."))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, index) {
                final r = results[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text("Q${index + 1}: ${r.question}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Your Answer: ${r.userAnswer}",
                            style: TextStyle(
                                color:
                                    r.isCorrect ? Colors.green : Colors.red)),
                        Text("Correct Answer: ${r.correctAnswer}",
                            style: const TextStyle(color: Colors.blueGrey)),
                        Text("⏱ Time Taken: ${r.timeTaken.inSeconds} sec"),
                      ],
                    ),
                    leading: Icon(
                      r.isCorrect ? Icons.check_circle : Icons.cancel,
                      color: r.isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "⏳ Average Time: ${averageTime.toStringAsFixed(1)} sec",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
