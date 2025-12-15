import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../repositories/jump_repository.dart';

class DetectJump {
  final JumpRepository repository;

  DetectJump(this.repository);

  // Returns true if jumping
  bool? call(Pose pose) => repository.detectJump(pose);

  void reset() => repository.reset();
}
