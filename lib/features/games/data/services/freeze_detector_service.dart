import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/repositories/freeze_repository.dart';

class FreezeDetectorService implements FreezeRepository {
  Map<PoseLandmarkType, PoseLandmark>? _previousLandmarks;

  @override
  double detectMovement(Pose pose) {
    if (_previousLandmarks == null) {
      _previousLandmarks = pose.landmarks;
      return 0.0; 
    }

    final nose = pose.landmarks[PoseLandmarkType.nose];
    final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

    double bodyHeight = 1.0;
    if (nose != null && (leftAnkle != null || rightAnkle != null)) {
      final ankleY = leftAnkle != null && rightAnkle != null
          ? (leftAnkle.y + rightAnkle.y) / 2
          : (leftAnkle?.y ?? rightAnkle!.y);
      bodyHeight = (ankleY - nose.y).abs();
    }

    if (bodyHeight < 10.0) bodyHeight = 100.0;

    double totalDisplacement = 0.0;
    int pointsChecked = 0;

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

    _previousLandmarks = pose.landmarks;

    if (pointsChecked == 0) return 0.0;


    return (totalDisplacement / pointsChecked) / bodyHeight;
  }

  @override
  void reset() {
    _previousLandmarks = null;
  }
}

