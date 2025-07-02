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
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                ScoreBar(
                  score: state.puzzle.score,
                  required: state.puzzle.scoreRequiredToEscape,
                ),
                const SizedBox(height: 10),
                Center(
                  child: ShakeWidget(
                    shake: state.wrongPath,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: MazeGrid(puzzle: state.puzzle),
                    ),
                  ),
                ),
                const DirectionControls(),
                const SizedBox(height: 10),
              ],
            );
          }

          if (state is EscapeSuccess) {
            return Center(child: Text("🎉 You escaped successfully!"));
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
