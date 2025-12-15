import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum SimonMove {
  raiseRightHand,
  raiseLeftHand,
  standOnRightLeg,
  standOnLeftLeg,
  squat,
  nothing,
}

abstract class SimonSaysRepository {
  SimonMove? detectMove(Pose pose);
  void reset();
}
