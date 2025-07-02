import '../../../data/models/escape_the_fog/escape_puzzle.dart';

abstract class EscapeTheFogState {}

class EscapeInitial extends EscapeTheFogState {}

class EscapeInProgress extends EscapeTheFogState {
  final EscapePuzzle puzzle;
  final List<String> playerMoves;
  final bool reachedExit;
  final bool wrongPath;

  EscapeInProgress({
    required this.puzzle,
    required this.playerMoves,
    required this.reachedExit,
    this.wrongPath = false,
  });

  EscapeInProgress copyWith({
    EscapePuzzle? puzzle,
    List<String>? playerMoves,
    bool? reachedExit,
    bool? wrongPath,
  }) {
    return EscapeInProgress(
      puzzle: puzzle ?? this.puzzle,
      playerMoves: playerMoves ?? this.playerMoves,
      reachedExit: reachedExit ?? this.reachedExit,
      wrongPath: wrongPath ?? this.wrongPath,
    );
  }
}

class EscapeSuccess extends EscapeTheFogState {}

class EscapeTreasure extends EscapeTheFogState {}

class EscapeFailure extends EscapeTheFogState {
  final String reason;
  EscapeFailure(this.reason);
}
