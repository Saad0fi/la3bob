import 'package:equatable/equatable.dart';

enum JumpGameStatus { initial, active, gameOver }

enum PlayerState { grounded, jumping }

class Obstacle extends Equatable {
  final double x;

  const Obstacle({required this.x});

  Obstacle move(double speed) => Obstacle(x: x - speed);

  @override
  List<Object?> get props => [x];
}

class JumpState extends Equatable {
  final JumpGameStatus status;
  final int score;
  final int highScore;
  final List<Obstacle> obstacles;
  final PlayerState playerState;
  final String? feedback;
  final bool isCalibrated;
  final String? calibrationMessage;

  const JumpState({
    this.status = JumpGameStatus.initial,
    this.score = 0,
    this.highScore = 0,
    this.obstacles = const [],
    this.playerState = PlayerState.grounded,
    this.feedback,
    this.isCalibrated = false,
    this.calibrationMessage,
  });

  @override
  List<Object?> get props => [
    status,
    score,
    highScore,
    obstacles,
    playerState,
    feedback,
    isCalibrated,
    calibrationMessage,
  ];
}
