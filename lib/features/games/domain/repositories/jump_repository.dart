import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class JumpRepository {
  bool? detectJump(Pose pose);

  void reset();
}
