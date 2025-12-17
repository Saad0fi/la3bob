import 'dart:async';
import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../core/comon/helper_function/audio_helper.dart';
import '../../../domain/repositories/simon_says_repository.dart';
import '../../../domain/usecases/detect_simon_move.dart';
import 'simon_says_event.dart';
import 'simon_says_state.dart';

class SimonSaysBloc extends Bloc<SimonSaysEvent, SimonSaysState> {
  final DetectSimonMove _detectSimonMove;
  final GetStorage _storage = GetStorage();
  final Random _random = Random();
  Timer? _commandTimer;
  Timer? _gameTimer;

  DateTime? _lastPoseTime;

  final Map<SimonMove, String> _moveDescriptions = {
    SimonMove.raiseRightHand: "ارفع يدك اليمنى",
    SimonMove.raiseLeftHand: "ارفع يدك اليسرى",
    SimonMove.standOnRightLeg: "قف على رجلك اليمنى",
    SimonMove.standOnLeftLeg: "قف على رجلك اليسرى",
    SimonMove.squat: "قرفصاء (Squat)",
  };

  final Map<SimonMove, String> _moveAudioFiles = {
    SimonMove.raiseRightHand: "ارفع يدك اليمنى",
    SimonMove.raiseLeftHand: "اربع يدك اليسرى",
    SimonMove.standOnRightLeg: "قف على رجلك اليمنى",
    SimonMove.standOnLeftLeg: "قف على رجلك اليسرى",
    SimonMove.squat: "قرفصاء",
  };

  SimonSaysBloc(this._detectSimonMove) : super(const SimonSaysState()) {
    on<StartGame>(_onStartGame);
    on<ResetGame>(_onResetGame);
    on<PoseDetected>(_onPoseDetected);
    on<NextCommand>(_onNextCommand);
    on<Tick>(_onTick);

    final savedScore = _storage.read<int>('simon_high_score') ?? 0;
    emit(SimonSaysState(highScore: savedScore));
  }

  void _onStartGame(StartGame event, Emitter<SimonSaysState> emit) {
    _gameTimer?.cancel();

    emit(
      SimonSaysState(
        status: SimonGameStatus.heightCheck, 
        score: 0,
        highScore: state.highScore,
        remainingTime: 60,
        message:
            "تراجع للخلف حتى يظهر جسمك بالكامل", 
        feedback: null,
      ),
    );

  
  }

  void _onTick(Tick event, Emitter<SimonSaysState> emit) {
    if (state.isWaitingForNeutral &&
        state.status == SimonGameStatus.active &&
        _lastPoseTime != null) {
      final diff = DateTime.now().difference(_lastPoseTime!);
      if (diff.inMilliseconds > 1500) {
        add(NextCommand());
      }
    }

    if (event.remainingTime > 0) {
      emit(
        SimonSaysState(
          status: state.status,
          currentCommand: state.currentCommand,
          score: state.score,
          highScore: state.highScore,
          remainingTime: event.remainingTime,
          isWaitingForNeutral: state.isWaitingForNeutral,
          message: state.message,
          feedback: state.feedback,
        ),
      );
    } else {
      _gameTimer?.cancel();
      _commandTimer?.cancel();

      AudioHelper.playSimonTimeUp();

      final currentScore = state.score;
      int newHigh = state.highScore;
      if (currentScore > newHigh) {
        newHigh = currentScore;
        _storage.write('simon_high_score', newHigh);
      }

      emit(
        SimonSaysState(
          status: SimonGameStatus.gameOver,
          score: currentScore,
          highScore: newHigh,
          remainingTime: 0,
          message: "انتهى الوقت!",
          feedback: "النتيجة: $currentScore",
        ),
      );
    }
  }

  void _onNextCommand(NextCommand event, Emitter<SimonSaysState> emit) {
    if (state.status != SimonGameStatus.active) return;

    final moves = [
      SimonMove.raiseRightHand,
      SimonMove.raiseLeftHand,
      SimonMove.standOnRightLeg,
      SimonMove.standOnLeftLeg,
      SimonMove.squat,
    ];
    final nextMove = moves[_random.nextInt(moves.length)];

    AudioHelper.playSimonCommand(_moveAudioFiles[nextMove]!);

    emit(
      SimonSaysState(
        status: state.status,
        currentCommand: nextMove,
        score: state.score,
        highScore: state.highScore,
        remainingTime: state.remainingTime,
        isWaitingForNeutral: false,
        message: _moveDescriptions[nextMove]!,
      ),
    );
  }

  void _onPoseDetected(PoseDetected event, Emitter<SimonSaysState> emit) {
    _lastPoseTime = DateTime.now();

  
    if (state.status == SimonGameStatus.heightCheck) {
      final pose = event.pose;

     
      final nose = pose.landmarks[PoseLandmarkType.nose];
      final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
      final rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

      bool isFullBodyVisible = false;
      if (nose != null && leftAnkle != null && rightAnkle != null) {
        if (nose.likelihood > 0.5 &&
            leftAnkle.likelihood > 0.5 &&
            rightAnkle.likelihood > 0.5) {
          isFullBodyVisible = true;
        }
      }

      if (isFullBodyVisible) {
      
        emit(
          SimonSaysState(
            status: SimonGameStatus.active,
            score: 0,
            highScore: state.highScore,
            remainingTime: 60,
            message: "ممتاز! استعد...", 
            feedback: "✅",
          ),
        );

       
        _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          add(Tick(60 - timer.tick));
        });

      
        Future.delayed(const Duration(seconds: 2), () {
          add(NextCommand());
        });
      } else {

        if (state.message != "تراجع للخلف حتى يظهر جسمك بالكامل") {
          emit(
            SimonSaysState(
              status: SimonGameStatus.heightCheck,
              highScore: state.highScore,
              message: "تراجع للخلف حتى يظهر جسمك بالكامل",
            ),
          );
        }
      }
      return;
    }

    if (state.status != SimonGameStatus.active) return;

    final detected = _detectSimonMove(event.pose);

    if (state.isWaitingForNeutral) {
      if (detected == null || detected == SimonMove.nothing) {
        add(NextCommand());
      }
      return;
    }

    if (state.currentCommand == null) return;

    if (detected == state.currentCommand) {
      AudioHelper.playSimonCorrect();
      emit(
        SimonSaysState(
          status: state.status,
          score: state.score + 1,
          highScore: state.highScore,
          remainingTime: state.remainingTime,
          isWaitingForNeutral: true,
          message: "قف باعتدال...",
          feedback: "صحيح! ✅",
        ),
      );
    }
  }

  void _onResetGame(ResetGame event, Emitter<SimonSaysState> emit) {
    _commandTimer?.cancel();
    _gameTimer?.cancel();
    emit(SimonSaysState(highScore: state.highScore));
  }

  @override
  Future<void> close() {
    _commandTimer?.cancel();
    _gameTimer?.cancel();
    return super.close();
  }
}
