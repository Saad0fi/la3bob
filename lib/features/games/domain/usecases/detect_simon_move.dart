import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../repositories/simon_says_repository.dart';

class DetectSimonMove {
  final SimonSaysRepository _repository;

  DetectSimonMove(this._repository);

  SimonMove? call(Pose pose) {
    return _repository.detectMove(pose);
  }

  void reset() {
    _repository.reset();
  }
}
