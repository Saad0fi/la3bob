import '../../domain/repositories/wave_repository.dart';
import '../../domain/entities/wave_movement.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class WaveDetectorService implements WaveRepository {
  final List<double> _rightWristHistory = [];
  final List<double> _leftWristHistory = [];
  static const int _waveHistorySize = 15;
  static const int _minWaveDirectionChanges = 2;

  @override
  WaveMovement? detectWave(Pose pose) {
    if (pose.landmarks.isEmpty) return null;

    final landmarks = pose.landmarks;
    final bodyHeight = _calculateBodyHeight(landmarks);
    if (bodyHeight == 0) return null;

    if (_isWaving(landmarks, bodyHeight)) {
      return WaveMovement.wave;
    }
    return null;
  }

  double _calculateBodyHeight(Map<PoseLandmarkType, PoseLandmark> lm) {
    final nose = lm[PoseLandmarkType.nose];

    final leftAnkle = lm[PoseLandmarkType.leftAnkle];
    final rightAnkle = lm[PoseLandmarkType.rightAnkle];
    if (nose != null && (leftAnkle != null || rightAnkle != null)) {
      final ankleY = (leftAnkle != null && rightAnkle != null)
          ? (leftAnkle.y + rightAnkle.y) / 2
          : (leftAnkle?.y ?? rightAnkle!.y);
      return (ankleY - nose.y).abs();
    }

    final leftHip = lm[PoseLandmarkType.leftHip];
    final rightHip = lm[PoseLandmarkType.rightHip];
    if (nose != null && (leftHip != null || rightHip != null)) {
      final hipY = (leftHip != null && rightHip != null)
          ? (leftHip.y + rightHip.y) / 2
          : (leftHip?.y ?? rightHip!.y);

      return (hipY - nose.y).abs() * 2.2;
    }

    final leftShoulder = lm[PoseLandmarkType.leftShoulder];
    final rightShoulder = lm[PoseLandmarkType.rightShoulder];
    if (leftShoulder != null && rightShoulder != null) {
      final shoulderWidth = (leftShoulder.x - rightShoulder.x).abs();
      return shoulderWidth * 3.5;
    }

    return 300.0;
  }

  bool _isWaving(Map<PoseLandmarkType, PoseLandmark> lm, double bodyHeight) {
    return _checkHandWave(
          lm[PoseLandmarkType.rightWrist],
          lm[PoseLandmarkType.rightElbow],
          lm[PoseLandmarkType.rightShoulder],
          _rightWristHistory,
          bodyHeight,
        ) ||
        _checkHandWave(
          lm[PoseLandmarkType.leftWrist],
          lm[PoseLandmarkType.leftElbow],
          lm[PoseLandmarkType.leftShoulder],
          _leftWristHistory,
          bodyHeight,
        );
  }

  bool _checkHandWave(
    PoseLandmark? wrist,
    PoseLandmark? elbow,
    PoseLandmark? shoulder,
    List<double> history,
    double bodyHeight,
  ) {
    if (wrist == null || elbow == null || shoulder == null) return false;

    if (wrist.y > elbow.y || wrist.y > shoulder.y) {
      history.clear();
      return false;
    }

    final relativeX = (wrist.x - shoulder.x) / bodyHeight;
    history.add(relativeX);
    if (history.length > _waveHistorySize) history.removeAt(0);
    if (history.length < _waveHistorySize) return false;

    int directionChanges = 0;
    int lastDirection = 0; 
    for (int i = 1; i < history.length; i++) {
      final diff = history[i] - history[i - 1];
      if (diff.abs() < 0.02) continue; 
      final curDir = diff > 0 ? 1 : -1;
      if (lastDirection != 0 && curDir != lastDirection) directionChanges++;
      lastDirection = curDir;
    }

    if (directionChanges >= _minWaveDirectionChanges) {
      history.clear(); 
      return true;
    }
    return false;
  }

  void reset() {
    _rightWristHistory.clear();
    _leftWristHistory.clear();
  }
}

