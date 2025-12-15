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

  SquatState copyWith({
    SquatGameStatus? status,
    int? score,
    String? feedback,
    int? remainingTime,
    int? highScore,
  }) {
    return SquatState(
      status: status ?? this.status,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      remainingTime: remainingTime ?? this.remainingTime,
      highScore: highScore ?? this.highScore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    score,
    feedback,
    remainingTime,
    highScore,
  ];
}
