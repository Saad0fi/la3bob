import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'numbers_game_event.dart';
part 'numbers_game_state.dart';

class NumbersGameBloc extends Bloc<NumbersGameEvent, NumbersGameState> {
  static const List<Map<String, dynamic>> _questions = [
    {
      'count': 1,
      'options': [1, 2, 3, 4],
    },
    {
      'count': 2,
      'options': [2, 3, 4, 5],
    },
    {
      'count': 3,
      'options': [3, 4, 5, 6],
    },
    {
      'count': 4,
      'options': [2, 3, 4, 5],
    },
    {
      'count': 5,
      'options': [4, 5, 6, 7],
    },
    {
      'count': 6,
      'options': [5, 6, 7, 8],
    },
    {
      'count': 7,
      'options': [6, 7, 8, 9],
    },
    {
      'count': 8,
      'options': [7, 8, 9, 10],
    },
    {
      'count': 9,
      'options': [8, 9, 10, 11],
    },
    {
      'count': 10,
      'options': [9, 10, 11, 12],
    },
  ];

  NumbersGameBloc() : super(NumbersGameInitial()) {
    on<InitializeNumbersGame>(_onInitializeGame);
    on<SelectNumber>(_onSelectNumber);
    on<MoveToNextNumbersQuestion>(_onMoveToNextQuestion);
    on<RestartNumbersGame>(_onRestartGame);
  }

  void _onInitializeGame(
    InitializeNumbersGame event,
    Emitter<NumbersGameState> emit,
  ) {
    final shuffledQuestions = _questions
        .map((q) => Map<String, dynamic>.from(q))
        .toList();
    _shuffleOptions(shuffledQuestions);

    emit(NumbersGameLoaded(
      questions: shuffledQuestions,
      currentQuestionIndex: 0,
      score: 0,
      selectedNumber: null,
      showResult: false,
      isCorrect: false,
    ));
  }

  void _onSelectNumber(
    SelectNumber event,
    Emitter<NumbersGameState> emit,
  ) {
    if (state is! NumbersGameLoaded) return;

    final currentState = state as NumbersGameLoaded;
    if (currentState.showResult) return;

    final question = currentState.questions[currentState.currentQuestionIndex];
    final isCorrect = event.number == question['count'];
    final newScore = isCorrect ? currentState.score + 1 : currentState.score;

    emit(NumbersGameLoaded(
      questions: currentState.questions,
      currentQuestionIndex: currentState.currentQuestionIndex,
      score: newScore,
      selectedNumber: event.number,
      showResult: true,
      isCorrect: isCorrect,
    ));
  }

  void _onMoveToNextQuestion(
    MoveToNextNumbersQuestion event,
    Emitter<NumbersGameState> emit,
  ) {
    if (state is! NumbersGameLoaded) return;

    final currentState = state as NumbersGameLoaded;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      emit(NumbersGameLoaded(
        questions: currentState.questions,
        currentQuestionIndex: currentState.currentQuestionIndex + 1,
        score: currentState.score,
        selectedNumber: null,
        showResult: false,
        isCorrect: false,
      ));
    } else {
      final lastQuestionIndex = currentState.currentQuestionIndex;
      emit(NumbersGameCompleted(
        score: currentState.score,
        totalQuestions: currentState.questions.length,
        questions: currentState.questions,
        lastQuestion: currentState.questions[lastQuestionIndex],
      ));
    }
  }

  void _onRestartGame(
    RestartNumbersGame event,
    Emitter<NumbersGameState> emit,
  ) {
    final shuffledQuestions = _questions
        .map((q) => Map<String, dynamic>.from(q))
        .toList();
    _shuffleOptions(shuffledQuestions);

    emit(NumbersGameLoaded(
      questions: shuffledQuestions,
      currentQuestionIndex: 0,
      score: 0,
      selectedNumber: null,
      showResult: false,
      isCorrect: false,
    ));
  }

  void _shuffleOptions(List<Map<String, dynamic>> questions) {
    for (var question in questions) {
      final options = List<int>.from(question['options'] as List);
      options.shuffle(Random());
      question['options'] = options;
    }
  }
}

