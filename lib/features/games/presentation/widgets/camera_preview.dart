import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import '../../data/providers/pose_provider.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:async';
import 'pose_painter.dart';

class CameraPreviewWidget extends StatefulWidget {
  final CameraDescription camera;
  final Function(Pose) onPoseDetected;

  const CameraPreviewWidget({
    super.key,
    required this.camera,
    required this.onPoseDetected,
  });

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _controller;
  late PoseProvider _poseProvider;

  bool _isInitialized = false;
  bool _isProcessing = false;

  // Debug stats
  int _framesProcessed = 0;
  String _lastError = "None";
  int _posesFound = 0;
  int _lastFormatRaw = 0;

  // Painter state
  CustomPaint? _customPaint;
  Size? _cameraImageSize;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _poseProvider = PoseProvider();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _controller.initialize();
      if (!mounted) return;

      final rotation = _getRotation();

      await _controller.startImageStream((image) async {
        if (_isProcessing) return;

        _isProcessing = true;
        _cameraImageSize = Size(
          image.width.toDouble(),
          image.height.toDouble(),
        );

        try {
          // Capture raw format for debug
          final rawFmt = image.format.raw;

          final poses = await _poseProvider.processImage(image, rotation);

          if (mounted) {
            setState(() {
              _framesProcessed++;
              _posesFound = poses.length;
              _lastError = "OK";
              _lastFormatRaw = rawFmt;
            });

            if (poses.isNotEmpty) {
              final pose = poses.first;
              widget.onPoseDetected(pose);

              final painter = PosePainter([pose], _cameraImageSize!, rotation);
              setState(() {
                _customPaint = CustomPaint(painter: painter);
              });
            } else {
              setState(() => _customPaint = null);
            }
          }
        } catch (e) {
          if (mounted) setState(() => _lastError = e.toString());
        } finally {
          _isProcessing = false;
        }
      });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      if (mounted) setState(() => _lastError = "Init Fail: $e");
    }
  }

  @override
  void dispose() {
    if (_controller.value.isStreamingImages) {
      _controller.stopImageStream();
    }
    _controller.dispose();
    _poseProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Center(child: Text("Initializing Camera... Error: $_lastError"));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_controller),
        if (_customPaint != null) _customPaint!,

        // Debug Overlay
        Positioned(
          top: 100,
          left: 10,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "DEBUG INFO (SamFix)",
                  style: TextStyle(color: Colors.yellow),
                ),
                Text(
                  "Error: $_lastError",
                  style: const TextStyle(color: Colors.redAccent),
                ),
                Text(
                  "Frames: $_framesProcessed",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  "Poses: $_posesFound",
                  style: const TextStyle(color: Colors.greenAccent),
                ),
                Text(
                  "Fmt Raw: $_lastFormatRaw",
                  style: const TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputImageRotation _getRotation() {
    final sensorOrientation = widget.camera.sensorOrientation;
    switch (sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }
}
