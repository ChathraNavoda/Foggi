import 'dart:math';

class EscapePuzzle {
  final List<List<String>> maze;
  final int startRow;
  final int startCol;
  final int goalRow;
  final int goalCol;
  int playerRow;
  int playerCol;

  final Set<String> sigils = {'🔺', '🔷', '⚫️'};
  final int minScoreToEscape = 20;
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

  static EscapePuzzle generate({int rows = 5, int cols = 5}) {
    final rand = Random();

    List<List<String>> grid = List.generate(rows, (_) {
      return List.generate(cols, (_) => rand.nextDouble() < 0.2 ? '⬛' : '🌫️');
    });

    int startRow = 0;
    int startCol = 0;
    int goalRow = rows - 1;
    int goalCol = cols - 1;

    grid[startRow][startCol] = '🟩';
    grid[goalRow][goalCol] = '🚪';

    const sigils = ['🔺', '🔷', '⚫️'];
    for (var sigil in sigils) {
      while (true) {
        int r = rand.nextInt(rows);
        int c = rand.nextInt(cols);
        if (grid[r][c] == '🌫️') {
          grid[r][c] = sigil;
          break;
        }
      }
    }

    // Add 2–3 curse tiles
    int curseCount = 3;
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
      return false;
    }

    final tile = maze[newRow][newCol];
    if (tile == '⬛') return false;

    playerRow = newRow;
    playerCol = newCol;

    if (sigils.contains(tile)) {
      score += 10;
      maze[newRow][newCol] = '🌫️';
      print("🧿 Collected sigil $tile (+10). Score: $score");
    } else if (tile == '💀') {
      score -= 5;
      maze[newRow][newCol] = '🌫️';
      print("💀 Hit curse tile (-5). Score: $score");
    }

    return true;
  }

  bool isAtExit() => playerRow == goalRow && playerCol == goalCol;

  bool hasEnoughScore() => score >= minScoreToEscape;
}
