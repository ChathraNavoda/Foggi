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
          final bloc = context.read<EscapeTheFogBloc>();

          if (state is EscapeInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () => bloc.add(StartEscapeGame()),
                child: const Text("Start Game"),
              ),
            );
          }

          if (state is EscapeInProgress) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ScoreBarWidget(
                  currentScore: state.puzzle.score,
                  requiredScore: bloc.minScoreToEscape,
                  level: bloc.currentLevel,
                ),
                ShakeWidget(
                  shake: state.wrongPath,
                  child: MazeGrid(puzzle: state.puzzle),
                ),
                const DirectionControls(),
              ],
            );
          }

          if (state is EscapeSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("🎉 You escaped!", style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => bloc.add(StartEscapeGame()),
                    child: const Text("Start Next Level"),
                  ),
                ],
              ),
            );
          }

          if (state is EscapeTreasure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("🏆 You found the treasure!",
                      style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => bloc.add(RestartEscapeGame()),
                    child: const Text("Restart from Level 1"),
                  ),
                ],
              ),
            );
          }

          if (state is EscapeFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("💀 ${state.reason}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => bloc.add(RestartEscapeGame()),
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
