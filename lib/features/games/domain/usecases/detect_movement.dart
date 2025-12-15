import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../repositories/freeze_repository.dart';

class DetectMovement {
  final FreezeRepository _repository;

  DetectMovement(this._repository);

  double call(Pose pose) {
    return _repository.detectMovement(pose);
  }

  void reset() {
    _repository.reset();
  }
}
