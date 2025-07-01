// At the top:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../logic/blocs/fogoflies/fog_of_lies_bloc.dart';
import '../../../logic/blocs/fogoflies/fog_of_lies_event.dart';
import '../../../logic/blocs/fogoflies/fog_of_lies_state.dart';
import 'widgets/fog_of_lies_game_summary_dialog.dart';

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
          if (state is FogOfLiesGameOver) {
            final bloc = context.read<FogOfLiesBloc>();
            final p1 = bloc.player1;
            final p2 = bloc.player2;
            final rounds = state.rounds;
            final scores = state.scores;
            final currentUserId = FirebaseAuth.instance.currentUser!.uid;

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => FogOfLiesGameSummaryDialog(
                player1: p1,
                player2: p2,
                scores: scores,
                rounds: rounds,
                currentUserId: currentUserId,
              ),
            );
          }
        },
        child: BlocBuilder<FogOfLiesBloc, FogOfLiesState>(
          builder: (context, state) {
            if (state is FogOfLiesInProgress) {
              return _buildBluffPhase(context, state);
            } else if (state is FogOfLiesRoundResult) {
              return _buildResultPhase(context, state);
            } else if (state is FogOfLiesGameOver) {
              return const Center(child: Text('Game over!'));
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

    final isBotTurnToBluff =
        state.fakeAnswer == null && state.currentRiddler.uid.startsWith('bot_');
    final isBotTurnToGuess =
        state.fakeAnswer != null && state.currentGuesser.uid.startsWith('bot_');

    final shouldWait = !isMyTurnToBluff &&
        !isMyTurnToGuess &&
        !(isBotTurnToBluff || isBotTurnToGuess);

    // 🤖 BOT is writing fake answer
    // 🤖 BOT is writing fake answer
    if (isBotTurnToBluff) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1), () {
          if (bloc.state is FogOfLiesInProgress &&
              (bloc.state as FogOfLiesInProgress).fakeAnswer == null) {
            final fakeAnswers = [
              "Phantom Whispers",
              "Ghost Echo",
              "Fogbound Truth",
              "Misty Mirage",
              "Whispering Lantern",
              "Eerie Footsteps",
              "Moonlit Illusion",
              "Spectral Riddle",
            ];
            fakeAnswers.shuffle();
            final selectedFake = fakeAnswers.first;

            bloc.add(SubmitFakeAnswer(fakeAnswer: selectedFake));
          }
        });
      });

      return _botThinkingScreen("FogBot is crafting a bluff...");
    }

    // 🤖 BOT is guessing
    if (isBotTurnToGuess && state.currentRiddler.uid == currentUserId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1), () {
          final answers = [state.correctAnswer, state.fakeAnswer!];
          answers.shuffle();
          bloc.add(SubmitGuess(chosenAnswer: answers.first));
        });
      });

      return _botThinkingScreen("FogBot is thinking...");
    }

    // ⏳ Wait for real opponent
    if (shouldWait) {
      final playerName = currentUserId == state.currentGuesser.uid
          ? state.currentGuesser.name
          : state.currentRiddler.name;
      final opponentName = currentUserId == state.currentGuesser.uid
          ? state.currentRiddler.name
          : state.currentGuesser.name;

      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Lottie.asset('assets/animations/fog_overlay2.json'),
              ),
              const SizedBox(height: 24),
              const Text(
                "Waiting for your opponent...",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text("🧍 You: $playerName", style: const TextStyle(fontSize: 16)),
              Text("🧑 Opponent: $opponentName",
                  style: const TextStyle(fontSize: 16)),
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

    // 📝 Human is writing fake answer
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

    // ❓ Human is guessing
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

    // 🚨 Safety fallback
    return const Center(child: Text("Unexpected state..."));
  }

  Widget _buildResultPhase(BuildContext context, FogOfLiesRoundResult result) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final guesserId = result.guesserUid;
    final isBot = guesserId.startsWith('bot_');
    final isCurrentUser = guesserId == currentUserId;

    final label = isBot
        ? "FogBot chose: ${result.chosenAnswer}"
        : "You chose: ${result.chosenAnswer}";

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
          Text(label), // ✅ FIXED
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

  Widget _botThinkingScreen(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 200,
              child: Lottie.asset('assets/animations/fog_overlay2.json')),
          const SizedBox(height: 24),
          Text(message,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text("The fog is thick...\nFogBot is pondering...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
