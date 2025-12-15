import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class JumpRepository {
  /// Returns true if the pose indicates the user is currently jumping (in the air).
  bool? detectJump(Pose pose);

  /// Resets any state (like calibration).
  void reset();
}
