import 'package:equatable/equatable.dart';

enum SquatGameStatus { initial, active, gameOver }

class SquatState extends Equatable {
  final SquatGameStatus status;
  final int score;
  final String? feedback;

  const SquatState({
    this.status = SquatGameStatus.initial,
    this.score = 0,
    this.feedback,
  });

  SquatState copyWith({SquatGameStatus? status, int? score, String? feedback}) {
    return SquatState(
      status: status ?? this.status,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
    );
  }

  @override
  List<Object?> get props => [status, score, feedback];
}
