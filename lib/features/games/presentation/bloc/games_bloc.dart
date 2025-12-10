import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'games_event.dart';
part 'games_state.dart';

enum GameType { letters, numbers }

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  static const List<Map<String, dynamic>> _lettersQuestions = [
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

  static const List<Map<String, dynamic>> _numbersQuestions = [
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

  GamesBloc() : super(GamesInitial()) {
    on<InitializeLettersGame>(_onInitializeLettersGame);
    on<InitializeNumbersGame>(_onInitializeNumbersGame);
    on<SelectLetter>(_onSelectLetter);
    on<SelectNumber>(_onSelectNumber);
    on<MoveToNextQuestion>(_onMoveToNextQuestion);
    on<RestartGame>(_onRestartGame);
  }

  void _onInitializeLettersGame(
    InitializeLettersGame event,
    Emitter<GamesState> emit,
  ) {
    final shuffledQuestions = _lettersQuestions
        .map((q) => Map<String, dynamic>.from(q))
        .toList();
    _shuffleLettersOptions(shuffledQuestions);

    emit(GameLoaded(
      gameType: GameType.letters,
      questions: shuffledQuestions,
      currentQuestionIndex: 0,
      score: 0,
      selectedLetter: null,
      selectedNumber: null,
      showResult: false,
      isCorrect: false,
    ));
  }

  void _onInitializeNumbersGame(
    InitializeNumbersGame event,
    Emitter<GamesState> emit,
  ) {
    final shuffledQuestions = _numbersQuestions
        .map((q) => Map<String, dynamic>.from(q))
        .toList();
    _shuffleNumbersOptions(shuffledQuestions);

    emit(GameLoaded(
      gameType: GameType.numbers,
      questions: shuffledQuestions,
      currentQuestionIndex: 0,
      score: 0,
      selectedLetter: null,
      selectedNumber: null,
      showResult: false,
      isCorrect: false,
    ));
  }

  void _onSelectLetter(
    SelectLetter event,
    Emitter<GamesState> emit,
  ) {
    if (state is! GameLoaded) return;

    final currentState = state as GameLoaded;
    if (currentState.gameType != GameType.letters || currentState.showResult) {
      return;
    }

    final question = currentState.questions[currentState.currentQuestionIndex];
    final isCorrect = event.letter == question['letter'];
    final newScore = isCorrect ? currentState.score + 1 : currentState.score;

    emit(GameLoaded(
      gameType: GameType.letters,
      questions: currentState.questions,
      currentQuestionIndex: currentState.currentQuestionIndex,
      score: newScore,
      selectedLetter: event.letter,
      selectedNumber: null,
      showResult: true,
      isCorrect: isCorrect,
    ));
  }

  void _onSelectNumber(
    SelectNumber event,
    Emitter<GamesState> emit,
  ) {
    if (state is! GameLoaded) return;

    final currentState = state as GameLoaded;
    if (currentState.gameType != GameType.numbers || currentState.showResult) {
      return;
    }

    final question = currentState.questions[currentState.currentQuestionIndex];
    final isCorrect = event.number == question['count'];
    final newScore = isCorrect ? currentState.score + 1 : currentState.score;

    emit(GameLoaded(
      gameType: GameType.numbers,
      questions: currentState.questions,
      currentQuestionIndex: currentState.currentQuestionIndex,
      score: newScore,
      selectedLetter: null,
      selectedNumber: event.number,
      showResult: true,
      isCorrect: isCorrect,
    ));
  }

  void _onMoveToNextQuestion(
    MoveToNextQuestion event,
    Emitter<GamesState> emit,
  ) {
    if (state is! GameLoaded) return;

    final currentState = state as GameLoaded;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      emit(GameLoaded(
        gameType: currentState.gameType,
        questions: currentState.questions,
        currentQuestionIndex: currentState.currentQuestionIndex + 1,
        score: currentState.score,
        selectedLetter: null,
        selectedNumber: null,
        showResult: false,
        isCorrect: false,
      ));
    } else {
      final lastQuestionIndex = currentState.currentQuestionIndex;
      emit(GameCompleted(
        gameType: currentState.gameType,
        score: currentState.score,
        totalQuestions: currentState.questions.length,
        questions: currentState.questions,
        lastQuestion: currentState.questions[lastQuestionIndex],
      ));
    }
  }

  void _onRestartGame(
    RestartGame event,
    Emitter<GamesState> emit,
  ) {
    if (state is! GameCompleted) return;

    final completedState = state as GameCompleted;
    final questions = completedState.gameType == GameType.letters
        ? _lettersQuestions
        : _numbersQuestions;

    final shuffledQuestions =
        questions.map((q) => Map<String, dynamic>.from(q)).toList();

    if (completedState.gameType == GameType.letters) {
      _shuffleLettersOptions(shuffledQuestions);
    } else {
      _shuffleNumbersOptions(shuffledQuestions);
    }

    emit(GameLoaded(
      gameType: completedState.gameType,
      questions: shuffledQuestions,
      currentQuestionIndex: 0,
      score: 0,
      selectedLetter: null,
      selectedNumber: null,
      showResult: false,
      isCorrect: false,
    ));
  }

  void _shuffleLettersOptions(List<Map<String, dynamic>> questions) {
    for (var question in questions) {
      final options = List<String>.from(question['options'] as List);
      options.shuffle(Random());
      question['options'] = options;
    }
  }

  void _shuffleNumbersOptions(List<Map<String, dynamic>> questions) {
    for (var question in questions) {
      final options = List<int>.from(question['options'] as List);
      options.shuffle(Random());
      question['options'] = options;
    }
  }
}
