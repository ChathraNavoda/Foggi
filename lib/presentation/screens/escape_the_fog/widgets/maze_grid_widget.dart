import 'package:flutter/material.dart';

import '../../../../../data/models/escape_the_fog/escape_puzzle.dart';

class MazeGrid extends StatelessWidget {
  final EscapePuzzle puzzle;

  const MazeGrid({super.key, required this.puzzle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(puzzle.maze.length, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(puzzle.maze[row].length, (col) {
            final isPlayer = row == puzzle.playerRow && col == puzzle.playerCol;

            return Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isPlayer ? Colors.amber : Colors.white,
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                isPlayer ? '🧍' : puzzle.maze[row][col],
                style: const TextStyle(fontSize: 20),
              ),
            );
          }),
        );
      }),
    );
  }
}
