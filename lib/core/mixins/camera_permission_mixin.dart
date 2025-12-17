import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/camera_permission_dialog.dart';

mixin CameraPermissionMixin<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  CameraDescription? frontCamera;
  bool isLoading = true;
  bool _isDialogShowing = false;

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
        if (!_isDialogShowing) {
          _showPermissionDialog();
        }
      }
      return;
    }

    // Permission granted!
    if (mounted) {
      if (_isDialogShowing && Navigator.canPop(context)) {
        // We only want to pop if it's OUR dialog.
        // But since we can't easily identify, we rely on _isDialogShowing
        // However, CameraPermissionDialog pops itself on "Change Permission".
        // So _isDialogShowing might be true but dialog is already gone?
        // Let's rely on logic: if we opened settings via our dialog,
        // the dialog was closed BEFORE settings opened.
        // So _isDialogShowing should be false?
        // Ah, our updated implementation sets _isDialogShowing = false ON POP.
        // But we need to handle the case where user comes back from settings.
      }
      // Actually, if we closed the dialog before opening settings,
      // _isDialogShowing is likely false (if we handled it correctly).
      // Let's refine the mixin's dialog logic to match the robust implementation.
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

  void _showPermissionDialog() {
    _isDialogShowing = true;
    CameraPermissionDialog.show(context).then((_) {
      _isDialogShowing = false;
      // When dialog closes, if permission is still denied, we might need to handle it?
      // But typically we either pop page or go to settings.
      // If we come back from settings, lifecycle triggers initCameras agian.
    });
  }
}
