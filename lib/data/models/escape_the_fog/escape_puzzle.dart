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

  EscapePuzzle({
    required this.maze,
    required this.startRow,
    required this.startCol,
    required this.goalRow,
    required this.goalCol,
    required this.playerRow,
    required this.playerCol,
  });

  static EscapePuzzle generate({int rows = 5, int cols = 5, int level = 1}) {
    final rand = Random();
    List<List<String>> grid = List.generate(rows, (_) {
      return List.generate(cols, (_) => rand.nextDouble() < 0.2 ? '⬛' : '🌫️');
    });

    // Start & goal
    grid[0][0] = '🟩';
    grid[rows - 1][cols - 1] = '🚪';

    // Place sigils
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

    // Level 1+: Curse tiles
    int curseCount = level >= 1 ? (rows * cols / 15).floor() : 0;
    for (int i = 0; i < curseCount; i++) {
      while (true) {
        int r = rand.nextInt(rows);
        int c = rand.nextInt(cols);
        if (grid[r][c] == '🌫️') {
          grid[r][c] = '💀';
          break;
        }
      }
    }

    // Level 2+: Mystery tiles
    if (level >= 2) {
      int mysteryCount = (rows * cols / 20).floor();
      for (int i = 0; i < mysteryCount; i++) {
        while (true) {
          int r = rand.nextInt(rows);
          int c = rand.nextInt(cols);
          if (grid[r][c] == '🌫️') {
            grid[r][c] = '❓';
            break;
          }
        }
      }
    }

    return EscapePuzzle(
      maze: grid,
      startRow: 0,
      startCol: 0,
      goalRow: rows - 1,
      goalCol: cols - 1,
      playerRow: 0,
      playerCol: 0,
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
        newCol >= maze[0].length) return false;
    final nextTile = maze[newRow][newCol];
    if (nextTile == '⬛') return false;

    // Move valid
    playerRow = newRow;
    playerCol = newCol;

    if (requiredSigils.contains(nextTile)) {
      collectedSigils.add(nextTile);
      score += 10;
      maze[newRow][newCol] = '🌫️';
      print("🧿 Collected sigil: $nextTile => +10");
    } else if (nextTile == '💀') {
      score -= 5;
      print("💀 Cursed tile! -5 points");
    } else if (nextTile == '❓') {
      int delta = Random().nextBool() ? 5 : -5;
      score += delta;
      print("❓ Mystery tile! ${delta > 0 ? '+$delta' : '$delta'}");
      maze[newRow][newCol] = '🌫️';
    }

    return true;
  }

  bool isAtExit() => playerRow == goalRow && playerCol == goalCol;
  bool hasCollectedAllSigils() => collectedSigils.containsAll(requiredSigils);
}
