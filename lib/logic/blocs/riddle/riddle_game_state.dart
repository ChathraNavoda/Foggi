import 'package:equatable/equatable.dart';

import '../../../data/models/riddle.dart';

abstract class RiddleGameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RiddleInitial extends RiddleGameState {}

class RiddleInProgress extends RiddleGameState {
  final Riddle currentRiddle;
  final int index;
  final int total;
  final int score;
  final int secondsLeft;

  RiddleInProgress({
    required this.currentRiddle,
    required this.index,
    required this.total,
    required this.score,
    required this.secondsLeft,
  });

  RiddleInProgress copyWith({
    Riddle? currentRiddle,
    int? index,
    int? total,
    int? score,
    int? secondsLeft,
  }) {
    return RiddleInProgress(
      currentRiddle: currentRiddle ?? this.currentRiddle,
      index: index ?? this.index,
      total: total ?? this.total,
      score: score ?? this.score,
      secondsLeft: secondsLeft ?? this.secondsLeft,
    );
  }

  @override
  List<Object?> get props => [currentRiddle, index, total, score, secondsLeft];
}

class RiddleCorrect extends RiddleGameState {
  final int score;

  RiddleCorrect({required this.score});

  @override
  List<Object?> get props => [score];
}

class RiddleWrong extends RiddleGameState {
  final String correctAnswer;

  RiddleWrong({required this.correctAnswer});

  @override
  List<Object?> get props => [correctAnswer];
}

class RiddleGameOver extends RiddleGameState {
  final int score;
  final int total;

  RiddleGameOver({required this.score, required this.total});

  @override
  List<Object?> get props => [score, total];
}
