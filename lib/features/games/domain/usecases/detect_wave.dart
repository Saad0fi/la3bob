import '../repositories/wave_repository.dart';
import '../entities/wave_movement.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class DetectWave {
  final WaveRepository repository;

  DetectWave(this.repository);

  WaveMovement? call(Pose pose) => repository.detectWave(pose);
}
