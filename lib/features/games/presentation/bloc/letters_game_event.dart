part of 'letters_game_bloc.dart';

abstract class LettersGameEvent {
  const LettersGameEvent();
}

class InitializeGame extends LettersGameEvent {
  const InitializeGame();
}

class SelectLetter extends LettersGameEvent {
  final String letter;

  const SelectLetter(this.letter);
}

class MoveToNextQuestion extends LettersGameEvent {
  const MoveToNextQuestion();
}

class RestartGame extends LettersGameEvent {
  const RestartGame();
}
