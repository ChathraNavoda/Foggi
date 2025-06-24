import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../data/models/riddle.dart';
import 'riddle_game_event.dart';
import 'riddle_game_state.dart';

class RiddleGameBloc extends Bloc<RiddleGameEvent, RiddleGameState> {
  final RiddleRepository riddleRepository;
  late List<Riddle> _riddles;
  int _currentIndex = 0;
  int _score = 0;
  Timer? _timer;

  static const riddleTimeLimit = Duration(seconds: 20);

  RiddleGameBloc({required this.riddleRepository}) : super(RiddleInitial()) {
    on<StartGame>(_onStartGame);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<TimeUp>(_onTimeUp);
    on<NextRiddle>(_onNextRiddle);
    on<RestartGame>(_onRestartGame);
  }

  void _onStartGame(StartGame event, Emitter<RiddleGameState> emit) {
    _riddles = riddleRepository.getRiddles();
    _currentIndex = 0;
    _score = 0;
    _startTimer(emit);
    emit(RiddleInProgress(
      currentRiddle: _riddles[_currentIndex],
      index: _currentIndex,
      total: _riddles.length,
      score: _score,
      secondsLeft: riddleTimeLimit.inSeconds,
    ));
  }

  void _onSubmitAnswer(SubmitAnswer event, Emitter<RiddleGameState> emit) {
    final current = _riddles[_currentIndex];
    _timer?.cancel();

    if (event.answer.trim().toLowerCase() == current.answer.toLowerCase()) {
      _score++;
      emit(RiddleCorrect(score: _score));
    } else {
      emit(RiddleWrong(correctAnswer: current.answer));
    }
  }

  void _onTimeUp(TimeUp event, Emitter<RiddleGameState> emit) {
    emit(RiddleWrong(correctAnswer: _riddles[_currentIndex].answer));
  }

  void _onNextRiddle(NextRiddle event, Emitter<RiddleGameState> emit) {
    if (_currentIndex + 1 < _riddles.length) {
      _currentIndex++;
      _startTimer(emit);
      emit(RiddleInProgress(
        currentRiddle: _riddles[_currentIndex],
        index: _currentIndex,
        total: _riddles.length,
        score: _score,
        secondsLeft: riddleTimeLimit.inSeconds,
      ));
    } else {
      emit(RiddleGameOver(score: _score, total: _riddles.length));
    }
  }

  void _onRestartGame(RestartGame event, Emitter<RiddleGameState> emit) {
    add(StartGame());
  }

  void _startTimer(Emitter<RiddleGameState> emit) {
    int seconds = riddleTimeLimit.inSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds <= 0) {
        timer.cancel();
        add(TimeUp());
      } else {
        if (state is RiddleInProgress) {
          emit((state as RiddleInProgress).copyWith(secondsLeft: seconds));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
