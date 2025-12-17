import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/mixins/camera_permission_mixin.dart';
import '../../../../../core/widgets/camera_denied_screen.dart';
import '../../../../../core/di/injection.dart';
import '../../../domain/usecases/detect_jump.dart';
import '../../bloc/jump/jump_bloc.dart';
import '../../bloc/jump/jump_event.dart';
import '../../bloc/jump/jump_state.dart';
import '../../widgets/camera_preview.dart';

class JumpGamePage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const JumpGamePage({super.key, this.cameras});

  @override
  State<JumpGamePage> createState() => _JumpGamePageState();
}

class _JumpGamePageState extends State<JumpGamePage>
    with WidgetsBindingObserver, CameraPermissionMixin {
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (frontCamera == null) {
      return const CameraDeniedScreen();
    }

    return BlocProvider(
      create: (_) => JumpBloc(getIt<DetectJump>()),
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
        body: BlocBuilder<JumpBloc, JumpState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Builder(
                  builder: (context) {
                    return CameraPreviewWidget(
                      camera: frontCamera!,
                      onPoseDetected: (pose) {
                        context.read<JumpBloc>().add(PoseDetected(pose));
                      },
                    );
                  },
                ),

                if (state.status == JumpGameStatus.active)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final height = constraints.maxHeight;

                      return Stack(
                        children: [
                          Positioned(
                            bottom: height * 0.1,
                            left: 0,
                            right: 0,
                            height: 10,
                            child: Container(color: Colors.greenAccent),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 100),
                            left: width * 0.15,
                            bottom: state.playerState == PlayerState.jumping
                                ? height * 0.45
                                : height * 0.20,
                            child: const Icon(
                              Icons.accessibility_new,
                              size: 80,
                              color: Colors.yellow,
                            ),
                          ),
                          ...state.obstacles.map((obs) {
                            return Positioned(
                              left: obs.x * width,
                              bottom: height * 0.20,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.bolt,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }),
                          Positioned(
                            top: 80,
                            right: 20,
                            child: Text(
                              "النقاط: ${state.score}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 5, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                if (state.status == JumpGameStatus.initial)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/long-jump.png',
                            height: 100,
                            fit: BoxFit.contain,
                          ),
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
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "اقفز لتتجنب العوائق القادمة نحوك!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (state.calibrationMessage != null)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: state.isCalibrated
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                state.calibrationMessage!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
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
                            onPressed: () =>
                                context.read<JumpBloc>().add(StartGame()),
                            child: const Text(
                              "ابدأ اللعبة",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (state.status == JumpGameStatus.gameOver)
                  Container(
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<JumpBloc>().add(StartGame()),
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
                            onPressed: () =>
                                context.read<JumpBloc>().add(ResetGame()),
                            child: const Text(
                              "العودة للقائمة",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
