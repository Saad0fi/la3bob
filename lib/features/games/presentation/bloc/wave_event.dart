import 'package:equatable/equatable.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class WaveEvent extends Equatable {
  const WaveEvent();

  @override
  List<Object?> get props => [];
}

class PoseReceived extends WaveEvent {
  final Pose pose;

  const PoseReceived(this.pose);

  @override
  List<Object?> get props => [pose];
}

class ResetWave extends WaveEvent {}
