import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import '../../../domain/usecases/detect_squat.dart';
import 'squat_event.dart';
import 'squat_state.dart';

class SquatBloc extends Bloc<SquatEvent, SquatState> {
  final DetectSquat _detectSquat;
  final GetStorage _storage = GetStorage();
  Timer? _timer;
  static const int _gameDuration = 60;

  SquatBloc(this._detectSquat) : super(const SquatState()) {
    on<PoseDetected>(_onPoseDetected);
    on<StartGame>(_onStartGame);
    on<Tick>(_onTick);
    on<ResetGame>(_onResetGame);

    final savedScore = _storage.read<int>('squat_high_score') ?? 0;
    emit(SquatState(highScore: savedScore));
  }

  void _onStartGame(StartGame event, Emitter<SquatState> emit) {
    _timer?.cancel();
    _detectSquat.reset();

    emit(SquatState(
      status: SquatGameStatus.active,
      score: 0,
      highScore: state.highScore,
      remainingTime: _gameDuration,
      feedback: "انطلاق!",
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(Tick(_gameDuration - timer.tick));
    });
  }

  void _onTick(Tick event, Emitter<SquatState> emit) {
    if (event.remainingTime > 0) {
      emit(SquatState(
        status: state.status,
        score: state.score,
        highScore: state.highScore,
        remainingTime: event.remainingTime,
        feedback: state.feedback,
      ));
    } else {
      _timer?.cancel();

      final currentScore = state.score;
      final currentHigh = state.highScore;
      int newHigh = currentHigh;

      if (currentScore > currentHigh) {
        newHigh = currentScore;
        _storage.write('squat_high_score', newHigh);
      }

      emit(SquatState(
        status: SquatGameStatus.gameOver,
        score: state.score,
        highScore: newHigh,
        remainingTime: 0,
        feedback: "انتهى الوقت!",
      ));
    }
  }

  void _onPoseDetected(PoseDetected event, Emitter<SquatState> emit) {
    if (state.status != SquatGameStatus.active) return;

    final result = _detectSquat(event.pose);

    if (result == true) {
      emit(SquatState(
        status: state.status,
        score: state.score + 1,
        highScore: state.highScore,
        remainingTime: state.remainingTime,
        feedback: "ممتاااز!",
      ));
    }
  }

  void _onResetGame(ResetGame event, Emitter<SquatState> emit) {
    _timer?.cancel();
    _detectSquat.reset();
    emit(SquatState(
      status: SquatGameStatus.initial,
      score: 0,
      highScore: state.highScore,
      remainingTime: _gameDuration,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
