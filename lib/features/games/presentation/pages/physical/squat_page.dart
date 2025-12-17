import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/widgets/camera_denied_screen.dart';
import '../../../domain/usecases/detect_squat.dart';
import '../../bloc/squat/squat_bloc.dart';
import '../../bloc/squat/squat_event.dart';
import '../../bloc/squat/squat_state.dart';
import '../../widgets/camera_preview.dart';
import '../../../../../core/mixins/camera_permission_mixin.dart';

class SquatGamePage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const SquatGamePage({super.key, this.cameras});

  @override
  State<SquatGamePage> createState() => _SquatGamePageState();
}

class _SquatGamePageState extends State<SquatGamePage>
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
      create: (_) => SquatBloc(getIt<DetectSquat>()),
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
        body: BlocConsumer<SquatBloc, SquatState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Builder(
                  builder: (context) {
                    return SizedBox.expand(
                      child: CameraPreviewWidget(
                        camera: frontCamera!,
                        onPoseDetected: (pose) {
                          context.read<SquatBloc>().add(PoseDetected(pose));
                        },
                      ),
                    );
                  },
                ),

                if (state.status == SquatGameStatus.initial)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.fitness_center,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "تحدي القرفصاء",
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
                              "قم بأكبر عدد من القرفصاء خلال 60 ثانية!",
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
                                context.read<SquatBloc>().add(StartGame()),
                            child: const Text(
                              "ابدأ اللعبة (60 ثانية)",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (state.status == SquatGameStatus.active)
                  Stack(
                    children: [
                      Positioned(
                        top: 50,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: state.remainingTime <= 10
                                  ? Colors.red.withValues(alpha: .8)
                                  : Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${state.remainingTime}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
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
                      if (state.feedback != null)
                        Align(
                          alignment: Alignment.center,
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
                    ],
                  ),

                if (state.status == SquatGameStatus.gameOver)
                  Container(
                    color: Colors.black87,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "انتهى الوقت!",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "النتيجة النهائية: ${state.score}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "أعلى نتيجة: ${state.highScore}",
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () =>
                                    context.read<SquatBloc>().add(ResetGame()),
                                icon: const Icon(Icons.home),
                                label: const Text("القائمة"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    context.read<SquatBloc>().add(StartGame()),
                                icon: const Icon(Icons.refresh),
                                label: const Text("حاول مرة أخرى"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                ),
                              ),
                            ],
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
