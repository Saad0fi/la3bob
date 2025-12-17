import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/mixins/camera_permission_mixin.dart';
import '../../../../../core/widgets/camera_denied_screen.dart';
import '../../../../../core/di/injection.dart';
import '../../../domain/usecases/detect_movement.dart';
import '../../bloc/freeze/freeze_bloc.dart';
import '../../bloc/freeze/freeze_event.dart';
import '../../bloc/freeze/freeze_state.dart';
import '../../widgets/camera_preview.dart';

class FreezeGamePage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const FreezeGamePage({super.key, this.cameras});

  @override
  State<FreezeGamePage> createState() => _FreezeGamePageState();
}

class _FreezeGamePageState extends State<FreezeGamePage>
    with WidgetsBindingObserver, CameraPermissionMixin {
  // frontCamera and isLoading managed by mixin

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If permission denied or no camera, show camera denied screen
    if (frontCamera == null) {
      return const CameraDeniedScreen();
    }

    return BlocProvider(
      create: (_) => FreezeBloc(getIt<DetectMovement>()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.go("/tabs/games");
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: BlocBuilder<FreezeBloc, FreezeState>(
          builder: (context, state) {
            Color borderColor = Colors.transparent;
            if (state.phase == FreezePhase.dancing) {
              borderColor = Colors.green.withValues(alpha: .5);
            } else if (state.phase == FreezePhase.freezing) {
              borderColor = Colors.red.withValues(alpha: .8);
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                // 1. Camera Layer
                CameraPreviewWidget(
                  camera: frontCamera!,
                  onPoseDetected: (pose) {
                    context.read<FreezeBloc>().add(PoseDetected(pose));
                  },
                ),

                // 2. Border/Overlay for Phases
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor, width: 20),
                    ),
                  ),
                ),

                // 3. Game UI
                if (state.phase == FreezePhase.initial)
                  _buildStartScreen(context, state),

                if (state.phase == FreezePhase.dancing ||
                    state.phase == FreezePhase.freezing)
                  _buildActiveGame(context, state),

                if (state.phase == FreezePhase.gameOver)
                  _buildGameOver(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStartScreen(BuildContext context, FreezeState state) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/running.png',
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "لعبة حركة ستوب",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (state.highScore > 0) ...[
              const SizedBox(height: 10),
              Text(
                "أعلى نتيجة: ${state.highScore}",
                style: const TextStyle(color: Colors.amber, fontSize: 24),
              ),
            ],
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "تحرك عندما يكون الضوء أخضر.\nتوقف تماماً عندما يصبح أحمر!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => context.read<FreezeBloc>().add(StartGame()),
              child: const Text("ابدأ اللعب", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGame(BuildContext context, FreezeState state) {
    // Determine status text/color
    String mainText = "";
    Color mainColor = Colors.white;
    IconData mainIcon = Icons.question_mark;

    if (state.phase == FreezePhase.dancing) {
      mainText = "تحرك! 💃";
      mainColor = Colors.green;
      mainIcon = Icons.directions_run;
    } else if (state.phase == FreezePhase.freezing) {
      mainText = "قف! ✋";
      mainColor = Colors.red;
      mainIcon = Icons.pan_tool;
    }

    return Stack(
      children: [
        // Top Center Status
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 100),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: .8),
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(mainIcon, color: Colors.white, size: 40),
                const SizedBox(height: 8),
                Text(
                  mainText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Score
        Positioned(
          top: 50,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  "النقاط",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  "${state.score}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameOver(BuildContext context, FreezeState state) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              state.message, // "You moved!"
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "النتيجة: ${state.score}",
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
            const SizedBox(height: 10),
            Text(
              "أعلى نتيجة: ${state.highScore}",
              style: const TextStyle(color: Colors.amber, fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => context.read<FreezeBloc>().add(ResetGame()),
              child: const Text(
                "العب مرة أخرى",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "خروج",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
