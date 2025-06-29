import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/blocs/fogoflies/fog_of_lies_bloc.dart';
import '../../../logic/blocs/fogoflies/fog_of_lies_event.dart';
import '../../../logic/blocs/fogoflies/fog_of_lies_state.dart';
import 'fog_of_lies_review_screen.dart';

class FogOfLiesGameScreen extends StatelessWidget {
  final String gameId;
  const FogOfLiesGameScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fog of Lies')),
      body: BlocBuilder<FogOfLiesBloc, FogOfLiesState>(
        builder: (context, state) {
          if (state is FogOfLiesInProgress) {
            return _buildBluffPhase(context, state);
          } else if (state is FogOfLiesRoundResult) {
            return _buildResultPhase(context, state);
          } else if (state is FogOfLiesGameOver) {
            return _buildGameOver(context, state);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildBluffPhase(BuildContext context, FogOfLiesInProgress state) {
    final bloc = context.read<FogOfLiesBloc>();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return const Center(child: Text("⚠️ Not logged in"));
    }

    // Debug state logs
    print("🧪 currentUserId: $currentUserId");
    print("🧪 Riddler: ${state.currentRiddler.uid}");
    print("🧪 Guesser: ${state.currentGuesser.uid}");
    print("🧪 FakeAnswer: ${state.fakeAnswer}");
    final phase = state.fakeAnswer == null ? "bluffing" : "guessing";
    print("🧾 Computed Phase: $phase");

    final isAgainstBot = state.currentGuesser.uid.startsWith('bot_') ||
        state.currentRiddler.uid.startsWith('bot_');

    final isMyTurnToBluff =
        state.fakeAnswer == null && state.currentRiddler.uid == currentUserId;
    final isMyTurnToGuess =
        state.fakeAnswer != null && state.currentGuesser.uid == currentUserId;

    final shouldWait = !isAgainstBot && !isMyTurnToBluff && !isMyTurnToGuess;

    print("👀 EVALUATION:");
    print("isAgainstBot: $isAgainstBot");
    print("isMyTurnToBluff: $isMyTurnToBluff");
    print("isMyTurnToGuess: $isMyTurnToGuess");
    print("❓ shouldWait: $shouldWait");

    if (shouldWait) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text("Waiting for opponent..."),
            const SizedBox(height: 8),
            Text("🧾 My UID: $currentUserId"),
            Text("🧾 Riddler: ${state.currentRiddler.uid}"),
            Text("🧾 Guesser: ${state.currentGuesser.uid}"),
            Text("🧾 FakeAnswer: ${state.fakeAnswer}"),
          ],
        ),
      );
    }

    if (isMyTurnToBluff) {
      final controller = TextEditingController();
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${state.currentRiddler.name}, write a fake answer to trick ${state.currentGuesser.name}!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Text(state.riddle, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Enter fake answer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  bloc.add(SubmitFakeAnswer(fakeAnswer: text));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a fake answer")),
                  );
                }
              },
              child: const Text("Submit Fake Answer"),
            ),
          ],
        ),
      );
    }

    if (isMyTurnToGuess) {
      final answers = [state.correctAnswer, state.fakeAnswer!];
      answers.shuffle();

      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${state.currentGuesser.name}, can you see through the fog?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Text(state.riddle, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ...answers.map((a) => ElevatedButton(
                  onPressed: () {
                    bloc.add(SubmitGuess(chosenAnswer: a));
                  },
                  child: Text(a),
                ))
          ],
        ),
      );
    }

    return const Center(
      child: Text("Unexpected state..."),
    );
  }

  Widget _buildResultPhase(BuildContext context, FogOfLiesRoundResult result) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            result.isCorrect ? Icons.check_circle : Icons.cancel,
            color: result.isCorrect ? Colors.green : Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            result.isCorrect ? "Correct!" : "Wrong!",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text("Correct Answer: ${result.correctAnswer}"),
          Text("Fake Answer: ${result.fakeAnswer}"),
          Text("You chose: ${result.chosenAnswer}"),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.read<FogOfLiesBloc>().add(NextFogOfLiesRound());
            },
            child: const Text("Next Round"),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOver(BuildContext context, FogOfLiesGameOver result) {
    final bloc = context.read<FogOfLiesBloc>();
    final p1 = bloc.player1;
    final p2 = bloc.player2;

    final winnerUid =
        result.scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final winnerName = winnerUid == p1.uid ? p1.name : p2.name;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("🏁 Game Over!", style: TextStyle(fontSize: 28)),
          const SizedBox(height: 24),
          Text("Winner: $winnerName",
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text("${p1.name}: ${result.scores[p1.uid] ?? 0} points"),
          Text("${p2.name}: ${result.scores[p2.uid] ?? 0} points"),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Back to Home"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => FogOfLiesReviewScreen(rounds: result.rounds),
              ));
            },
            child: const Text("Review My Answers"),
          ),
        ],
      ),
    );
  }
}
