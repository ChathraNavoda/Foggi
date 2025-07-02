import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/blocs/escape_the_fog/escape_the_fog_bloc.dart';
import '../../../../logic/blocs/escape_the_fog/escape_the_fog_event.dart';
import '../../../../logic/blocs/escape_the_fog/escape_the_fog_state.dart';
import '../../../logic/blocs/escape_the_fog/widgets/score_bar_widget.dart';
import 'widgets/direction_controls.dart';
import 'widgets/maze_grid_widget.dart';
import 'widgets/shake_widget.dart';

class EscapeTheFogGameScreen extends StatelessWidget {
  const EscapeTheFogGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escape the Fog")),
      body: BlocBuilder<EscapeTheFogBloc, EscapeTheFogState>(
        builder: (context, state) {
          if (state is EscapeInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<EscapeTheFogBloc>().add(StartEscapeGame());
                },
                child: const Text("Start Game"),
              ),
            );
          }

          if (state is EscapeInProgress) {
            final score = state.puzzle.score;
            final minScore = context.read<EscapeTheFogBloc>().minScoreToEscape;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ScoreBarWidget(
                  currentScore: score,
                  requiredScore: minScore,
                ),
                Center(
                  child: ShakeWidget(
                    shake: state.wrongPath,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 2)),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: MazeGrid(puzzle: state.puzzle),
                    ),
                  ),
                ),
                const DirectionControls(),
              ],
            );
          }

          if (state is EscapeSuccess) {
            return const Center(child: Text("🎉 You escaped!"));
          }

          if (state is EscapeFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("💀 ${state.reason}"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EscapeTheFogBloc>().add(RestartEscapeGame());
                    },
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
