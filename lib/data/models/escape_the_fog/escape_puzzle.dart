import 'dart:math';

class EscapePuzzle {
  final List<List<String>> maze;
  final int startRow;
  final int startCol;
  final int goalRow;
  final int goalCol;

  int playerRow;
  int playerCol;
  final Set<String> requiredSigils = {'🔺', '🔷', '⚫️'};
  final Set<String> collectedSigils = {};
  int score = 0;

  final int scoreRequiredToEscape = 3;

  EscapePuzzle({
    required this.maze,
    required this.startRow,
    required this.startCol,
    required this.goalRow,
    required this.goalCol,
    required this.playerRow,
    required this.playerCol,
  });

  static EscapePuzzle generate({int rows = 5, int cols = 5}) {
    final rand = Random();

    List<List<String>> grid = List.generate(rows, (_) {
      return List.generate(cols, (_) {
        double chance = rand.nextDouble();
        if (chance < 0.2) return '⬛'; // wall
        if (chance < 0.25) return '💀'; // curse
        return '🌫️'; // fog
      });
    });

    int startRow = 0;
    int startCol = 0;
    int goalRow = rows - 1;
    int goalCol = cols - 1;

    grid[startRow][startCol] = '🟩';
    grid[goalRow][goalCol] = '🚪';

    // Place sigils on fog tiles
    const sigils = ['🔺', '🔷', '⚫️'];
    for (String sigil in sigils) {
      while (true) {
        int r = rand.nextInt(rows);
        int c = rand.nextInt(cols);
        if (grid[r][c] == '🌫️') {
          grid[r][c] = sigil;
          break;
        }
      }
    }

    return EscapePuzzle(
      maze: grid,
      startRow: startRow,
      startCol: startCol,
      goalRow: goalRow,
      goalCol: goalCol,
      playerRow: startRow,
      playerCol: startCol,
    );
  }

  bool attemptMovePlayer(String direction) {
    int newRow = playerRow;
    int newCol = playerCol;

    switch (direction) {
      case 'up':
        newRow--;
        break;
      case 'down':
        newRow++;
        break;
      case 'left':
        newCol--;
        break;
      case 'right':
        newCol++;
        break;
    }

    if (newRow < 0 ||
        newRow >= maze.length ||
        newCol < 0 ||
        newCol >= maze[0].length) {
      return false; // Out of bounds
    }

    final nextTile = maze[newRow][newCol];
    if (nextTile == '⬛') {
      return false;
    }

    // Move
    playerRow = newRow;
    playerCol = newCol;

    // Handle scoring
    if (requiredSigils.contains(nextTile)) {
      collectedSigils.add(nextTile);
      score += 2;
      maze[newRow][newCol] = '🌫️';
      print("✨ Collected sigil: $nextTile (+2)");
    } else if (nextTile == '💀') {
      score -= 1;
      print("💀 Cursed! (-1)");
    }

    return true;
  }

  bool isAtExit() => playerRow == goalRow && playerCol == goalCol;

  bool hasEnoughScoreToExit() => score >= scoreRequiredToEscape;
}
