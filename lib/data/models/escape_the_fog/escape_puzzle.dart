import 'dart:math';

class EscapePuzzle {
  final List<List<String>> maze; // 🟩 start, 🚪 goal, ⬛ wall, 🌫️ fog
  final int startRow;
  final int startCol;
  final int goalRow;
  final int goalCol;
  int playerRow;
  int playerCol;

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

  bool isAtExit() => playerRow == goalRow && playerCol == goalCol;

  bool isInBounds(int row, int col) =>
      row >= 0 && row < maze.length && col >= 0 && col < maze[0].length;

  /// Attempt a move. Returns true if successful, false if hit wall or OOB.
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

    if (!isInBounds(newRow, newCol)) {
      print("🚫 Out of bounds!");
      return false;
    }

    final tile = maze[newRow][newCol];
    print("📍 Attempting move to ($newRow, $newCol) => Tile: $tile");

    if (tile == '⬛') {
      print("🚫 Hit a wall!");
      return false;
    }

    playerRow = newRow;
    playerCol = newCol;
    print("✅ Move successful. Player at ($playerRow, $playerCol)");
    return true;
  }

  Map<String, dynamic> toMap() => {
        'maze': maze.map((row) => row.join()).toList(),
        'startRow': startRow,
        'startCol': startCol,
        'goalRow': goalRow,
        'goalCol': goalCol,
        'playerRow': playerRow,
        'playerCol': playerCol,
      };

  factory EscapePuzzle.fromMap(Map<String, dynamic> map) => EscapePuzzle(
        maze: (map['maze'] as List<dynamic>)
            .map((row) => row.toString().split(''))
            .toList(),
        startRow: map['startRow'],
        startCol: map['startCol'],
        goalRow: map['goalRow'],
        goalCol: map['goalCol'],
        playerRow: map['playerRow'],
        playerCol: map['playerCol'],
      );
}
