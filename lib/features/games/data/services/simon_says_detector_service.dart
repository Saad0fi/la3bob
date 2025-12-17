import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/repositories/simon_says_repository.dart';

class SimonSaysDetectorService implements SimonSaysRepository {
  @override
  SimonMove? detectMove(Pose pose) {
    if (pose.landmarks.isEmpty) return null;

    final landmarks = pose.landmarks;

    final leftWrist = landmarks[PoseLandmarkType.leftWrist];
    final rightWrist = landmarks[PoseLandmarkType.rightWrist];
    final leftEye = landmarks[PoseLandmarkType.leftEye];
    final rightEye = landmarks[PoseLandmarkType.rightEye];

    if (rightWrist != null && rightEye != null && rightWrist.y < rightEye.y) {
      return SimonMove.raiseRightHand;
    }
    if (leftWrist != null && leftEye != null && leftWrist.y < leftEye.y) {
      return SimonMove.raiseLeftHand;
    }


    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];

    if (leftAnkle != null && rightAnkle != null) {
      final ankleDiff = (leftAnkle.y - rightAnkle.y).abs();

      if (ankleDiff > 100) {

        if (leftAnkle.y < rightAnkle.y) {
          return SimonMove.standOnRightLeg; 
        } else {
          return SimonMove.standOnLeftLeg; 
        }
      }
    }

    final leftHip = landmarks[PoseLandmarkType.leftHip];
    final leftKnee = landmarks[PoseLandmarkType.leftKnee];
    final rightHip = landmarks[PoseLandmarkType.rightHip];
    final rightKnee = landmarks[PoseLandmarkType.rightKnee];

    if (leftHip != null &&
        leftKnee != null &&
        rightHip != null &&
        rightKnee != null) {
 
      final hipY = (leftHip.y + rightHip.y) / 2;
      final kneeY = (leftKnee.y + rightKnee.y) / 2;

      if ((kneeY - hipY) < 150) {
        return SimonMove.squat;
      }
    }

    return SimonMove.nothing;
  }

  @override
  void reset() {
  }
}

