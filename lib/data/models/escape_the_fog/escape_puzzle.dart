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

    // 1. Create empty grid
    final grid = List.generate(rows, (_) => List.filled(cols, '🌫️'));

    // 2. Set start and goal
    final start = (0, 0);
    final goal = (rows - 1, cols - 1);

    grid[start.$1][start.$2] = '🟩';
    grid[goal.$1][goal.$2] = '🚪';

    // 3. Generate valid path using DFS
    final path = _generatePath(rows, cols, start, goal, rand);

    final protected = path.toSet();

    // 4. Place walls and curses outside the path
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (protected.contains((r, c))) continue;

        double chance = rand.nextDouble();
        if (chance < 0.2) {
          grid[r][c] = '⬛'; // wall
        } else if (chance < 0.25) {
          grid[r][c] = '💀'; // curse
        }
      }
    }

    // 5. Place sigils on fog tiles not on path start/end
    const sigils = ['🔺', '🔷', '⚫️'];
    for (final sigil in sigils) {
      while (true) {
        final r = rand.nextInt(rows);
        final c = rand.nextInt(cols);
        if (grid[r][c] == '🌫️' &&
            !(r == start.$1 && c == start.$2) &&
            !(r == goal.$1 && c == goal.$2)) {
          grid[r][c] = sigil;
          break;
        }
      }
    }

    return EscapePuzzle(
      maze: grid,
      startRow: start.$1,
      startCol: start.$2,
      goalRow: goal.$1,
      goalCol: goal.$2,
      playerRow: start.$1,
      playerCol: start.$2,
    );
  }

  static List<(int, int)> _generatePath(
      int rows, int cols, (int, int) start, (int, int) goal, Random rand) {
    final visited = <(int, int)>{};
    final path = <(int, int)>[];

    bool dfs(int r, int c) {
      if (r < 0 || r >= rows || c < 0 || c >= cols || visited.contains((r, c)))
        return false;
      visited.add((r, c));
      path.add((r, c));

      if ((r, c) == goal) return true;

      final directions = [
        (0, 1), // right
        (1, 0), // down
        (0, -1), // left
        (-1, 0), // up
      ]..shuffle(rand);

      for (final (dr, dc) in directions) {
        if (dfs(r + dr, c + dc)) return true;
      }

      path.removeLast();
      return false;
    }

    dfs(start.$1, start.$2);
    return path;
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

  bool hasCollectedAllSigils() => collectedSigils.containsAll(requiredSigils);
}
