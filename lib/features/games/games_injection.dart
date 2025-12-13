import 'package:get_it/get_it.dart';
import 'package:la3bob/features/games/data/models/wave_detector_service.dart';
import 'package:la3bob/features/games/domain/repositories/wave_repository.dart';
import 'package:la3bob/features/games/domain/usecases/detect_wave.dart';
import 'package:la3bob/features/games/domain/repositories/squat_repository.dart';
import 'package:la3bob/features/games/data/models/squat_detector_service.dart';
import 'package:la3bob/features/games/domain/usecases/detect_squat.dart';

final getIt = GetIt.instance;

void setupWavingGame() {
  // Register Repository
  if (!getIt.isRegistered<WaveRepository>()) {
    getIt.registerLazySingleton<WaveRepository>(() => WaveDetectorService());
  }

  // Register Use Case
  if (!getIt.isRegistered<DetectWave>()) {
    getIt.registerFactory(() => DetectWave(getIt<WaveRepository>()));
  }

  // Bloc is created in API/Page via factory or directly using usecase,
  // so we don't strictly need to register Bloc itself if we useBlocProvider(create: (_) => WaveBloc(getIt<DetectWave>()))

  // --- Squat Game Dependencies ---
  if (!getIt.isRegistered<SquatRepository>()) {
    getIt.registerLazySingleton<SquatRepository>(() => SquatDetectorService());
  }

  if (!getIt.isRegistered<DetectSquat>()) {
    getIt.registerFactory(() => DetectSquat(getIt<SquatRepository>()));
  }
}
