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

class MoveToNextQuestion extends GamesEvent {
  const MoveToNextQuestion();
}

class RestartGame extends GamesEvent {
  const RestartGame();
}
