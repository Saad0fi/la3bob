enum FreezePhase {
  initial,
  dancing, // Green Light (Move!)
  freezing, // Red Light (Stop!)
  gameOver,
}

class FreezeState {
  final FreezePhase phase;
  final int score;
  final int highScore;
  final String message;
  final double currentMovement; // For debug/visual feedback

  const FreezeState({
    this.phase = FreezePhase.initial,
    this.score = 0,
    this.highScore = 0,
    this.message = "استعد للرقص!",
    this.currentMovement = 0.0,
  });

  FreezeState copyWith({
    FreezePhase? phase,
    int? score,
    int? highScore,
    String? message,
    double? currentMovement,
  }) {
    return FreezeState(
      phase: phase ?? this.phase,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      message: message ?? this.message,
      currentMovement: currentMovement ?? this.currentMovement,
    );
  }
}
