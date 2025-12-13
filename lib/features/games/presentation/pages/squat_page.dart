import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/detect_squat.dart';
import '../bloc/squat_bloc.dart';
import '../bloc/squat_event.dart';
import '../bloc/squat_state.dart';
import '../widgets/camera_preview.dart';

class SquatGamePage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const SquatGamePage({Key? key, this.cameras}) : super(key: key);

  @override
  State<SquatGamePage> createState() => _SquatGamePageState();
}

class _SquatGamePageState extends State<SquatGamePage> {
  CameraDescription? _frontCamera;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    List<CameraDescription> cams = widget.cameras ?? [];
    if (cams.isEmpty) {
      try {
        cams = await availableCameras();
      } catch (e) {
        debugPrint('Error fetching cameras: $e');
      }
    }

    if (cams.isNotEmpty) {
      _frontCamera = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cams.first,
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_frontCamera == null) {
      return const Scaffold(body: Center(child: Text('No camera found')));
    }

    return BlocProvider(
      create: (_) => SquatBloc(getIt<DetectSquat>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('🏋️ Squat Game')),
        body: Stack(
          children: [
            // Camera Preview
            Builder(
              builder: (context) {
                return SizedBox.expand(
                  child: CameraPreviewWidget(
                    camera: _frontCamera!,
                    onPoseDetected: (pose) {
                      context.read<SquatBloc>().add(PoseDetected(pose));
                    },
                  ),
                );
              },
            ),

            // UI Overlay
            Positioned(
              top: 30,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BlocConsumer<SquatBloc, SquatState>(
                  listener: (context, state) {
                    if (state.feedback != null && state.feedback!.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        // Basic feedback
                        SnackBar(
                          content: Text(state.feedback!),
                          duration: const Duration(milliseconds: 500),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Squats: ${state.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (state.status == SquatGameStatus.active)
                          const Text(
                            'Keep going!',
                            style: TextStyle(color: Colors.greenAccent),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () => context.read<SquatBloc>().add(ResetGame()),
            );
          },
        ),
      ),
    );
  }
}
