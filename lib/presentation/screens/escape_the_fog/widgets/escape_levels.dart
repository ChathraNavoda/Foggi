class EscapeLevel {
  final int level;
  final int rows;
  final int cols;
  final int minScoreToEscape;

  EscapeLevel({
    required this.level,
    required this.rows,
    required this.cols,
    required this.minScoreToEscape,
  });
}

final List<EscapeLevel> escapeLevels = [
  EscapeLevel(level: 1, rows: 5, cols: 5, minScoreToEscape: 20),
  EscapeLevel(level: 2, rows: 8, cols: 8, minScoreToEscape: 25),
  EscapeLevel(level: 3, rows: 10, cols: 10, minScoreToEscape: 30),
];
