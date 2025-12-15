import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/repositories/jump_repository.dart';

class JumpDetectorService implements JumpRepository {
  // We'll use a simple baseline approach.
  double? _groundY;
  static const double jumpThreshold =
      0.10; // 10% of body height change (was 15%)

  @override
  bool? detectJump(Pose pose) {
    if (pose.landmarks.isEmpty) return null;

    final landmarks = pose.landmarks;

    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];
    final nose = landmarks[PoseLandmarkType.nose];

    if (leftAnkle == null || rightAnkle == null || nose == null) {
      return null;
    }

    // Calculate current ankle height (average of both)
    // Note: In image coordinates, Y increases downwards.
    // So "up" in real world is "smaller Y" in image.
    final currentAnkleY = (leftAnkle.y + rightAnkle.y) / 2;
    final bodyHeight = (currentAnkleY - nose.y).abs();

    // Safety check for invalid poses
    if (bodyHeight < 10) return null;

    // Calibrate ground level if not set or if we find a "lower" point (standing)
    // We assume the user starts standing.
    // We also update ground if we see a significantly lower Y (meaning feet are lower, so standing)
    if (_groundY == null || currentAnkleY > _groundY!) {
      _groundY = currentAnkleY;
      return false;
    }

    // Check if ankles are significantly higher (smaller Y) than ground
    final difference = _groundY! - currentAnkleY;

    // If difference is positive and large enough, they jumped up!
    if (difference > (bodyHeight * jumpThreshold)) {
      return true;
    }

    return false;
  }

  @override
  void reset() {
    _groundY = null;
  }
}
