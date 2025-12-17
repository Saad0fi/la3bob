import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

mixin CameraPermissionMixin<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  CameraDescription? frontCamera;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCameras();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initCameras();
    }
  }

  Future<void> initCameras() async {
    // 1. Check Permissions
    var status = await Permission.camera.status;

    // Only request if first run and not granted
    if (isLoading && !status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isPermanentlyDenied || status.isDenied) {
      if (mounted) {
        setState(() {
          isLoading = false;
          frontCamera = null;
        });
      }
      return;
    }

    // 2. Initialize Cameras
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        frontCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );
      }
    } catch (e) {
      debugPrint('Error fetching cameras: $e');
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
