import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/mixins/camera_permission_mixin.dart';
import '../../../../../core/widgets/camera_denied_screen.dart';
import '../../../../../core/di/injection.dart';
import '../../../domain/usecases/detect_simon_move.dart';
import '../../bloc/simon_says/simon_says_bloc.dart';
import '../../bloc/simon_says/simon_says_event.dart';
import '../../bloc/simon_says/simon_says_state.dart';
import '../../widgets/camera_preview.dart';

class SimonSaysGamePage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const SimonSaysGamePage({super.key, this.cameras});

  @override
  State<SimonSaysGamePage> createState() => _SimonSaysGamePageState();
}

class _SimonSaysGamePageState extends State<SimonSaysGamePage>
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
      create: (_) => SimonSaysBloc(getIt<DetectSimonMove>()),
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
        body: BlocBuilder<SimonSaysBloc, SimonSaysState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Builder(
                  builder: (context) {
                    return CameraPreviewWidget(
                      camera: frontCamera!,
                      onPoseDetected: (pose) {
                        context.read<SimonSaysBloc>().add(PoseDetected(pose));
                      },
                    );
                  },
                ),

                if (state.status == SimonGameStatus.initial)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.directions_run,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "أوامر القائد",
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
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 24,
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "نفذ الأوامر التي تظهر على الشاشة بسرعة!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
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
                            onPressed: () =>
                                context.read<SimonSaysBloc>().add(StartGame()),
                            child: const Text(
                              "ابدأ اللعبة",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (state.status == SimonGameStatus.active)
                  Stack(
                    children: [
                      Positioned(
                        top: 50,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.timer, color: Colors.white70),
                              Text(
                                "${state.remainingTime}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (state.feedback != null)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Text(
                              state.feedback!,
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
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
                  ),

                if (state.status == SimonGameStatus.gameOver)
                  Container(
                    color: Colors.black87,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "انتهى الوقت!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "النتيجة: ${state.score}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "أعلى نتيجة: ${state.highScore}",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 24,
                            ),
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
                            onPressed: () =>
                                context.read<SimonSaysBloc>().add(StartGame()),
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
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
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
