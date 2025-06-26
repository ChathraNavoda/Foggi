import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/string_extensions.dart';
import '../../../data/models/riddle.dart';
import '../../../presentation/widgets/prompt_display_name.dart';
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
    on<Tick>((event, emit) {
      if (state is RiddleInProgress) {
        emit((state as RiddleInProgress)
            .copyWith(secondsLeft: event.secondsLeft));
      }
    });
    on<ReturnToMenu>((event, emit) {
      _timer?.cancel();
      emit(RiddleInitial());
    });
  }

  Future<void> _onStartGame(
      StartGame event, Emitter<RiddleGameState> emit) async {
    _riddles = List<Riddle>.from(riddleRepository.getRiddles())..shuffle();
    _currentIndex = 0;
    _score = 0;

    emit(RiddleInProgress(
      currentRiddle: _riddles[_currentIndex],
      index: _currentIndex,
      total: _riddles.length,
      score: _score,
      secondsLeft: riddleTimeLimit.inSeconds,
    ));

    _startTimer();
  }

  Future<void> _onSubmitAnswer(
      SubmitAnswer event, Emitter<RiddleGameState> emit) async {
    final current = _riddles[_currentIndex];
    _timer?.cancel();

    final userInput = normalize(event.answer);
    final correct = normalize(current.answer);

    if (userInput == correct) {
      emit(RiddleCorrect(score: _score += 1));
    } else {
      emit(RiddleWrong(correctAnswer: current.answer));
    }
  }

  Future<void> _onTimeUp(TimeUp event, Emitter<RiddleGameState> emit) async {
    emit(RiddleWrong(correctAnswer: _riddles[_currentIndex].answer));
  }

  Future<void> _onNextRiddle(
      NextRiddle event, Emitter<RiddleGameState> emit) async {
    if (_currentIndex + 1 < _riddles.length) {
      _currentIndex++;

      emit(RiddleInProgress(
        currentRiddle: _riddles[_currentIndex],
        index: _currentIndex,
        total: _riddles.length,
        score: _score,
        secondsLeft: riddleTimeLimit.inSeconds,
      ));

      _startTimer();
    } else {
      emit(RiddleGameOver(score: _score, total: _riddles.length));
      await _promptDisplayNameIfNeeded();
      await _saveScoreToFirestore();
    }
  }

  Future<void> _promptDisplayNameIfNeeded() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        (user.displayName == null || user.displayName!.isEmpty)) {
      final container = ProviderContainer();
      container.read(displayNamePromptProvider.notifier).state = true;
    }
  }

  Future<void> _saveScoreToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userSnapshot = await userDocRef.get();
    final userData = userSnapshot.data();

    final avatar = userData?['avatar'] ?? '👻';
    final previousBest = userData?['bestScore'] ?? 0;

    // ✅ Save/update user profile and nested scores
    await userDocRef.set({
      'displayName': user.displayName ?? 'Anonymous',
      'email': user.email ?? '',
      'avatar': avatar,
      'bestScore': _score > previousBest ? _score : previousBest,
      'scores': FieldValue.arrayUnion([
        {
          'score': _score,
          'date': DateTime.now().toIso8601String(),
        },
      ]),
    }, SetOptions(merge: true));

    // ✅ Save to global leaderboard collection with avatar
    await FirebaseFirestore.instance.collection('leaderboard').add({
      'uid': user.uid,
      'displayName': user.displayName ?? 'Anonymous',
      'avatar': avatar,
      'score': _score,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _onRestartGame(
      RestartGame event, Emitter<RiddleGameState> emit) async {
    add(StartGame());
  }

  void _startTimer() {
    int seconds = riddleTimeLimit.inSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;

      if (seconds <= 0) {
        timer.cancel();
        add(TimeUp());
      } else if (state is RiddleInProgress) {
        if (!isClosed) {
          add(Tick(seconds));
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
