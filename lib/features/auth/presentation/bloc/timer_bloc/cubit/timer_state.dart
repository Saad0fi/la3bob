import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  final int duration;

  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

// حالة تشغيل العداد
class TimerRunning extends TimerState {
  const TimerRunning(super.duration);
}

// حالة انتهاء العداد (وصل إلى صفر)
class TimerFinished extends TimerState {
  const TimerFinished() : super(0);

  @override
  List<Object> get props => [0];
}
