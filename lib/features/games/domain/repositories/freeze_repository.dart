import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class FreezeRepository {
  double detectMovement(Pose pose);

  void reset();
}
