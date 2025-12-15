import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/detect_jump.dart';
import '../bloc/jump_bloc.dart';
import '../bloc/jump_event.dart';
import '../bloc/jump_state.dart';
import '../widgets/camera_preview.dart';

class JumpGamePage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const JumpGamePage({super.key, this.cameras});

  @override
  State<JumpGamePage> createState() => _JumpGamePageState();
}

class _JumpGamePageState extends State<JumpGamePage> {
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

    // Creating Bloc locally since we don't have it in main provider list (optional)
    return BlocProvider(
      create: (_) => JumpBloc(getIt<DetectJump>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🦘 تحدي القفز'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: BlocBuilder<JumpBloc, JumpState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // 1. Camera Layer
                Builder(
                  builder: (context) {
                    return CameraPreviewWidget(
                      camera: _frontCamera!,
                      onPoseDetected: (pose) {
                        context.read<JumpBloc>().add(PoseDetected(pose));
                      },
                    );
                  },
                ),

                // 2. Game Layer
                if (state.status == JumpGameStatus.active)
                  _buildGameLayer(context, state),

                // 3. UI Layer (Start / Game Over)
                if (state.status == JumpGameStatus.initial)
                  _buildStartScreen(context, state),

                if (state.status == JumpGameStatus.gameOver)
                  _buildGameOverScreen(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameLayer(BuildContext context, JumpState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // Ground line
        final groundY = height * 0.8;

        return Stack(
          children: [
            // Ground
            Positioned(
              bottom: height * 0.1,
              left: 0,
              right: 0,
              height: 10,
              child: Container(color: Colors.greenAccent),
            ),

            // Player
            // X = 15%
            // Y: if grounded -> bottom at 20% (ground). if jumping -> bottom at 40%.
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              left: width * 0.15, // Fixed X
              bottom: state.playerState == PlayerState.jumping
                  ? height * 0.45
                  : height * 0.20, // Ground level
              child: const Icon(
                Icons.accessibility_new,
                size: 80,
                color: Colors.yellow,
              ),
            ),

            // Obstacles
            ...state.obstacles.map((obs) {
              return Positioned(
                left: obs.x * width, // 0.0 to 1.0 mapped to width
                bottom: height * 0.20, // On ground
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt, color: Colors.white),
                ),
              );
            }),

            // HUD
            Positioned(
              top: 80,
              right: 20,
              child: Text(
                "النقاط: ${state.score}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStartScreen(BuildContext context, JumpState state) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "تحدي القفز",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "أعلى نتيجة: ${state.highScore}",
              style: const TextStyle(color: Colors.yellow, fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => context.read<JumpBloc>().add(StartGame()),
              child: const Text("ابدأ اللعبة", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverScreen(BuildContext context, JumpState state) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "انتهت اللعبة!",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "النقاط: ${state.score}",
              style: const TextStyle(color: Colors.white, fontSize: 28),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.read<JumpBloc>().add(StartGame()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: const Text(
                "حاول مرة أخرى",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => context.read<JumpBloc>().add(ResetGame()),
              child: const Text(
                "العودة للقائمة",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
