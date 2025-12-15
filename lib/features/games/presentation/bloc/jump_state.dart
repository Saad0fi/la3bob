import 'package:equatable/equatable.dart';

enum JumpGameStatus { initial, active, gameOver }

enum PlayerState { grounded, jumping }

class Obstacle extends Equatable {
  final double x; // Horizontal position (0.0 to 1.0 or pixels)
  // We'll use 0.0 to 1.0 logic for simpler responsiveness? OR pixels.
  // Pixels is easier for GameTick updates if we know screen width.
  // But CustomPaint uses canvas size. Let's use relative units 0.0-1.0 to be safe
  // X: 1.0 (right) -> 0.0 (left)

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
  final PlayerState playerState; // Visual only? Logic handled by bloc.
  final String? feedback;

  const JumpState({
    this.status = JumpGameStatus.initial,
    this.score = 0,
    this.highScore = 0,
    this.obstacles = const [],
    this.playerState = PlayerState.grounded,
    this.feedback,
  });

  JumpState copyWith({
    JumpGameStatus? status,
    int? score,
    int? highScore,
    List<Obstacle>? obstacles,
    PlayerState? playerState,
    String? feedback,
  }) {
    return JumpState(
      status: status ?? this.status,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      obstacles: obstacles ?? this.obstacles,
      playerState: playerState ?? this.playerState,
      feedback:
          feedback, // Nullable update logic requires wrapper or just explicit null
    );
  }

  @override
  List<Object?> get props => [
    status,
    score,
    highScore,
    obstacles,
    playerState,
    feedback,
  ];
}
