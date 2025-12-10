part of 'numbers_game_bloc.dart';

abstract class NumbersGameState {
  const NumbersGameState();
}

class NumbersGameInitial extends NumbersGameState {
  const NumbersGameInitial();
}

class NumbersGameLoaded extends NumbersGameState {
  final List<Map<String, dynamic>> questions;
  final int currentQuestionIndex;
  final int score;
  final int? selectedNumber;
  final bool showResult;
  final bool isCorrect;

  const NumbersGameLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
    this.selectedNumber,
    required this.showResult,
    required this.isCorrect,
  });
}

class NumbersGameCompleted extends NumbersGameState {
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> questions;
  final Map<String, dynamic> lastQuestion;

  const NumbersGameCompleted({
    required this.score,
    required this.totalQuestions,
    required this.questions,
    required this.lastQuestion,
  });
}

