import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class SquatRepository {
  bool? detectSquat(Pose pose);
  void reset();
}
