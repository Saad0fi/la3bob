import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'letters_game_event.dart';
part 'letters_game_state.dart';

class LettersGameBloc extends Bloc<LettersGameEvent, LettersGameState> {
  static const List<Map<String, dynamic>> _questions = [
    {
      'word': 'تفاحة',
      'letter': 'ت',
      'options': ['ت', 'ب', 'ر', 'س'],
    },
    {
      'word': 'بطة',
      'letter': 'ب',
      'options': ['ب', 'ت', 'ج', 'د'],
    },
    {
      'word': 'جمل',
      'letter': 'ج',
      'options': ['ج', 'ح', 'خ', 'د'],
    },
    {
      'word': 'دب',
      'letter': 'د',
      'options': ['د', 'ذ', 'ر', 'ز'],
    },
    {
      'word': 'رمان',
      'letter': 'ر',
      'options': ['ر', 'ز', 'س', 'ش'],
    },
    {
      'word': 'سمكة',
      'letter': 'س',
      'options': ['س', 'ش', 'ص', 'ض'],
    },
    {
      'word': 'شمس',
      'letter': 'ش',
      'options': ['ش', 'ص', 'ض', 'ط'],
    },
    {
      'word': 'طائرة',
      'letter': 'ط',
      'options': ['ط', 'ظ', 'ع', 'غ'],
    },
    {
      'word': 'عصفور',
      'letter': 'ع',
      'options': ['ع', 'غ', 'ف', 'ق'],
    },
    {
      'word': 'فيل',
      'letter': 'ف',
      'options': ['ف', 'ق', 'ك', 'ل'],
    },
  ];

  LettersGameBloc() : super(LettersGameInitial()) {
    on<InitializeGame>(_onInitializeGame);
    on<SelectLetter>(_onSelectLetter);
    on<MoveToNextQuestion>(_onMoveToNextQuestion);
    on<RestartGame>(_onRestartGame);
  }

  void _onInitializeGame(
    InitializeGame event,
    Emitter<LettersGameState> emit,
  ) {
    final shuffledQuestions = _questions
        .map((q) => Map<String, dynamic>.from(q))
        .toList();
    _shuffleOptions(shuffledQuestions);

    emit(LettersGameLoaded(
      questions: shuffledQuestions,
      currentQuestionIndex: 0,
      score: 0,
      selectedLetter: null,
      showResult: false,
      isCorrect: false,
    ));
  }

  void _onSelectLetter(
    SelectLetter event,
    Emitter<LettersGameState> emit,
  ) {
    if (state is! LettersGameLoaded) return;
    
    final currentState = state as LettersGameLoaded;
    if (currentState.showResult) return;

    final question = currentState.questions[currentState.currentQuestionIndex];
    final isCorrect = event.letter == question['letter'];
    final newScore = isCorrect ? currentState.score + 1 : currentState.score;

    emit(LettersGameLoaded(
      questions: currentState.questions,
      currentQuestionIndex: currentState.currentQuestionIndex,
      score: newScore,
      selectedLetter: event.letter,
      showResult: true,
      isCorrect: isCorrect,
    ));
  }

  void _onMoveToNextQuestion(
    MoveToNextQuestion event,
    Emitter<LettersGameState> emit,
  ) {
    if (state is! LettersGameLoaded) return;
    
    final currentState = state as LettersGameLoaded;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      emit(LettersGameLoaded(
        questions: currentState.questions,
        currentQuestionIndex: currentState.currentQuestionIndex + 1,
        score: currentState.score,
        selectedLetter: null,
        showResult: false,
        isCorrect: false,
      ));
    } else {
      final lastQuestionIndex = currentState.currentQuestionIndex;
      emit(LettersGameCompleted(
        score: currentState.score,
        totalQuestions: currentState.questions.length,
        questions: currentState.questions,
        lastQuestion: currentState.questions[lastQuestionIndex],
      ));
    }
  }

  void _onRestartGame(
    RestartGame event,
    Emitter<LettersGameState> emit,
  ) {
    final shuffledQuestions = _questions
        .map((q) => Map<String, dynamic>.from(q))
        .toList();
    _shuffleOptions(shuffledQuestions);

    emit(LettersGameLoaded(
      questions: shuffledQuestions,
      currentQuestionIndex: 0,
      score: 0,
      selectedLetter: null,
      showResult: false,
      isCorrect: false,
    ));
  }

  void _shuffleOptions(List<Map<String, dynamic>> questions) {
    for (var question in questions) {
      final options = List<String>.from(question['options'] as List);
      options.shuffle(Random());
      question['options'] = options;
    }
  }
}
