import 'package:la3bob/features/games/domain/entities/wave_movement.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class WaveRepository {
  WaveMovement? detectWave(Pose pose);
}
