import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/button_styles.dart';
import '../../../core/theme/text_styles.dart';
import '../../../logic/blocs/riddle/riddle_game_bloc.dart';
import '../../../logic/blocs/riddle/riddle_game_event.dart';
import '../../../logic/blocs/riddle/riddle_game_state.dart';
import 'widgets/game_summary_dialog.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: "How to Play",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("🧩 How to Play"),
                  content: const Text(
                    "Solve riddles before the timer runs out!\n"
                    "Each correct answer clears a bit of the fog.\n"
                    "Help Míro escape by solving all riddles!\n\n"
                    "Tip: Be fast and think sharp!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Got it!"),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.leaderboard),
            tooltip: "View Leaderboard",
            onPressed: () => context.go('/leaderboard'),
          ),
        ],
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: BlocConsumer<RiddleGameBloc, RiddleGameState>(
              listener: (context, state) => _handleFogTransition(state),
              builder: (context, state) {
                if (state is RiddleInitial) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/animations/ghost_idle.json',
                          height: 100),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "“Hi... I’m Míro. I’ve forgotten everything...\nCan you help me through the fog?”",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome to the Foggi Riddle Rush!",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: AppButtonStyles.startButton(context),
                        label:
                            Text("Start Game", style: AppTextStyles.buttonGame),
                        onPressed: () =>
                            context.read<RiddleGameBloc>().add(StartGame()),
                      )
                    ],
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
                      Text(
                        "💨 Answer correctly to clear the fog!",
                        style: AppTextStyles.body.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
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
                        style: AppButtonStyles.submitButton(context),
                        child: Text("Submit", style: AppTextStyles.buttonGame),
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
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green, width: 2),
                          ),
                          child: Text(
                            "🎉 Correct!",
                            style: AppTextStyles.buttonGame,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("Score: ${state.score}"),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RiddleGameBloc>().add(NextRiddle());
                          },
                          style: AppButtonStyles.nextButton(context),
                          child: Text("Next Riddle",
                              style: AppTextStyles.buttonGame),
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
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.redAccent, width: 2),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Nope! The correct answer was:",
                                style: AppTextStyles.buttonMain,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.correctAnswer,
                                style: AppTextStyles.buttonGame,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RiddleGameBloc>().add(NextRiddle());
                          },
                          style: AppButtonStyles.nextButton(context),
                          child: Text("Next Riddle",
                              style: AppTextStyles.buttonGame),
                        ),
                      ],
                    ),
                  );
                }

                if (state is RiddleGameOver) {
                  Future.delayed(const Duration(seconds: 3), () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => GameSummaryDialog(
                        score: state.score,
                        total: state.total,
                        onPlayAgain: () {
                          context.read<RiddleGameBloc>().add(RestartGame());
                          Navigator.of(context).pop();
                        },
                        onReturnToHome: () {
                          Navigator.of(context).pop();
                          context.go('/home');
                        },
                        onGoToLeaderboard: () {
                          Navigator.of(context).pop();
                          context.go('/leaderboard');
                        },
                        onReturnToMenu: () {
                          context.read<RiddleGameBloc>().add(ReturnToMenu());
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  });
                  String endMessage;
                  String ghostAnimation;

                  if (state.score <= 2) {
                    endMessage =
                        "🌫️ The fog thickens... Míro is still lost. Try again, brave soul!";
                    ghostAnimation = 'assets/animations/ghost_sad.json';
                  } else if (state.score == 3) {
                    endMessage =
                        "💭 You've cleared some of the fog. Míro is whispering faintly...";
                    ghostAnimation = 'assets/animations/ghost_idle.json';
                  } else if (state.score == 4) {
                    endMessage =
                        "✨ So close! Míro can almost remember his name...";
                    ghostAnimation = 'assets/animations/ghost_idle.json';
                  } else {
                    endMessage =
                        "🌟 The fog is gone! Míro sees the world again, thanks to you!";
                    ghostAnimation = 'assets/animations/ghost_happy.json';
                  }

                  return SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          ghostAnimation,
                          width: 160,
                        ),
                        const SizedBox(height: 16),
                        const Text("🏁 Game Over!",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("Your Score: ${state.score} / ${state.total}",
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.white70, width: 1.5),
                          ),
                          child: Text(
                            endMessage,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //     context.read<RiddleGameBloc>().add(ReturnToMenu());
                        //   },
                        //   icon: const Icon(Icons.replay),
                        //   style: AppButtonStyles.backToStart(context),
                        //   label: Text("Back To Start",
                        //       style: AppTextStyles.buttonGame),
                        // ),
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
