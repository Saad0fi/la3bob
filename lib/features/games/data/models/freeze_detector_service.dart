import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/repositories/freeze_repository.dart';

class FreezeDetectorService implements FreezeRepository {
  Map<PoseLandmarkType, PoseLandmark>? _previousLandmarks;

  @override
  double detectMovement(Pose pose) {
    if (_previousLandmarks == null) {
      _previousLandmarks = pose.landmarks;
      return 0.0; // First frame, no movement detected yet
    }

    double totalDisplacement = 0.0;
    int pointsChecked = 0;

    // Key points to track for movement (Hands, Shoulders, Hips)
    final typesToCheck = [
      PoseLandmarkType.leftWrist,
      PoseLandmarkType.rightWrist,
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.rightHip,
    ];

    for (var type in typesToCheck) {
      final current = pose.landmarks[type];
      final previous = _previousLandmarks![type];

      if (current != null && previous != null && current.likelihood > 0.5) {
        final dist = sqrt(
          pow(current.x - previous.x, 2) + pow(current.y - previous.y, 2),
        );
        totalDisplacement += dist;
        pointsChecked++;
      }
    }

    // Update history
    _previousLandmarks = pose.landmarks;

    if (pointsChecked == 0) return 0.0;

    // Average displacement per point
    return totalDisplacement / pointsChecked;
  }

  @override
  void reset() {
    _previousLandmarks = null;
  }
}
