part of 'numbers_game_bloc.dart';

abstract class NumbersGameEvent {
  const NumbersGameEvent();
}

class InitializeNumbersGame extends NumbersGameEvent {
  const InitializeNumbersGame();
}

class SelectNumber extends NumbersGameEvent {
  final int number;

  const SelectNumber(this.number);
}

class MoveToNextNumbersQuestion extends NumbersGameEvent {
  const MoveToNextNumbersQuestion();
}

class RestartNumbersGame extends NumbersGameEvent {
  const RestartNumbersGame();
}

