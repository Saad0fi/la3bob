import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../domain/usecases/detect_jump.dart';
import 'jump_event.dart';
import 'jump_state.dart';

class JumpBloc extends Bloc<JumpEvent, JumpState> {
  final DetectJump _detectJump;
  final GetStorage _storage = GetStorage();
  Timer? _gameTimer;

  static const double _gameSpeed = 0.012;
  static const double _spawnThreshold = 0.7;
  static const double _playerX = 0.15;
  static const int _tickRate = 30;

  DateTime? _lastJumpTime;
  static const int _minJumpDurationMs = 500;

  JumpBloc(this._detectJump) : super(const JumpState()) {
    on<StartGame>(_onStartGame);
    on<ResetGame>(_onResetGame);
    on<GameTick>(_onGameTick);
    on<PoseDetected>(_onPoseDetected);

    final savedScore = _storage.read<int>('jump_high_score') ?? 0;
    emit(JumpState(highScore: savedScore));
  }

  void _onStartGame(StartGame event, Emitter<JumpState> emit) {
    _gameTimer?.cancel();
    _detectJump.reset();

    emit(JumpState(
      status: JumpGameStatus.active,
      score: 0,
      highScore: state.highScore,
      obstacles: [],
      playerState: PlayerState.grounded,
      feedback: "JUMP TO AVOID!",
      isCalibrated: state.isCalibrated,
    ));

    _gameTimer = Timer.periodic(const Duration(milliseconds: _tickRate), (_) {
      add(GameTick());
    });
  }

  void _onResetGame(ResetGame event, Emitter<JumpState> emit) {
    _gameTimer?.cancel();
    emit(JumpState(
      status: JumpGameStatus.initial,
      highScore: state.highScore,
      obstacles: [],
      score: 0,
    ));
  }

  void _onPoseDetected(PoseDetected event, Emitter<JumpState> emit) {
    if (state.status != JumpGameStatus.active) {
      _checkCalibration(event.pose, emit);
      return;
    }

    final pJumping = _detectJump(event.pose) ?? false;
    final now = DateTime.now();
    bool effectiveJumping = pJumping;

    if (pJumping) {
      _lastJumpTime = now;
    } else {
      if (_lastJumpTime != null &&
          now.difference(_lastJumpTime!).inMilliseconds < _minJumpDurationMs) {
        effectiveJumping = true;
      }
    }

    emit(JumpState(
      status: state.status,
      score: state.score,
      highScore: state.highScore,
      obstacles: state.obstacles,
      playerState: effectiveJumping ? PlayerState.jumping : PlayerState.grounded,
      feedback: state.feedback,
      isCalibrated: state.isCalibrated,
      calibrationMessage: state.calibrationMessage,
    ));
  }

  void _onGameTick(GameTick event, Emitter<JumpState> emit) {
    if (state.status != JumpGameStatus.active) return;

    List<Obstacle> newObstacles = [];
    int newScore = state.score;
    bool crashed = false;

    for (var obs in state.obstacles) {
      final newOb = obs.move(_gameSpeed);

      if (newOb.x < (_playerX + 0.04) && newOb.x > (_playerX - 0.04)) {
        if (state.playerState == PlayerState.grounded) {
          crashed = true;
        }
      }

      if (newOb.x < -0.1) {
        newScore++;
      } else {
        newObstacles.add(newOb);
      }
    }

    if (crashed) {
      _gameTimer?.cancel();

      if (newScore > state.highScore) {
        _storage.write('jump_high_score', newScore);
      }

      emit(JumpState(
        status: JumpGameStatus.gameOver,
        score: newScore,
        highScore: max(newScore, state.highScore),
        obstacles: newObstacles,
        playerState: state.playerState,
        feedback: "CRASH!",
        isCalibrated: state.isCalibrated,
      ));
      return;
    }

    if (newObstacles.isEmpty || (1.0 - newObstacles.last.x) > _spawnThreshold) {
      if (Random().nextDouble() < 0.05) {
        newObstacles.add(const Obstacle(x: 1.0));
      }
    }
    if (newObstacles.isEmpty && Random().nextDouble() < 0.1) {
      newObstacles.add(const Obstacle(x: 1.0));
    }

    emit(JumpState(
      status: state.status,
      score: newScore,
      highScore: state.highScore,
      obstacles: newObstacles,
      playerState: state.playerState,
      feedback: state.feedback,
      isCalibrated: state.isCalibrated,
      calibrationMessage: state.calibrationMessage,
    ));
  }

  void _checkCalibration(Pose pose, Emitter<JumpState> emit) {
    if (pose.landmarks.isEmpty) {
      emit(JumpState(
        status: state.status,
        score: state.score,
        highScore: state.highScore,
        obstacles: state.obstacles,
        playerState: state.playerState,
        isCalibrated: false,
        calibrationMessage: "لا أراك! قف أمام الكاميرا",
      ));
      return;
    }

    final landmarks = pose.landmarks;
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];
    final nose = landmarks[PoseLandmarkType.nose];

    if (leftAnkle == null || rightAnkle == null || nose == null) {
      emit(JumpState(
        status: state.status,
        score: state.score,
        highScore: state.highScore,
        obstacles: state.obstacles,
        playerState: state.playerState,
        isCalibrated: false,
        calibrationMessage: "تأكد من ظهور جسمك بالكامل",
      ));
      return;
    }

    final bodyHeight = (leftAnkle.y + rightAnkle.y) / 2 - nose.y;

    if (bodyHeight < 200) {
      emit(JumpState(
        status: state.status,
        score: state.score,
        highScore: state.highScore,
        obstacles: state.obstacles,
        playerState: state.playerState,
        isCalibrated: false,
        calibrationMessage: "اقترب قليلاً للكاميرا ⬆️",
      ));
      return;
    }

    if (bodyHeight > 500) {
      emit(JumpState(
        status: state.status,
        score: state.score,
        highScore: state.highScore,
        obstacles: state.obstacles,
        playerState: state.playerState,
        isCalibrated: false,
        calibrationMessage: "ابتعد قليلاً عن الكاميرا ⬇️",
      ));
      return;
    }

    emit(JumpState(
      status: state.status,
      score: state.score,
      highScore: state.highScore,
      obstacles: state.obstacles,
      playerState: state.playerState,
      isCalibrated: true,
      calibrationMessage: "ممتاز! ابدأ اللعبة ✅",
    ));
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    return super.close();
  }
}
