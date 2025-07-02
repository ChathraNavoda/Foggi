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
        return Colors.red.shade200;
      case '🔷':
        return Colors.blue.shade200;
      case '⚫️':
        return Colors.black87;
      case '💀':
        return Colors.deepPurple.shade700;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(puzzle.maze.length, (row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(puzzle.maze[row].length, (col) {
            final isPlayer = row == puzzle.playerRow && col == puzzle.playerCol;
            final tile = puzzle.maze[row][col];

            return Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _tileColor(tile, isPlayer),
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                isPlayer ? '🧍' : tile,
                style: const TextStyle(fontSize: 20),
              ),
            );
          }),
        );
      }),
    );
  }
}
