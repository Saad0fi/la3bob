import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class FreezeEvent {}

class StartGame extends FreezeEvent {}

class ResetGame extends FreezeEvent {}

class PoseDetected extends FreezeEvent {
  final Pose pose;
  PoseDetected(this.pose);
}

class Tick extends FreezeEvent {}

class SwitchPhase extends FreezeEvent {}

class EndGracePeriod extends FreezeEvent {}
