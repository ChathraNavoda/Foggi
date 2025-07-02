import 'package:flutter/material.dart';

import '../../../../../data/models/escape_the_fog/escape_puzzle.dart';

class MazeGrid extends StatelessWidget {
  final EscapePuzzle puzzle;

  const MazeGrid({super.key, required this.puzzle});

  Color _tileColor(String tile, bool isPlayer) {
    if (isPlayer) return Colors.amber;
    switch (tile) {
      case '🟩':
        return Colors.green.shade300;
      case '⬛':
        return Colors.grey.shade800;
      case '🚪':
        return Colors.brown.shade400;
      case '🌫️':
        return Colors.blueGrey.shade100;
      case '🔺':
      case '🔷':
      case '⚫️':
        return Colors.deepPurple.shade100;
      case '💀':
        return Colors.red.shade200;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = puzzle.maze.length;
    final cols = puzzle.maze[0].length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxTileSize = (constraints.maxWidth - (cols - 1) * 4) /
            cols; // subtracting spacing
        final tileSize =
            maxTileSize.clamp(24.0, 48.0); // prevent too small/large

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(rows, (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(cols, (col) {
                final isPlayer =
                    row == puzzle.playerRow && col == puzzle.playerCol;
                final tile = puzzle.maze[row][col];

                return Container(
                  width: tileSize,
                  height: tileSize,
                  margin: const EdgeInsets.all(1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _tileColor(tile, isPlayer),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    isPlayer ? '🧍' : tile,
                    style: TextStyle(fontSize: tileSize / 2),
                  ),
                );
              }),
            );
          }),
        );
      },
    );
  }
}
