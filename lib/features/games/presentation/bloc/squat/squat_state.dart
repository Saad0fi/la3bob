import 'package:equatable/equatable.dart';

enum SquatGameStatus { initial, active, gameOver }

class SquatState extends Equatable {
  final SquatGameStatus status;
  final int score;
  final String? feedback;
  final int remainingTime;
  final int highScore;

  const SquatState({
    this.status = SquatGameStatus.initial,
    this.score = 0,
    this.feedback,
    this.remainingTime = 60,
    this.highScore = 0,
  });

  @override
  List<Object?> get props => [
    status,
    score,
    feedback,
    remainingTime,
    highScore,
  ];
}
