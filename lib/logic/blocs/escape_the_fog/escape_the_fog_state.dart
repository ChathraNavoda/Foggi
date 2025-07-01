import 'package:equatable/equatable.dart';

import '../../../data/models/escape_the_fog/escape_puzzle.dart';

abstract class EscapeTheFogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EscapeInitial extends EscapeTheFogState {}

class EscapeInProgress extends EscapeTheFogState {
  final EscapePuzzle puzzle;
  final List<String> playerMoves; // e.g. ['down', 'right']
  final bool reachedExit;
  final bool wrongPath;

  EscapeInProgress({
    required this.puzzle,
    required this.playerMoves,
    required this.reachedExit,
    this.wrongPath = false,
  });

  @override
  List<Object?> get props => [puzzle, playerMoves, reachedExit, wrongPath];
}

class EscapeSuccess extends EscapeTheFogState {}

class EscapeFailure extends EscapeTheFogState {
  final String reason;

  EscapeFailure(this.reason);

  @override
  List<Object?> get props => [reason];
}
