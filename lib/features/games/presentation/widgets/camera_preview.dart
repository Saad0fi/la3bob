import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import '../../data/providers/pose_provider.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:async';

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

  int framesProcessed = 0;
  String lastError = "None";
  int posesFound = 0;
  int lastFormatRaw = 0;

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

        try {
          final rawFmt = image.format.raw;

          final poses = await _poseProvider.processImage(image, rotation);

          if (mounted) {
            setState(() {
              framesProcessed++;
              posesFound = poses.length;
              lastError = "OK";
              lastFormatRaw = rawFmt;
            });

            if (poses.isNotEmpty) {
              final pose = poses.first;
              widget.onPoseDetected(pose);
            } else {}
          }
        } catch (e) {
          if (mounted) setState(() => lastError = e.toString());
        } finally {
          _isProcessing = false;
        }
      });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      if (mounted) setState(() => lastError = "Init Fail: $e");
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
      return Center(child: Text("Initializing Camera... Error: $lastError"));
    }

    return Stack(fit: StackFit.expand, children: [CameraPreview(_controller)]);
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
