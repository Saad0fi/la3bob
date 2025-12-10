import 'package:la3bob/features/games/domain/entities/wave_movement.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class WaveRepository {
  /// Returns a [WaveMovement] when a wave is detected, otherwise null.
  WaveMovement? detectWave(Pose pose);
}
