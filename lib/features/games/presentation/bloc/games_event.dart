part of 'games_bloc.dart';

abstract class GamesEvent {
  const GamesEvent();
}

class InitializeLettersGame extends GamesEvent {
  const InitializeLettersGame();
}

class InitializeNumbersGame extends GamesEvent {
  const InitializeNumbersGame();
}

class InitializeColorsGame extends GamesEvent {
  const InitializeColorsGame();
}

class InitializeMatchingGame extends GamesEvent {
  const InitializeMatchingGame();
}

class SelectLetter extends GamesEvent {
  final String letter;

  const SelectLetter(this.letter);
}

class SelectNumber extends GamesEvent {
  final int number;

  const SelectNumber(this.number);
}

class SelectColor extends GamesEvent {
  final String color;

  const SelectColor(this.color);
}

class SelectMatch extends GamesEvent {
  final String match;
  final int index;

  const SelectMatch(this.match, this.index);
}

class MoveToNextQuestion extends GamesEvent {
  const MoveToNextQuestion();
}

class ResetMatchingSelection extends GamesEvent {
  const ResetMatchingSelection();
}

class RestartGame extends GamesEvent {
  const RestartGame();
}
