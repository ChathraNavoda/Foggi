import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foggi/core/theme/text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/button_styles.dart';
import '../../../logic/blocs/riddle/riddle_game_bloc.dart';
import '../../../logic/blocs/riddle/riddle_game_event.dart';
import '../../../logic/blocs/riddle/riddle_game_state.dart';

class RiddleGameScreen extends StatefulWidget {
  const RiddleGameScreen({super.key});

  @override
  State<RiddleGameScreen> createState() => _RiddleGameScreenState();
}

class _RiddleGameScreenState extends State<RiddleGameScreen> {
  double _fogOpacity = 1.0;

  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _handleFogTransition(RiddleGameState state) {
    if (state is RiddleCorrect) {
      final newOpacity = (_fogOpacity - 0.2).clamp(0.0, 1.0);
      Future.delayed(Duration.zero, () {
        if (mounted) setState(() => _fogOpacity = newOpacity);
      });
    }

    if (state is RiddleGameOver) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          if (state.score == state.total) {
            _fogOpacity = 0.0; // Full reveal
          } else {
            _fogOpacity = 0.6; // Dim fog remains
          }
          setState(() {});
        }
      });
    }

    if (state is RiddleInitial) {
      Future.delayed(Duration.zero, () {
        if (mounted) setState(() => _fogOpacity = 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foggi Riddle Rush 👻"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Stack(
        children: [
          // 🔁 Fog Layer 1 - Bottom left
          Positioned(
            left: -50,
            bottom: -30,
            child: AnimatedOpacity(
              opacity: _fogOpacity,
              duration: const Duration(milliseconds: 600),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1.2,
                height: MediaQuery.of(context).size.height * 1.2,
                child: Lottie.asset(
                  'assets/animations/fog_overlay2.json',
                  repeat: true,
                ),
              ),
            ),
          ),

          // 🔁 Fog Layer 2 - Top right
          Positioned(
            right: -60,
            top: -40,
            child: AnimatedOpacity(
              opacity: _fogOpacity,
              duration: const Duration(milliseconds: 600),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1.3,
                height: MediaQuery.of(context).size.height * 1.3,
                child: Lottie.asset(
                  'assets/animations/fog_overlay2.json',
                  repeat: true,
                ),
              ),
            ),
          ),

          // 🔁 Fog Layer 3 - Center
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _fogOpacity,
              duration: const Duration(milliseconds: 600),
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1.5,
                  height: MediaQuery.of(context).size.height * 1.5,
                  child: Lottie.asset(
                    'assets/animations/fog_overlay2.json',
                    repeat: true,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<RiddleGameBloc, RiddleGameState>(
              listener: (context, state) => _handleFogTransition(state),
              builder: (context, state) {
                if (state is RiddleInitial) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Welcome to the Foggi Riddle Rush!",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: AppButtonStyles.startButton,
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                          ),
                          label: Text(
                            "Start Game",
                            style: AppTextStyles.buttonGame,
                          ),
                          onPressed: () {
                            context.read<RiddleGameBloc>().add(StartGame());
                          },
                        ),
                      ],
                    ),
                  );
                }

                if (state is RiddleInProgress) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Riddle ${state.index + 1} / ${state.total}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text("⏱️ ${state.secondsLeft}s",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.deepPurple)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(state.currentRiddle.question,
                          style: const TextStyle(fontSize: 22)),
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
                    ],
                  );
                }

                if (state is RiddleCorrect) {
                  return SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animations/ghost_dance.json',
                            width: 160, repeat: false),
                        const SizedBox(height: 16),
                        const Text("🎉 Correct!",
                            style:
                                TextStyle(fontSize: 22, color: Colors.green)),
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
                    ),
                  );
                }

                if (state is RiddleWrong) {
                  return SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animations/ghost_sad.json',
                            width: 160, repeat: false),
                        const SizedBox(height: 16),
                        Text(
                          "❌ Nope! The correct answer was:\n${state.correctAnswer}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.redAccent),
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
                    ),
                  );
                }

                if (state is RiddleGameOver) {
                  return SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("🏁 Game Over!",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Text("Your Score: ${state.score} / ${state.total}",
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<RiddleGameBloc>().add(ReturnToMenu());
                          },
                          icon: const Icon(Icons.replay),
                          label: const Text("Back to Start"),
                        ),
                      ],
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
