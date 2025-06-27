class RiddleResult {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final Duration timeTaken;

  RiddleResult({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.timeTaken,
  });
}
