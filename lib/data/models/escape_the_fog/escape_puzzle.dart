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

  static EscapePuzzle generate({int rows = 5, int cols = 5}) {
    final rand = Random();
    final grid = List.generate(rows, (_) {
      return List.generate(cols, (_) {
        final r = rand.nextDouble();
        if (r < 0.2) return '⬛';
        if (r < 0.25) return '💀';
        return '🌫️';
      });
    });

    grid[0][0] = '🟩';
    grid[rows - 1][cols - 1] = '🚪';

    const sigils = ['🔺', '🔷', '⚫️'];
    for (final sigil in sigils) {
      while (true) {
        final r = rand.nextInt(rows);
        final c = rand.nextInt(cols);
        if (grid[r][c] == '🌫️') {
          grid[r][c] = sigil;
          break;
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

    playerRow = newRow;
    playerCol = newCol;

    if (requiredSigils.contains(nextTile)) {
      collectedSigils.add(nextTile);
      score += 10;
      maze[newRow][newCol] = '🌫️';
    } else if (nextTile == '💀') {
      score -= 5;
    }

    return true;
  }

  bool isAtExit() => playerRow == goalRow && playerCol == goalCol;
}
