class FogOfLiesPlayer {
  final String uid;
  final String name;
  final String avatar;

  FogOfLiesPlayer({
    required this.uid,
    required this.name,
    required this.avatar,
  });
}

class FogOfLiesRound {
  final String riddle;
  final String correctAnswer;
  final String fakeAnswer;
  final String chosenAnswer; // by the guesser
  final bool isCorrect;

  FogOfLiesRound({
    required this.riddle,
    required this.correctAnswer,
    required this.fakeAnswer,
    required this.chosenAnswer,
    required this.isCorrect,
  });
}
