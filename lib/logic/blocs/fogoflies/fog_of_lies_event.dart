import '../../../data/models/fogoflies/fog_of_lies_models.dart';

abstract class FogOfLiesEvent {}

class StartFogOfLiesGame extends FogOfLiesEvent {
  final FogOfLiesPlayer player1;
  final FogOfLiesPlayer player2;

  StartFogOfLiesGame({required this.player1, required this.player2});
}

class SubmitFakeAnswer extends FogOfLiesEvent {
  final String fakeAnswer;

  SubmitFakeAnswer({required this.fakeAnswer});
}

class SubmitGuess extends FogOfLiesEvent {
  final String chosenAnswer;

  SubmitGuess({required this.chosenAnswer});
}

class NextFogOfLiesRound extends FogOfLiesEvent {}
