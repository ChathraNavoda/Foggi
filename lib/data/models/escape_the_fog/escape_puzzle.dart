// import 'dart:math';

// class EscapePuzzle {
//   final List<List<String>> maze;
//   final int startRow;
//   final int startCol;
//   final int goalRow;
//   final int goalCol;
//   int playerRow;
//   int playerCol;
//   final Set<String> requiredSigils = {'🔺', '🔷', '⚫️'};
//   final Set<String> collectedSigils = {};
//   int score = 0;

//   EscapePuzzle({
//     required this.maze,
//     required this.startRow,
//     required this.startCol,
//     required this.goalRow,
//     required this.goalCol,
//     required this.playerRow,
//     required this.playerCol,
//   });

//   static EscapePuzzle generate({int rows = 5, int cols = 5, int level = 1}) {
//     final rand = Random();
//     List<List<String>> grid = List.generate(rows, (_) {
//       return List.generate(cols, (_) => rand.nextDouble() < 0.2 ? '⬛' : '🌫️');
//     });

//     grid[0][0] = '🟩';
//     grid[rows - 1][cols - 1] = '🚪';

//     // Sigils
//     const sigils = ['🔺', '🔷', '⚫️'];
//     for (String sigil in sigils) {
//       while (true) {
//         int r = rand.nextInt(rows);
//         int c = rand.nextInt(cols);
//         if (grid[r][c] == '🌫️') {
//           grid[r][c] = sigil;
//           break;
//         }
//       }
//     }

//     // 💀 Curse Tiles
//     int curseCount = level >= 1 ? (rows * cols / 15).floor() : 0;
//     for (int i = 0; i < curseCount; i++) {
//       while (true) {
//         int r = rand.nextInt(rows);
//         int c = rand.nextInt(cols);
//         if (grid[r][c] == '🌫️') {
//           grid[r][c] = '💀';
//           break;
//         }
//       }
//     }

//     // ❓ Mystery Tiles
//     if (level >= 2) {
//       int mysteryCount = (rows * cols / 20).floor();
//       for (int i = 0; i < mysteryCount; i++) {
//         while (true) {
//           int r = rand.nextInt(rows);
//           int c = rand.nextInt(cols);
//           if (grid[r][c] == '🌫️') {
//             grid[r][c] = '❓';
//             break;
//           }
//         }
//       }
//     }

//     return EscapePuzzle(
//       maze: grid,
//       startRow: 0,
//       startCol: 0,
//       goalRow: rows - 1,
//       goalCol: cols - 1,
//       playerRow: 0,
//       playerCol: 0,
//     );
//   }

//   bool attemptMovePlayer(String direction) {
//     int newRow = playerRow;
//     int newCol = playerCol;

//     switch (direction) {
//       case 'up':
//         newRow--;
//         break;
//       case 'down':
//         newRow++;
//         break;
//       case 'left':
//         newCol--;
//         break;
//       case 'right':
//         newCol++;
//         break;
//     }

//     if (newRow < 0 ||
//         newRow >= maze.length ||
//         newCol < 0 ||
//         newCol >= maze[0].length) {
//       return false;
//     }

//     final nextTile = maze[newRow][newCol];
//     if (nextTile == '⬛') return false;

//     // Move valid
//     playerRow = newRow;
//     playerCol = newCol;

//     if (requiredSigils.contains(nextTile)) {
//       collectedSigils.add(nextTile);
//       score += 10;
//       maze[newRow][newCol] = '🌫️';
//       print("🧿 Collected sigil: $nextTile => +10");
//     } else if (nextTile == '💀') {
//       score -= 5;
//       print("💀 Cursed tile! -5 points");
//     } else if (nextTile == '❓') {
//       int delta = Random().nextBool() ? 5 : -5;
//       score += delta;
//       maze[newRow][newCol] = '🌫️';
//       print("❓ Mystery tile: ${delta > 0 ? '+$delta' : '$delta'}");
//     }

//     // 🌫️🌫️ Level 3: Vanishing tile logic
//     if (score >= 0 && getLevel() == 3 && nextTile == '🌫️') {
//       maze[newRow][newCol] = '⬛';
//       print("🕳️ Vanishing tile! Fog tile became wall.");
//     }

//     return true;
//   }

//   bool isAtExit() => playerRow == goalRow && playerCol == goalCol;

//   int getLevel() {
//     int total = maze.length * maze[0].length;
//     if (total >= 100) return 3;
//     if (total >= 36) return 2;
//     return 1;
//   }

//   bool hasCollectedAllSigils() => collectedSigils.containsAll(requiredSigils);
// }
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

    // Step 1: Create a blank foggy grid
    List<List<String>> grid =
        List.generate(rows, (_) => List.filled(cols, '🌫️'));

    // Step 2: Create a guaranteed path from start to goal
    List<Point<int>> path = _generatePath(rows, cols, rand);

    for (var p in path) {
      grid[p.x][p.y] = '🌫️'; // ensure walkable
    }

    final usedPositions = path.toSet();

    // Step 3: Place start and goal
    grid[0][0] = '🟩';
    grid[rows - 1][cols - 1] = '🚪';

    // Step 4: Add walls (⬛) to some of the remaining tiles
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!usedPositions.contains(Point(r, c)) && rand.nextDouble() < 0.2) {
          grid[r][c] = '⬛';
        }
      }
    }

    // Step 5: Add sigils
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

    // Step 6: Curse tiles 💀
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

    // Step 7: Mystery tiles ❓
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

  static List<Point<int>> _generatePath(int rows, int cols, Random rand) {
    List<Point<int>> path = [Point(0, 0)];
    int r = 0;
    int c = 0;

    while (r != rows - 1 || c != cols - 1) {
      if (r == rows - 1) {
        c++;
      } else if (c == cols - 1) {
        r++;
      } else if (rand.nextBool()) {
        r++;
      } else {
        c++;
      }
      path.add(Point(r, c));
    }

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
        newCol >= maze[0].length) {
      return false;
    }

    final nextTile = maze[newRow][newCol];
    if (nextTile == '⬛') return false;

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
      maze[newRow][newCol] = '🌫️';
      print("❓ Mystery tile: ${delta > 0 ? '+$delta' : '$delta'}");
    }

    if (score >= 0 && getLevel() == 3 && nextTile == '🌫️') {
      maze[newRow][newCol] = '⬛';
      print("🕳️ Vanishing tile! Fog tile became wall.");
    }

    return true;
  }

  bool isAtExit() => playerRow == goalRow && playerCol == goalCol;

  int getLevel() {
    int total = maze.length * maze[0].length;
    if (total >= 100) return 3;
    if (total >= 36) return 2;
    return 1;
  }

  bool hasCollectedAllSigils() => collectedSigils.containsAll(requiredSigils);
}
