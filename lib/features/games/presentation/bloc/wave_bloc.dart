import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/detect_wave.dart';
import '../../domain/entities/wave_movement.dart';
import 'wave_event.dart';
import 'wave_state.dart';

class WaveBloc extends Bloc<WaveEvent, WaveState> {
  final DetectWave detectWave;

  WaveBloc(this.detectWave)
    : super(const WaveState(status: WaveStatus.idle, count: 0)) {
    on<PoseReceived>((event, emit) {
      final result = detectWave(event.pose);
      if (result == WaveMovement.wave) {
        emit(
          state.copyWith(
            status: WaveStatus.waveDetected,
            count: state.count + 1,
          ),
        );
      } else {
        // Only update status if it changes to avoid unnecessary rebuilds if you wish
        // But for now, we just set it to detecting if not a wave
        if (state.status != WaveStatus.detecting) {
          emit(state.copyWith(status: WaveStatus.detecting));
        }
      }
    });

    on<ResetWave>((event, emit) {
      emit(const WaveState(status: WaveStatus.idle, count: 0));
    });
  }
}
