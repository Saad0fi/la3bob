import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/repositories/squat_repository.dart';

class SquatDetectorService implements SquatRepository {
  bool _wasDown = false;
  static const double squatThreshold = 0.20; // 20% of body height

  @override
  bool? detectSquat(Pose pose) {
    if (pose.landmarks.isEmpty) return null;

    final landmarks = pose.landmarks;
    final bodyHeight = _calculateBodyHeight(landmarks);

    // Avoid division by zero
    if (bodyHeight == 0) return null;

    final isSquatting = _isSquatting(landmarks, bodyHeight);

    if (isSquatting && !_wasDown) {
      _wasDown = true;
      return true; // Squat detected
    } else if (!isSquatting) {
      _wasDown = false;
    }

    return null;
  }

  @override
  void reset() {
    _wasDown = false;
  }

  // ---------- Helpers from original MovementDetector ----------

  double _calculateBodyHeight(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    final nose = landmarks[PoseLandmarkType.nose];
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];

    if (nose == null || (leftAnkle == null && rightAnkle == null)) {
      return 1.0; // Default to avoid division by zero
    }

    final ankleY = leftAnkle != null && rightAnkle != null
        ? (leftAnkle.y + rightAnkle.y) / 2
        : (leftAnkle?.y ?? rightAnkle!.y);

    return (ankleY - nose.y).abs();
  }

  bool _isSquatting(
    Map<PoseLandmarkType, PoseLandmark> landmarks,
    double bodyHeight,
  ) {
    final leftHip = landmarks[PoseLandmarkType.leftHip];
    final rightHip = landmarks[PoseLandmarkType.rightHip];
    final leftKnee = landmarks[PoseLandmarkType.leftKnee];
    final rightKnee = landmarks[PoseLandmarkType.rightKnee];

    if (leftHip == null ||
        rightHip == null ||
        leftKnee == null ||
        rightKnee == null) {
      return false;
    }

    final hipY = (leftHip.y + rightHip.y) / 2;
    final kneeY = (leftKnee.y + rightKnee.y) / 2;

    final hipKneeDistance = (kneeY - hipY).abs();

    // Squatting if hips are close to knees (relative to body height)
    return (hipKneeDistance / bodyHeight) < squatThreshold;
  }
}
