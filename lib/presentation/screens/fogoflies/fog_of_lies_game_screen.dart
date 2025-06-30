import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../logic/blocs/fogoflies/fog_of_lies_bloc.dart';
import '../../../logic/blocs/fogoflies/fog_of_lies_event.dart';
import '../../../logic/blocs/fogoflies/fog_of_lies_state.dart';

class FogOfLiesGameScreen extends StatelessWidget {
  final String gameId;

  const FogOfLiesGameScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fog of Lies')),
      body: BlocListener<FogOfLiesBloc, FogOfLiesState>(
        listenWhen: (prev, curr) => curr is FogOfLiesGameOver,
        listener: (context, state) {
          Future.delayed(const Duration(seconds: 2), () {
            context.pushNamed('fog_of_lies_leaderboard');
          });
        },
        child: BlocBuilder<FogOfLiesBloc, FogOfLiesState>(
          builder: (context, state) {
            if (state is FogOfLiesInProgress) {
              return _buildBluffPhase(context, state);
            } else if (state is FogOfLiesRoundResult) {
              return _buildResultPhase(context, state);
            } else if (state is FogOfLiesGameOver) {
              return const Center(
                  child: Text('Game over! Loading leaderboard...'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildBluffPhase(BuildContext context, FogOfLiesInProgress state) {
    final bloc = context.read<FogOfLiesBloc>();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return const Center(child: Text("⚠️ Not logged in"));
    }

    final isAgainstBot = state.currentGuesser.uid.startsWith('bot_') ||
        state.currentRiddler.uid.startsWith('bot_');

    final isMyTurnToBluff =
        state.fakeAnswer == null && state.currentRiddler.uid == currentUserId;
    final isMyTurnToGuess =
        state.fakeAnswer != null && state.currentGuesser.uid == currentUserId;

    final shouldWait = !isAgainstBot && !isMyTurnToBluff && !isMyTurnToGuess;

    if (shouldWait) {
      final playerName =
          FirebaseAuth.instance.currentUser!.uid == state.currentGuesser.uid
              ? state.currentGuesser.name
              : state.currentRiddler.name;

      final opponentName =
          FirebaseAuth.instance.currentUser!.uid == state.currentGuesser.uid
              ? state.currentRiddler.name
              : state.currentGuesser.name;

      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Foggy Lottie animation (make sure the asset exists)
              SizedBox(
                height: 200,
                child: Lottie.asset(
                    'assets/animations/fog_overlay2.json'), // ✅ Customize path
              ),
              const SizedBox(height: 24),
              const Text(
                "Waiting for your opponent...",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "🧍 You: $playerName",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "🧑 Opponent: $opponentName",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                "The fog is thick...\nYour opponent is thinking.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
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

    return const Center(child: Text("Unexpected state..."));
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

    final rounds = result.rounds;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.push('/fog_of_lies_review', extra: {
                'rounds': rounds,
                'currentUserId': currentUserId,
              });
            },
            child: const Text("Review My Answers"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.pushNamed('fog_of_lies_leaderboard');
            },
            child: const Text("Leaderboard"),
          ),
        ],
      ),
    );
  }
}
