import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/blocs/riddle/riddle_game_bloc.dart';
import '../../../logic/blocs/riddle/riddle_game_event.dart';
import '../../../logic/blocs/riddle/riddle_game_state.dart';

class RiddleGameScreen extends StatefulWidget {
  const RiddleGameScreen({super.key});

  @override
  State<RiddleGameScreen> createState() => _RiddleGameScreenState();
}

class _RiddleGameScreenState extends State<RiddleGameScreen> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RiddleGameBloc>().add(StartGame());
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foggi Riddle Rush 👻")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<RiddleGameBloc, RiddleGameState>(
          builder: (context, state) {
            if (state is RiddleInProgress) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Riddle ${state.index + 1} / ${state.total}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.currentRiddle.question,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      labelText: "Your answer",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RiddleGameBloc>().add(
                            SubmitAnswer(_answerController.text),
                          );
                      _answerController.clear();
                    },
                    child: const Text("Submit"),
                  ),
                  const SizedBox(height: 16),
                  Text("⏱️ ${state.secondsLeft} seconds left"),
                ],
              );
            }

            if (state is RiddleCorrect) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "🎉 Correct!",
                    style: TextStyle(fontSize: 22, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  Text("Score: ${state.score}"),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RiddleGameBloc>().add(NextRiddle());
                    },
                    child: const Text("Next Riddle ➡️"),
                  ),
                ],
              );
            }

            if (state is RiddleWrong) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "❌ Nope! The correct answer was:\n${state.correctAnswer}",
                    style:
                        const TextStyle(fontSize: 18, color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RiddleGameBloc>().add(NextRiddle());
                    },
                    child: const Text("Next Riddle ➡️"),
                  ),
                ],
              );
            }

            if (state is RiddleGameOver) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "🏁 Game Over!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text("Your Score: ${state.score} / ${state.total}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RiddleGameBloc>().add(RestartGame());
                    },
                    child: const Text("Play Again 🔄"),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
