enum WaveStatus { idle, detecting, waveDetected }

class WaveState {
  final WaveStatus status;
  final int count;

  const WaveState({required this.status, required this.count});

  WaveState copyWith({WaveStatus? status, int? count}) {
    return WaveState(status: status ?? this.status, count: count ?? this.count);
  }
}
