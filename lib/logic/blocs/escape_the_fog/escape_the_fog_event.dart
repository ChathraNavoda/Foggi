import 'package:equatable/equatable.dart';

abstract class EscapeTheFogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEscapeGame extends EscapeTheFogEvent {}

class SubmitPlayerMove extends EscapeTheFogEvent {
  final String direction;

  SubmitPlayerMove(this.direction);

  @override
  List<Object?> get props => [direction];
}

class RestartEscapeGame extends EscapeTheFogEvent {}

class RestartFromBeginning extends EscapeTheFogEvent {}
