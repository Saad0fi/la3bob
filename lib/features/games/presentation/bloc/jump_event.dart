import 'package:equatable/equatable.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class JumpEvent extends Equatable {
  const JumpEvent();

  @override
  List<Object?> get props => [];
}

class StartGame extends JumpEvent {}

class ResetGame extends JumpEvent {}

class PoseDetected extends JumpEvent {
  final Pose pose;
  const PoseDetected(this.pose);

  @override
  List<Object?> get props => [pose];
}

class GameTick extends JumpEvent {}
