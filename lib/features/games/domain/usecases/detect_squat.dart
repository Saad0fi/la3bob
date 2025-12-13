import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../repositories/squat_repository.dart';

class DetectSquat {
  final SquatRepository repository;

  DetectSquat(this.repository);

  // Returns true if a squat is completed
  bool? call(Pose pose) => repository.detectSquat(pose);

  void reset() => repository.reset();
}
