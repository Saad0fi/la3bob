import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class FreezeRepository {
  /// Returns a value representing movement intensity (e.g., 0.0 to 1.0+)
  /// Higher value means more movement.
  double detectMovement(Pose pose);

  void reset();
}
