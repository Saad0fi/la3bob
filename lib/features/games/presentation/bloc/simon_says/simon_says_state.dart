import 'package:equatable/equatable.dart';
import '../../../domain/repositories/simon_says_repository.dart';

enum SimonGameStatus { initial, active, gameOver }

class SimonSaysState extends Equatable {
  final SimonGameStatus status;
  final SimonMove? currentCommand;
  final int score;
  final int highScore;
  final int remainingTime;
  final bool isWaitingForNeutral;
  final String message;
  final String? feedback;

  const SimonSaysState({
    this.status = SimonGameStatus.initial,
    this.currentCommand,
    this.score = 0,
    this.highScore = 0,
    this.remainingTime = 60,
    this.isWaitingForNeutral = false,
    this.message = "اضغط للبدء",
    this.feedback,
  });

  @override
  List<Object?> get props => [
    status,
    currentCommand,
    score,
    highScore,
    remainingTime,
    isWaitingForNeutral,
    message,
    feedback,
  ];
}
