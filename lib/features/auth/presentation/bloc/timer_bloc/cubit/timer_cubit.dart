import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  Timer? _timer;
  static const int _initialDuration = 60;

  TimerCubit() : super(const TimerRunning(_initialDuration));

  void startTimer() {
    _timer?.cancel();
    emit(const TimerRunning(_initialDuration)); // إعادة تعيين العداد

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.duration > 0) {
        emit(TimerRunning(state.duration - 1));
      } else {
        timer.cancel();
        emit(const TimerFinished()); // إصدار حالة الانتهاء
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
