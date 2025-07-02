import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/escape_the_fog/escape_puzzle.dart';
import 'escape_the_fog_event.dart';
import 'escape_the_fog_state.dart';

class EscapeTheFogBloc extends Bloc<EscapeTheFogEvent, EscapeTheFogState> {
  EscapePuzzle? _puzzle;

  EscapeTheFogBloc() : super(EscapeInitial()) {
    on<StartEscapeGame>(_onStartGame);
    on<SubmitPlayerMove>(_onSubmitMove);
    on<RestartEscapeGame>(_onRestartGame);
  }

  void _onStartGame(StartEscapeGame event, Emitter<EscapeTheFogState> emit) {
    _puzzle = EscapePuzzle.generate();
    print("🆕 Game started. Maze ready.");
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

    print("🎮 Move submitted: ${event.direction}");
    final moveSuccess = _puzzle!.attemptMovePlayer(event.direction);
    final newMoves = List<String>.from(currentState.playerMoves)
      ..add(event.direction);

    print("🧍 Position: (${_puzzle!.playerRow}, ${_puzzle!.playerCol})");
    print("🧿 Score: ${_puzzle!.score} / ${_puzzle!.requiredScore}");

    if (!moveSuccess) {
      print("🚫 Invalid move. Shaking.");
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

    final reachedExit = _puzzle!.isAtExit();

    if (reachedExit && _puzzle!.score >= _puzzle!.requiredScore) {
      emit(EscapeSuccess());
    } else if (reachedExit) {
      emit(EscapeFailure("You found the door but lack enough power!"));
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
    print("🔁 Restarting...");
    add(StartEscapeGame());
  }
}
