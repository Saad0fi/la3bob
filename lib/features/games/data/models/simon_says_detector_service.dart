import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/repositories/simon_says_repository.dart';

class SimonSaysDetectorService implements SimonSaysRepository {
  @override
  SimonMove? detectMove(Pose pose) {
    if (pose.landmarks.isEmpty) return null;

    final landmarks = pose.landmarks;

    // 1. Check for Hand Raising
    final leftWrist = landmarks[PoseLandmarkType.leftWrist];
    final rightWrist = landmarks[PoseLandmarkType.rightWrist];
    final leftEye = landmarks[PoseLandmarkType.leftEye];
    final rightEye = landmarks[PoseLandmarkType.rightEye];

    // Note: Y decreases as you go up
    if (rightWrist != null && rightEye != null && rightWrist.y < rightEye.y) {
      return SimonMove.raiseRightHand;
    }
    if (leftWrist != null && leftEye != null && leftWrist.y < leftEye.y) {
      return SimonMove.raiseLeftHand;
    }

    // 2. Check for Standing on One Leg
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];

    if (leftAnkle != null && rightAnkle != null) {
      final ankleDiff = (leftAnkle.y - rightAnkle.y).abs();
      // If significant difference, one leg is up
      // 15% of screen height or absolute pixel value?
      // Better to check relative to body height or just raw threshold if full body is visible.
      if (ankleDiff > 100) {
        // arbitrary raw pixel threshold for now, safer to use ratio
        // If right ankle Y is LARGER (lower on screen) than left ankle, left leg is raised (smaller Y)
        if (leftAnkle.y < rightAnkle.y) {
          return SimonMove.standOnRightLeg; // Left leg up -> Standing on Right
        } else {
          return SimonMove.standOnLeftLeg; // Right leg up -> Standing on Left
        }
      }
    }

    // 3. Check for Squat
    final leftHip = landmarks[PoseLandmarkType.leftHip];
    final leftKnee = landmarks[PoseLandmarkType.leftKnee];
    final rightHip = landmarks[PoseLandmarkType.rightHip];
    final rightKnee = landmarks[PoseLandmarkType.rightKnee];

    if (leftHip != null &&
        leftKnee != null &&
        rightHip != null &&
        rightKnee != null) {
      // If hips are roughly at knee level (or lower is hard, but close to it)
      // Standard squat: Hip Y is close to Knee Y.
      // Normal standing: Hip Y is much smaller than Knee Y.
      final hipY = (leftHip.y + rightHip.y) / 2;
      final kneeY = (leftKnee.y + rightKnee.y) / 2;

      // If distance between hip and knee is small
      if ((kneeY - hipY) < 150) {
        // Threshold
        return SimonMove.squat;
      }
    }

    return SimonMove.nothing;
  }

  @override
  void reset() {
    // No state needed for basic detection
  }
}
