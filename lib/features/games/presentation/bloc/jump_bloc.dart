import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/usecases/detect_jump.dart';
import 'jump_event.dart';
import 'jump_state.dart';

class JumpBloc extends Bloc<JumpEvent, JumpState> {
  final DetectJump _detectJump;
  final GetStorage _storage = GetStorage();
  Timer? _gameTimer;

  // Game Constants
  static const double _gameSpeed = 0.012; // Slower speed (was 0.015)
  static const double _spawnThreshold =
      0.7; // More space between obstacles (was 0.6)
  static const double _playerX = 0.15; // Fixed player X position
  static const int _tickRate = 30; // ms (approx 33fps)

  JumpBloc(this._detectJump) : super(const JumpState()) {
    on<StartGame>(_onStartGame);
    on<ResetGame>(_onResetGame);
    on<GameTick>(_onGameTick);
    on<PoseDetected>(_onPoseDetected);

    final savedScore = _storage.read<int>('jump_high_score') ?? 0;
    emit(state.copyWith(highScore: savedScore));
  }

  void _onStartGame(StartGame event, Emitter<JumpState> emit) {
    _gameTimer?.cancel();
    _detectJump.reset();

    emit(
      state.copyWith(
        status: JumpGameStatus.active,
        score: 0,
        obstacles: [],
        playerState: PlayerState.grounded,
        feedback: "JUMP TO AVOID!",
      ),
    );

    _gameTimer = Timer.periodic(const Duration(milliseconds: _tickRate), (_) {
      add(GameTick());
    });
  }

  void _onResetGame(ResetGame event, Emitter<JumpState> emit) {
    _gameTimer?.cancel();
    emit(
      state.copyWith(status: JumpGameStatus.initial, obstacles: [], score: 0),
    );
  }

  DateTime? _lastJumpTime;
  static const int _minJumpDurationMs = 500; // 500ms min jump time

  void _onPoseDetected(PoseDetected event, Emitter<JumpState> emit) {
    // If game is not active, we run calibration
    if (state.status != JumpGameStatus.active) {
      _checkCalibration(event.pose, emit);
      return;
    }

    // We only care if we are in air or not.
    final pJumping = _detectJump(event.pose) ?? false;

    final now = DateTime.now();
    bool effectiveJumping = pJumping;

    if (pJumping) {
      _lastJumpTime = now;
    } else {
      // If physically grounded but within hold time
      if (_lastJumpTime != null &&
          now.difference(_lastJumpTime!).inMilliseconds < _minJumpDurationMs) {
        effectiveJumping = true;
      }
    }

    // Update player state
    emit(
      state.copyWith(
        playerState: effectiveJumping
            ? PlayerState.jumping
            : PlayerState.grounded,
      ),
    );
  }

  void _onGameTick(GameTick event, Emitter<JumpState> emit) {
    if (state.status != JumpGameStatus.active) return;

    List<Obstacle> newObstacles = [];
    int newScore = state.score;
    bool crashed = false;

    // 1. Move Obstacles
    for (var obs in state.obstacles) {
      final newOb = obs.move(_gameSpeed);

      // If passing player
      // Collision zone: Player is at _playerX (0.15).
      // Obstacle width assumption: ~0.05
      // If obstacle.x < 0.19 && obstacle.x > 0.11 => DANGER ZONE (Reduced from 0.05 margin to 0.04)
      if (newOb.x < (_playerX + 0.04) && newOb.x > (_playerX - 0.04)) {
        if (state.playerState == PlayerState.grounded) {
          crashed = true;
        }
      }

      // If passed off screen
      if (newOb.x < -0.1) {
        // Passed successfully
        newScore++;
      } else {
        newObstacles.add(newOb);
      }
    }

    if (crashed) {
      _gameTimer?.cancel();

      // Update High Score
      if (newScore > state.highScore) {
        _storage.write('jump_high_score', newScore);
      }

      emit(
        state.copyWith(
          status: JumpGameStatus.gameOver,
          score: newScore,
          highScore: max(newScore, state.highScore),
          feedback: "CRASH!",
        ),
      );
      return;
    }

    // 2. Spawn new Obstacle
    // Simple logic: if last obstacle is far enough, chance to spawn
    if (newObstacles.isEmpty || (1.0 - newObstacles.last.x) > _spawnThreshold) {
      // Random chance to spawn, or periodic? simple logic: always spawn after threshold + random jitter
      // Let's just spawn if last one is > 0.6 away.
      if (Random().nextDouble() < 0.05) {
        // 5% chance per tick if valid
        newObstacles.add(const Obstacle(x: 1.0));
      }
    }
    // ensure AT LEAST one obstacle eventually
    if (newObstacles.isEmpty && Random().nextDouble() < 0.1) {
      newObstacles.add(const Obstacle(x: 1.0));
    }

    emit(state.copyWith(obstacles: newObstacles, score: newScore));
  }

  void _checkCalibration(Pose pose, Emitter<JumpState> emit) {
    if (pose.landmarks.isEmpty) {
      emit(
        state.copyWith(
          isCalibrated: false,
          calibrationMessage: "لا أراك! قف أمام الكاميرا",
        ),
      );
      return;
    }

    final landmarks = pose.landmarks;
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];
    final nose = landmarks[PoseLandmarkType.nose];

    if (leftAnkle == null || rightAnkle == null || nose == null) {
      emit(
        state.copyWith(
          isCalibrated: false,
          calibrationMessage: "تأكد من ظهور جسمك بالكامل",
        ),
      );
      return;
    }

    // Check visibility / likelihood if available, or just presence
    // Also check if they are actually on screen (coordinates 0..1 or inside image size)
    // We already know they are not null.

    // Check if feet are visible (sometimes they are cut off at bottom)
    // Y increases downwards. If Y is very large (near image height), might be cut off?
    // Let's just assume if detected, they are fine.

    // Calculate body size (approximate height in pixels)
    // Note: Y coordinates are in image space.
    // If we assume a normalized coordinate system (0..1) or absolute pixels?
    // ML Kit returns absolute pixels based on image size.
    // Let's rely on relative difference.

    final bodyHeight = (leftAnkle.y + rightAnkle.y) / 2 - nose.y;

    // We need some reference. If the image is e.g. 640x480 (typical detection res).
    // Let's assume a "good" height is roughly 1/3 to 2/3 of the screen.
    // If bodyHeight < 150 (too small) -> Come closer
    // If bodyHeight > 400 (too big) -> Step back

    // Note: This depends on camera resolution.
    // A safer way might be checking the ratio if we knew image height.
    // But for now let's try raw values assuming standard preview feed.

    if (bodyHeight < 200) {
      emit(
        state.copyWith(
          isCalibrated: false,
          calibrationMessage: "اقترب قليلاً للكاميرا ⬆️", // Come closer
        ),
      );
      return;
    }

    if (bodyHeight > 500) {
      emit(
        state.copyWith(
          isCalibrated: false,
          calibrationMessage: "ابتعد قليلاً عن الكاميرا ⬇️", // Step back
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isCalibrated: true,
        calibrationMessage: "ممتاز! ابدأ اللعبة ✅",
      ),
    );
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    return super.close();
  }
}
