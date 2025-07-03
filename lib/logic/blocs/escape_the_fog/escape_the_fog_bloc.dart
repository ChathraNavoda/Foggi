// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../data/models/escape_the_fog/escape_puzzle.dart';
// import '../../../presentation/screens/escape_the_fog/widgets/escape_levels.dart';
// import 'escape_the_fog_event.dart';
// import 'escape_the_fog_state.dart';

// class EscapeTheFogBloc extends Bloc<EscapeTheFogEvent, EscapeTheFogState> {
//   EscapePuzzle? _puzzle;
//   final int minScoreToEscape;
//   int currentLevel = 1;

//   EscapeTheFogBloc({required this.minScoreToEscape}) : super(EscapeInitial()) {
//     on<StartEscapeGame>(_onStartGame);
//     on<SubmitPlayerMove>(_onSubmitMove);
//     on<RestartEscapeGame>(_onRestartGame);
//   }

//   void _onStartGame(StartEscapeGame event, Emitter<EscapeTheFogState> emit) {
//     final levelDef = escapeLevels[currentLevel - 1];
//     _puzzle = EscapePuzzle.generate(
//       rows: levelDef.rows,
//       cols: levelDef.cols,
//       level: currentLevel,
//     );
//     emit(EscapeInProgress(
//       puzzle: _puzzle!,
//       playerMoves: [],
//       reachedExit: false,
//     ));
//   }

//   Future<void> _onSubmitMove(
//     SubmitPlayerMove event,
//     Emitter<EscapeTheFogState> emit,
//   ) async {
//     final currentState = state;
//     if (currentState is! EscapeInProgress || _puzzle == null) return;

//     final moveSuccess = _puzzle!.attemptMovePlayer(event.direction);
//     final newMoves = List<String>.from(currentState.playerMoves)
//       ..add(event.direction);

//     if (!moveSuccess) {
//       emit(currentState.copyWith(wrongPath: true, playerMoves: newMoves));
//       await Future.delayed(const Duration(milliseconds: 300));
//       emit(currentState.copyWith(wrongPath: false, playerMoves: newMoves));
//       return;
//     }

//     final reachedExit = _puzzle!.isAtExit();
//     final score = _puzzle!.score;

//     if (reachedExit) {
//       if (score >= minScoreToEscape) {
//         if (currentLevel < 3) {
//           currentLevel++;
//           emit(EscapeSuccess());
//         } else {
//           emit(EscapeTreasure());
//         }
//       } else {
//         emit(EscapeFailure("Score too low to escape! Need $minScoreToEscape"));
//       }
//     } else {
//       emit(EscapeInProgress(
//         puzzle: _puzzle!,
//         playerMoves: newMoves,
//         reachedExit: false,
//       ));
//     }
//   }

//   void _onRestartGame(
//       RestartEscapeGame event, Emitter<EscapeTheFogState> emit) {
//     currentLevel = 1;
//     add(StartEscapeGame());
//   }
// // }
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/escape_the_fog/escape_puzzle.dart';
import '../../../presentation/screens/escape_the_fog/widgets/escape_levels.dart';
import 'escape_the_fog_event.dart';
import 'escape_the_fog_state.dart';

class EscapeTheFogBloc extends Bloc<EscapeTheFogEvent, EscapeTheFogState> {
  EscapePuzzle? _puzzle;
  final int minScoreToEscape;
  int currentLevel = 1;

  EscapeTheFogBloc({required this.minScoreToEscape}) : super(EscapeInitial()) {
    on<StartEscapeGame>(_onStartGame);
    on<SubmitPlayerMove>(_onSubmitMove);
    on<RestartEscapeGame>(_onRestartGame);
    on<RestartFromBeginning>(_onRestartFromBeginning);
  }

  void _onStartGame(StartEscapeGame event, Emitter<EscapeTheFogState> emit) {
    final levelDef = escapeLevels[currentLevel - 1];
    _puzzle = EscapePuzzle.generate(
      rows: levelDef.rows,
      cols: levelDef.cols,
      level: currentLevel,
    );
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

    if (!moveSuccess) {
      emit(currentState.copyWith(wrongPath: true, playerMoves: newMoves));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(currentState.copyWith(wrongPath: false, playerMoves: newMoves));
      return;
    }

    final reachedExit = _puzzle!.isAtExit();
    final score = _puzzle!.score;

    if (reachedExit) {
      if (score >= minScoreToEscape) {
        if (currentLevel < escapeLevels.length) {
          currentLevel++;
          emit(EscapeSuccess());
        } else {
          emit(EscapeTreasure());
        }
      } else {
        emit(EscapeFailure("Score too low to escape! Need $minScoreToEscape"));
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

  void _onRestartFromBeginning(
      RestartFromBeginning event, Emitter<EscapeTheFogState> emit) {
    currentLevel = 1;
    add(StartEscapeGame());
  }
}
