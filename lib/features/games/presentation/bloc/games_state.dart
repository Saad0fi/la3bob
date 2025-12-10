part of 'games_bloc.dart';

abstract class GamesState {
  const GamesState();
}

class GamesInitial extends GamesState {
  const GamesInitial();
}

class GameLoaded extends GamesState {
  final GameType gameType;
  final List<Map<String, dynamic>> questions;
  final int currentQuestionIndex;
  final int score;
  final String? selectedLetter;
  final int? selectedNumber;
  final bool showResult;
  final bool isCorrect;

  const GameLoaded({
    required this.gameType,
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
    this.selectedLetter,
    this.selectedNumber,
    required this.showResult,
    required this.isCorrect,
  });
}

class GameCompleted extends GamesState {
  final GameType gameType;
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> questions;
  final Map<String, dynamic> lastQuestion;

  const GameCompleted({
    required this.gameType,
    required this.score,
    required this.totalQuestions,
    required this.questions,
    required this.lastQuestion,
  });
}
