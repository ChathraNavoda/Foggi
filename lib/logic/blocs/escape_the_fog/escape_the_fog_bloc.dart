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

  void _onStartGame(StartEscapeGame event, Emitter emit) {
    _puzzle = EscapePuzzle.generate(); // generate new puzzle
    emit(EscapeInProgress(
      puzzle: _puzzle!,
      playerMoves: [],
      reachedExit: false,
    ));
  }

  void _onSubmitMove(SubmitPlayerMove event, Emitter emit) {
    final currentState = state;
    if (currentState is! EscapeInProgress || _puzzle == null) return;

    // Move player
    _puzzle!.movePlayer(event.direction);

    final newMoves = List<String>.from(currentState.playerMoves)
      ..add(event.direction);

    final reachedExit = _puzzle!.isAtExit();
    final isWrongPath =
        _puzzle!.isWrongPath(_puzzle!.playerRow, _puzzle!.playerCol);

    if (reachedExit) {
      emit(EscapeInProgress(
        puzzle: _puzzle!,
        playerMoves: newMoves,
        reachedExit: true,
      ));
      emit(EscapeSuccess());
    } else if (isWrongPath) {
      emit(EscapeInProgress(
        puzzle: _puzzle!,
        playerMoves: newMoves,
        reachedExit: false,
        wrongPath: true,
      ));
      emit(EscapeFailure("You got lost in the fog!"));
    } else {
      emit(EscapeInProgress(
        puzzle: _puzzle!,
        playerMoves: newMoves,
        reachedExit: false,
      ));
    }
  }

  void _onRestartGame(RestartEscapeGame event, Emitter emit) {
    add(StartEscapeGame());
  }
}
