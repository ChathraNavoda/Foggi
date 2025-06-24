import 'package:equatable/equatable.dart';

abstract class RiddleGameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartGame extends RiddleGameEvent {}

class SubmitAnswer extends RiddleGameEvent {
  final String answer;

  SubmitAnswer(this.answer);

  @override
  List<Object?> get props => [answer];
}

class TimeUp extends RiddleGameEvent {}

class NextRiddle extends RiddleGameEvent {}

class RestartGame extends RiddleGameEvent {}
