import '../../../domain/repositories/simon_says_repository.dart';

enum SimonGameStatus { initial, active, gameOver }

class SimonSaysState {
  final SimonGameStatus status;
  final SimonMove? currentCommand;
  final int score;
  final int highScore;
  final int remainingTime;
  final bool isWaitingForNeutral;
  final String message; // Arabic text to display
  final String? feedback; // Immediate feedback (Green tick, etc)

  const SimonSaysState({
    this.status = SimonGameStatus.initial,
    this.currentCommand,
    this.score = 0,
    this.highScore = 0,
    this.remainingTime = 60,
    this.isWaitingForNeutral = false,
    this.message = "اضغط للبدء", // "Press to Start"
    this.feedback,
  });

  SimonSaysState copyWith({
    SimonGameStatus? status,
    SimonMove? currentCommand,
    bool clearCurrentCommand = false,
    int? score,
    int? highScore,
    int? remainingTime,
    bool? isWaitingForNeutral,
    String? message,
    String? feedback,
    bool clearFeedback = false,
  }) {
    return SimonSaysState(
      status: status ?? this.status,
      currentCommand: clearCurrentCommand
          ? null
          : (currentCommand ?? this.currentCommand),
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      remainingTime: remainingTime ?? this.remainingTime,
      isWaitingForNeutral: isWaitingForNeutral ?? this.isWaitingForNeutral,
      message: message ?? this.message,
      feedback: clearFeedback ? null : (feedback ?? this.feedback),
    );
  }
}
