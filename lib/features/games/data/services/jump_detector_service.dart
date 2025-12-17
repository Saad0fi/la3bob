import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/repositories/jump_repository.dart';

class JumpDetectorService implements JumpRepository {
  double? _groundY;
  static const double jumpThreshold =
      0.10; 

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

    final currentAnkleY = (leftAnkle.y + rightAnkle.y) / 2;
    final bodyHeight = (currentAnkleY - nose.y).abs();

    if (bodyHeight < 10) return null;


    if (_groundY == null || currentAnkleY > _groundY!) {
      _groundY = currentAnkleY;
      return false;
    }

    final difference = _groundY! - currentAnkleY;

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

