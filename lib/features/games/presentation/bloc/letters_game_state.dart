part of 'letters_game_bloc.dart';

abstract class LettersGameState {
  const LettersGameState();
}

class LettersGameInitial extends LettersGameState {
  const LettersGameInitial();
}

class LettersGameLoaded extends LettersGameState {
  final List<Map<String, dynamic>> questions;
  final int currentQuestionIndex;
  final int score;
  final String? selectedLetter;
  final bool showResult;
  final bool isCorrect;

  const LettersGameLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
    this.selectedLetter,
    required this.showResult,
    required this.isCorrect,
  });
}

class LettersGameCompleted extends LettersGameState {
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> questions;
  final Map<String, dynamic> lastQuestion;

  const LettersGameCompleted({
    required this.score,
    required this.totalQuestions,
    required this.questions,
    required this.lastQuestion,
  });
}
