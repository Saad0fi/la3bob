import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class SimonSaysEvent {}

class StartGame extends SimonSaysEvent {}

class ResetGame extends SimonSaysEvent {}

class PoseDetected extends SimonSaysEvent {
  final Pose pose;
  PoseDetected(this.pose);
}

class NextCommand extends SimonSaysEvent {}

class Tick extends SimonSaysEvent {
  final int remainingTime;
  Tick(this.remainingTime);
}
