import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
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

  // Map moves to Arabic text
  final Map<SimonMove, String> _moveDescriptions = {
    SimonMove.raiseRightHand: "ارفع يدك اليمنى",
    SimonMove.raiseLeftHand: "ارفع يدك اليسرى",
    SimonMove.standOnRightLeg: "قف على رجلك اليمنى",
    SimonMove.standOnLeftLeg: "قف على رجلك اليسرى",
    SimonMove.squat: "قرفصاء (Squat)",
  };

  SimonSaysBloc(this._detectSimonMove) : super(const SimonSaysState()) {
    on<StartGame>(_onStartGame);
    on<ResetGame>(_onResetGame);
    on<PoseDetected>(_onPoseDetected);
    on<NextCommand>(_onNextCommand);
    on<Tick>(_onTick);

    final savedScore = _storage.read<int>('simon_high_score') ?? 0;
    emit(state.copyWith(highScore: savedScore));
  }

  void _onStartGame(StartGame event, Emitter<SimonSaysState> emit) {
    emit(
      state.copyWith(
        status: SimonGameStatus.active,
        score: 0,
        remainingTime: 60,
        message: "استعد...",
        feedback: null,
      ),
    );

    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(Tick(60 - timer.tick));
    });

    // Wait a brief moment then give first command
    Future.delayed(const Duration(seconds: 2), () {
      add(NextCommand());
    });
  }

  void _onTick(Tick event, Emitter<SimonSaysState> emit) {
    // Check for neutral timeout
    if (state.isWaitingForNeutral &&
        state.status == SimonGameStatus.active &&
        _lastPoseTime != null) {
      final diff = DateTime.now().difference(_lastPoseTime!);
      if (diff.inMilliseconds > 1500) {
        // Timeout! Assume neutral or lost track, move on.
        add(NextCommand());
      }
    }

    if (event.remainingTime > 0) {
      emit(state.copyWith(remainingTime: event.remainingTime));
    } else {
      _gameTimer?.cancel();
      _commandTimer?.cancel();

      // Game Over
      final currentScore = state.score;
      int newHigh = state.highScore;
      if (currentScore > newHigh) {
        newHigh = currentScore;
        _storage.write('simon_high_score', newHigh);
      }

      emit(
        state.copyWith(
          status: SimonGameStatus.gameOver,
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

    // Pick random move
    final moves = [
      SimonMove.raiseRightHand,
      SimonMove.raiseLeftHand,
      SimonMove.standOnRightLeg,
      SimonMove.standOnLeftLeg,
      SimonMove.squat,
    ];
    final nextMove = moves[_random.nextInt(moves.length)];

    emit(
      state.copyWith(
        currentCommand: nextMove,
        message: _moveDescriptions[nextMove]!,
        clearFeedback: true,
        isWaitingForNeutral: false,
      ),
    );
  }

  void _onPoseDetected(PoseDetected event, Emitter<SimonSaysState> emit) {
    if (state.status != SimonGameStatus.active) return;
    _lastPoseTime = DateTime.now();

    final detected = _detectSimonMove(event.pose);

    // 1. If waiting for neutral (player must return to standing/nothing)
    if (state.isWaitingForNeutral) {
      if (detected == null || detected == SimonMove.nothing) {
        // Player is back to neutral, trigger next command
        add(NextCommand());
      }
      return;
    }

    // 2. Normal gameplay: checking against current command
    if (state.currentCommand == null) return;

    if (detected == state.currentCommand) {
      // Success!
      emit(
        state.copyWith(
          feedback: "صحيح! ✅",
          score: state.score + 1,
          clearCurrentCommand: true,
          isWaitingForNeutral: true,
          message: "قف باعتدال...", // Tell user to stand neutral
        ),
      );
    }
  }

  void _onResetGame(ResetGame event, Emitter<SimonSaysState> emit) {
    _commandTimer?.cancel();
    _gameTimer?.cancel();
    emit(state.copyWith(status: SimonGameStatus.initial));
  }

  @override
  Future<void> close() {
    _commandTimer?.cancel();
    _gameTimer?.cancel();
    return super.close();
  }
}
