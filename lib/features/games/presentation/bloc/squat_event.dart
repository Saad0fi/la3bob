import 'package:equatable/equatable.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class SquatEvent extends Equatable {
  const SquatEvent();

  @override
  List<Object> get props => [];
}

class PoseDetected extends SquatEvent {
  final Pose pose;

  const PoseDetected(this.pose);
}

class StartGame extends SquatEvent {}

class Tick extends SquatEvent {
  final int remainingTime;
  const Tick(this.remainingTime);
  @override
  List<Object> get props => [remainingTime];
}

class ResetGame extends SquatEvent {}
