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
  final int minScoreToEscape = 10;

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
      return List.generate(cols, (_) => rand.nextDouble() < 0.2 ? '⬛' : '🌫️');
    });

    // Add curses 💀
    int curseCount = 2;
    while (curseCount > 0) {
      int r = rand.nextInt(rows);
      int c = rand.nextInt(cols);
      if (grid[r][c] == '🌫️') {
        grid[r][c] = '💀';
        curseCount--;
      }
    }

    // Set start and goal
    int startRow = 0;
    int startCol = 0;
    int goalRow = rows - 1;
    int goalCol = cols - 1;

    grid[startRow][startCol] = '🟩';
    grid[goalRow][goalCol] = '🚪';

    // Add sigils
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
      print("🚫 Out of bounds!");
      return false;
    }

    final nextTile = maze[newRow][newCol];
    print("🧍 Moved to ($newRow, $newCol) => Tile: $nextTile");

    if (nextTile == '⬛') {
      print("🚫 Hit wall at ($newRow, $newCol)");
      return false;
    }

    // Move
    playerRow = newRow;
    playerCol = newCol;

    // Handle special tiles
    if (requiredSigils.contains(nextTile)) {
      collectedSigils.add(nextTile);
      maze[newRow][newCol] = '🌫️';
      score += 5;
      print("🧿 Collected sigil: $nextTile → Score: $score");
    } else if (nextTile == '💀') {
      score -= 5;
      print("💀 Stepped on a curse! Score: $score");
    }

    return true;
  }

  bool isAtExit() => playerRow == goalRow && playerCol == goalCol;

  bool hasCollectedAllSigils() => collectedSigils.containsAll(requiredSigils);
}
