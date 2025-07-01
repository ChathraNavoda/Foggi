import '../../../data/models/fogoflies/fog_of_lies_models.dart';

abstract class FogOfLiesState {}

class FogOfLiesInitial extends FogOfLiesState {}

class FogOfLiesInProgress extends FogOfLiesState {
  final FogOfLiesPlayer currentRiddler;
  final FogOfLiesPlayer currentGuesser;
  final String riddle;
  final String correctAnswer;
  final String? fakeAnswer;
  final String? chosenAnswer;

  FogOfLiesInProgress({
    required this.currentRiddler,
    required this.currentGuesser,
    required this.riddle,
    required this.correctAnswer,
    this.fakeAnswer,
    this.chosenAnswer,
  });
}

class FogOfLiesRoundResult extends FogOfLiesState {
  final bool isCorrect;
  final String correctAnswer;
  final String fakeAnswer;
  final String chosenAnswer;
  final String guesserUid;

  FogOfLiesRoundResult({
    required this.isCorrect,
    required this.correctAnswer,
    required this.fakeAnswer,
    required this.chosenAnswer,
    required this.guesserUid,
  });
}

class FogOfLiesGameOver extends FogOfLiesState {
  final Map<String, int> scores;
  final List<FogOfLiesRound> rounds;

  FogOfLiesGameOver(this.scores, this.rounds);
}
