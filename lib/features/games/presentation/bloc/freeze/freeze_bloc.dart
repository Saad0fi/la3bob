import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../core/comon/helper_function/audio_helper.dart';
import '../../../domain/usecases/detect_movement.dart';
import 'freeze_event.dart';
import 'freeze_state.dart';

class FreezeBloc extends Bloc<FreezeEvent, FreezeState> {
  final DetectMovement _detectMovement;
  final GetStorage _storage = GetStorage();
  final Random _random = Random();
  Timer? _phaseTimer;
  Timer? _voiceTimer;

  final double _freezeThreshold = 0.04;

  FreezeBloc(this._detectMovement) : super(const FreezeState()) {
    on<StartGame>(_onStartGame);
    on<ResetGame>(_onResetGame);
    on<PoseDetected>(_onPoseDetected);
    on<SwitchPhase>(_onSwitchPhase);

    on<EndGracePeriod>((event, emit) {
      emit(state.copyWith(isGracePeriod: false));
    });

    final savedScore = _storage.read<int>('freeze_high_score') ?? 0;
    emit(state.copyWith(highScore: savedScore));
  }

  void _onStartGame(StartGame event, Emitter<FreezeState> emit) {
    _detectMovement.reset();
    emit(
      state.copyWith(
        phase: FreezePhase.dancing,
        score: 0,
        message: "تحرك! (Move!)",
        isGracePeriod: false,
      ),
    );
    _startMoveVoice();
    _scheduleMakeFreeze();
  }

  void _startMoveVoice() {
    _voiceTimer?.cancel();
    AudioHelper.playFreezeMove();
    _voiceTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (state.phase == FreezePhase.dancing) {
        AudioHelper.playFreezeMove();
      }
    });
  }

  void _stopVoice() {
    _voiceTimer?.cancel();
    AudioHelper.stopFreezeAudio();
  }

  void _scheduleMakeFreeze() {
    _phaseTimer?.cancel();

    final duration = Duration(milliseconds: 3000 + _random.nextInt(3000));
    _phaseTimer = Timer(duration, () {
      if (!isClosed) add(SwitchPhase());
    });
  }

  void _scheduleMakeDance() {
    _phaseTimer?.cancel();

    final duration = Duration(milliseconds: 2000 + _random.nextInt(2000));
    _phaseTimer = Timer(duration, () {
      if (!isClosed) add(SwitchPhase());
    });
  }

  void _onSwitchPhase(SwitchPhase event, Emitter<FreezeState> emit) {
    if (state.phase == FreezePhase.gameOver) return;

    if (state.phase == FreezePhase.dancing) {
      _stopVoice();
      AudioHelper.playFreezeStop();

      emit(
        state.copyWith(
          phase: FreezePhase.freezing,
          message: "توقف! ",
          isGracePeriod: true,
        ),
      );
      Timer(const Duration(seconds: 1), () {
        if (!isClosed) add(EndGracePeriod());
      });

      _scheduleMakeDance();
    } else if (state.phase == FreezePhase.freezing) {
      emit(
        state.copyWith(
          phase: FreezePhase.dancing,
          score: state.score + 10,
          message: "تحرك! ",
          isGracePeriod: false,
        ),
      );
      _startMoveVoice();
      _scheduleMakeFreeze();
    }
  }

  void _onPoseDetected(PoseDetected event, Emitter<FreezeState> emit) {
    if (state.phase == FreezePhase.gameOver) return;
    if (state.phase == FreezePhase.initial) return;

    final movement = _detectMovement(event.pose);

    emit(state.copyWith(currentMovement: movement));

    if (state.phase == FreezePhase.freezing) {
      if (state.isGracePeriod) return;

      if (movement > _freezeThreshold) {
        _gameOver(emit);
      } else {}
    } else {}
  }

  void _gameOver(Emitter<FreezeState> emit) {
    _phaseTimer?.cancel();
    _stopVoice();

    int newHigh = state.highScore;
    if (state.score > newHigh) {
      newHigh = state.score;
      _storage.write('freeze_high_score', newHigh);
    }

    emit(
      state.copyWith(
        phase: FreezePhase.gameOver,
        highScore: newHigh,
        message: "خسرت! (تحركت أثناء التوقف)",
      ),
    );
  }

  void _onResetGame(ResetGame event, Emitter<FreezeState> emit) {
    _phaseTimer?.cancel();
    _stopVoice();
    _detectMovement.reset();
    emit(state.copyWith(phase: FreezePhase.initial, message: "استعد للعب!"));
  }

  @override
  Future<void> close() {
    _phaseTimer?.cancel();
    _stopVoice();
    return super.close();
  }
}
