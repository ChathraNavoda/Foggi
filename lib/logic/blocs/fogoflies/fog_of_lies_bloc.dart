import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/fogoflies/fog_of_lies_models.dart';
import '../../../data/models/riddle.dart';
import 'fog_of_lies_event.dart';
import 'fog_of_lies_state.dart';

class FogOfLiesBloc extends Bloc<FogOfLiesEvent, FogOfLiesState> {
  late FogOfLiesPlayer _player1;
  late FogOfLiesPlayer _player2;

  FogOfLiesPlayer get player1 => _player1;
  FogOfLiesPlayer get player2 => _player2;

  int _round = 0;
  int _scoreP1 = 0;
  int _scoreP2 = 0;

  final List<FogOfLiesRound> _roundHistory = [];

  List<FogOfLiesRound> get roundHistory => _roundHistory;

  FogOfLiesBloc() : super(FogOfLiesInitial()) {
    on<StartFogOfLiesGame>(_onStartGame);
    on<SubmitFakeAnswer>(_onFakeAnswer);
    on<SubmitGuess>(_onGuess);
    on<NextFogOfLiesRound>(_onNextRound);
  }

  void _onStartGame(StartFogOfLiesGame event, Emitter<FogOfLiesState> emit) {
    _player1 = event.player1;
    _player2 = event.player2;
    _round = 0;
    _scoreP1 = 0;
    _scoreP2 = 0;
    _startRound(emit);
  }

  void _startRound(Emitter<FogOfLiesState> emit) {
    final riddler = _round % 2 == 0 ? _player1 : _player2;
    final guesser = _round % 2 == 0 ? _player2 : _player1;
    final riddle = RiddleRepository().getRiddles(count: 1).first;

    emit(FogOfLiesInProgress(
      currentRiddler: riddler,
      currentGuesser: guesser,
      riddle: riddle.question,
      correctAnswer: riddle.answer,
    ));
  }

  void _onFakeAnswer(SubmitFakeAnswer event, Emitter<FogOfLiesState> emit) {
    final current = state as FogOfLiesInProgress;
    emit(FogOfLiesInProgress(
      currentRiddler: current.currentRiddler,
      currentGuesser: current.currentGuesser,
      riddle: current.riddle,
      correctAnswer: current.correctAnswer,
      fakeAnswer: event.fakeAnswer,
    ));
  }

  void _onGuess(SubmitGuess event, Emitter<FogOfLiesState> emit) {
    final current = state as FogOfLiesInProgress;
    final isCorrect = event.chosenAnswer == current.correctAnswer;
    print(
        "Riddler: ${current.currentRiddler.name}, Guesser: ${current.currentGuesser.name}, IsCorrect: $isCorrect");

    if (isCorrect) {
      if (current.currentGuesser.uid == _player1.uid) {
        _scoreP1++;
      } else {
        _scoreP2++;
      }
    }

    emit(FogOfLiesRoundResult(
      isCorrect: isCorrect,
      correctAnswer: current.correctAnswer,
      fakeAnswer: current.fakeAnswer ?? '',
      chosenAnswer: event.chosenAnswer,
    ));

    _roundHistory.add(FogOfLiesRound(
      riddle: current.riddle,
      correctAnswer: current.correctAnswer,
      fakeAnswer: current.fakeAnswer ?? '',
      chosenAnswer: event.chosenAnswer,
      isCorrect: isCorrect,
    ));
  }

  void _onNextRound(NextFogOfLiesRound event, Emitter<FogOfLiesState> emit) {
    _round++;
    if (_round >= 6) {
      emit(FogOfLiesGameOver({
        _player1.uid: _scoreP1,
        _player2.uid: _scoreP2,
      }, _roundHistory));
    } else {
      _startRound(emit);
    }
  }
}
