import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/detect_squat.dart';
import 'squat_event.dart';
import 'squat_state.dart';

class SquatBloc extends Bloc<SquatEvent, SquatState> {
  final DetectSquat _detectSquat;

  SquatBloc(this._detectSquat) : super(const SquatState()) {
    on<PoseDetected>(_onPoseDetected);
    on<ResetGame>(_onResetGame);
  }

  void _onPoseDetected(PoseDetected event, Emitter<SquatState> emit) {
    if (state.status == SquatGameStatus.gameOver) return;

    final result = _detectSquat(event.pose);

    if (result == true) {
      final newScore = state.score + 1;
      emit(
        state.copyWith(
          status: SquatGameStatus.active,
          score: newScore,
          feedback: "Good Job!",
        ),
      );
    } else {
      // Optional: clear feedback if needed, or provide hints
      // emit(state.copyWith(feedback: ""));
    }
  }

  void _onResetGame(ResetGame event, Emitter<SquatState> emit) {
    _detectSquat.reset();
    emit(const SquatState(status: SquatGameStatus.initial, score: 0));
  }
}
