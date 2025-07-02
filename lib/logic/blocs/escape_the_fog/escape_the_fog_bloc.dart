import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/escape_the_fog/escape_puzzle.dart';
import 'escape_the_fog_event.dart';
import 'escape_the_fog_state.dart';

class EscapeTheFogBloc extends Bloc<EscapeTheFogEvent, EscapeTheFogState> {
  EscapePuzzle? _puzzle;
  final int minScoreToEscape;
  int currentLevel = 1;
  bool level2Unlocked = false;

  EscapeTheFogBloc({required this.minScoreToEscape}) : super(EscapeInitial()) {
    on<StartEscapeGame>(_onStartGame);
    on<SubmitPlayerMove>(_onSubmitMove);
    on<RestartEscapeGame>(_onRestartGame);
  }

  void _onStartGame(StartEscapeGame event, Emitter<EscapeTheFogState> emit) {
    final rows = currentLevel == 1 ? 5 : 8;
    final cols = currentLevel == 1 ? 5 : 8;

    _puzzle = EscapePuzzle.generate(rows: rows, cols: cols);
    emit(EscapeInProgress(
      puzzle: _puzzle!,
      playerMoves: [],
      reachedExit: false,
    ));
  }

  Future<void> _onSubmitMove(
      SubmitPlayerMove event, Emitter<EscapeTheFogState> emit) async {
    final currentState = state;
    if (currentState is! EscapeInProgress || _puzzle == null) return;

    final moveSuccess = _puzzle!.attemptMovePlayer(event.direction);
    final newMoves = List<String>.from(currentState.playerMoves)
      ..add(event.direction);
    final reachedExit = _puzzle!.isAtExit();
    final score = _puzzle!.score;

    if (!moveSuccess) {
      emit(EscapeInProgress(
        puzzle: _puzzle!,
        playerMoves: newMoves,
        reachedExit: false,
        wrongPath: true,
      ));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(EscapeInProgress(
        puzzle: _puzzle!,
        playerMoves: newMoves,
        reachedExit: false,
        wrongPath: false,
      ));
      return;
    }

    if (reachedExit) {
      if (score >= minScoreToEscape) {
        if (currentLevel == 1) level2Unlocked = true;
        emit(EscapeSuccess());
      } else {
        emit(EscapeFailure("You reached the door but your score is too low!"));
      }
    } else {
      emit(EscapeInProgress(
        puzzle: _puzzle!,
        playerMoves: newMoves,
        reachedExit: false,
      ));
    }
  }

  void _onRestartGame(
      RestartEscapeGame event, Emitter<EscapeTheFogState> emit) {
    add(StartEscapeGame());
  }
}
