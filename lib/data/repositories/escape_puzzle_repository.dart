import '../models/escape_the_fog/escape_puzzle.dart';

class EscapePuzzleRepository {
  // Later you can fetch from Firestore or remote API
  List<EscapePuzzle> getPuzzles({int count = 1}) {
    final List<EscapePuzzle> puzzles = [
      EscapePuzzle(
        maze: [
          ['🟩', '⬛', '⬛', '⬛'],
          ['⬛', '🌫️', '⬛', '⬛'],
          ['⬛', '⬛', '🌫️', '⬛'],
          ['⬛', '⬛', '⬛', '🚪'],
        ],
        startRow: 0,
        startCol: 0,
        playerRow: 0,
        playerCol: 0,
        goalRow: 3,
        goalCol: 3,
      ),
      EscapePuzzle(
        maze: [
          ['🟩', '⬛', '🌫️', '⬛'],
          ['⬛', '🌫️', '⬛', '⬛'],
          ['⬛', '⬛', '🌫️', '⬛'],
          ['⬛', '⬛', '⬛', '🚪'],
        ],
        startRow: 0,
        startCol: 0,
        playerRow: 0,
        playerCol: 0,
        goalRow: 3,
        goalCol: 3,
      ),
      EscapePuzzle(
        maze: [
          ['🟩', '🌫️', '⬛', '⬛'],
          ['⬛', '🌫️', '⬛', '🚪'],
          ['⬛', '⬛', '⬛', '⬛'],
          ['⬛', '⬛', '⬛', '⬛'],
        ],
        startRow: 0,
        startCol: 0,
        playerRow: 0,
        playerCol: 0,
        goalRow: 1,
        goalCol: 3,
      ),
    ];

    puzzles.shuffle();
    return puzzles.take(count).toList();
  }
}
