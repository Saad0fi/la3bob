import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class MLKitUtils {
  static InputImage? inputImageFromCameraImage(
    CameraImage image,
    CameraDescription? camera,
    InputImageRotation rotation,
  ) {
    // If we are on Android and forcing NV21, we can just concatenate planes.
    // NV21 is YUV 4:2:0 semi-planar directly supported by ML Kit.
    // However, Camera package might give us 3 planes even for NV21 sometimes,
    // or we might need to be careful.

    // Standard approach recommended by google_mlkit_commons for Android:
    if (Platform.isAndroid) {
      final inputImageFormat = InputImageFormatValue.fromRawValue(
        image.format.raw,
      );
      // Fallback or explicit known formats
      final format = inputImageFormat ?? InputImageFormat.nv21;

      // Concatenate planes
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final inputImageMetadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
    }

    // iOS
    if (Platform.isIOS) {
      final inputImageFormat = InputImageFormatValue.fromRawValue(
        image.format.raw,
      );
      if (inputImageFormat == null) return null;

      // On iOS, typically BGRA8888, single plane
      final bytes = image.planes[0].bytes;
      final inputImageMetadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: inputImageFormat,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
    }

    return null;
  }
}
