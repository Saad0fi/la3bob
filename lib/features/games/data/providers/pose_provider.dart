import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import '../utils/ml_kit_utils.dart';

class PoseProvider {
  final PoseDetector _detector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );

  /// Processes a single [CameraImage] and returns recognized Poses.
  /// Returns empty list if processing fails or no poses found.
  Future<List<Pose>> processImage(
    CameraImage image,
    InputImageRotation rotation,
  ) async {
    try {
      final inputImage = MLKitUtils.inputImageFromCameraImage(
        image,
        null,
        rotation,
      );

      if (inputImage == null) return [];

      return await _detector.processImage(inputImage);
    } catch (e) {
      if (kDebugMode) {
        print("PoseProvider Error: $e");
      }
      return [];
    }
  }

  void dispose() => _detector.close();
}
