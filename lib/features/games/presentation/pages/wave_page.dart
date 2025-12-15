import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../../presentation/bloc/wave_bloc.dart';
import '../../presentation/bloc/wave_event.dart';
import '../../presentation/bloc/wave_state.dart';
import '../../presentation/widgets/camera_preview.dart';
import '../../domain/usecases/detect_wave.dart';
import '../../../../../../core/di/injection.dart'; // import getIt

class WaveGamePage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const WaveGamePage({super.key, this.cameras});

  @override
  State<WaveGamePage> createState() => _WaveGamePageState();
}

class _WaveGamePageState extends State<WaveGamePage> {
  // We can load cameras here or in the view.
  // keeping initialization logical logic here is fine,
  // but we usually want the BlocProvider to be the top level of this "Screen".

  @override
  Widget build(BuildContext context) {
    // Inject dependencies
    // Use GetIt to resolve DetectWave.
    return BlocProvider(
      create: (_) => WaveBloc(getIt<DetectWave>()),
      child: WaveGameView(cameras: widget.cameras),
    );
  }
}

class WaveGameView extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const WaveGameView({super.key, this.cameras});

  @override
  State<WaveGameView> createState() => _WaveGameViewState();
}

class _WaveGameViewState extends State<WaveGameView> {
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

    return Scaffold(
      appBar: AppBar(title: const Text('👋 لعبة التلويح')),
      body: Stack(
        children: [
          // Camera Preview
          SizedBox.expand(
            child: CameraPreviewWidget(
              camera: _frontCamera!,
              onPoseDetected: (pose) {
                // Now 'context' is from _WaveGameViewState, which is a child of BlocProvider
                context.read<WaveBloc>().add(PoseReceived(pose));
              },
            ),
          ),

          // UI Overlay
          Positioned(
            top: 30,
            right: 20, // Right align for Arabic
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BlocConsumer<WaveBloc, WaveState>(
                listener: (context, state) {
                  if (state.status == WaveStatus.waveDetected) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم اكتشاف تلويح! 👋'),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Text(
                    'عدد التلويحات: ${state.count}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () => context.read<WaveBloc>().add(ResetWave()),
      ),
    );
  }
}
