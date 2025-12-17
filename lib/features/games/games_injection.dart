import 'package:get_it/get_it.dart';
import 'package:la3bob/features/games/data/services/wave_detector_service.dart';
import 'package:la3bob/features/games/domain/repositories/wave_repository.dart';
import 'package:la3bob/features/games/domain/usecases/detect_wave.dart';
import 'package:la3bob/features/games/domain/repositories/squat_repository.dart';
import 'package:la3bob/features/games/data/services/squat_detector_service.dart';
import 'package:la3bob/features/games/domain/usecases/detect_squat.dart';
import 'package:la3bob/features/games/domain/repositories/jump_repository.dart';
import 'package:la3bob/features/games/data/services/jump_detector_service.dart';
import 'package:la3bob/features/games/domain/usecases/detect_jump.dart';
import 'package:la3bob/features/games/domain/repositories/simon_says_repository.dart';
import 'package:la3bob/features/games/data/services/simon_says_detector_service.dart';
import 'package:la3bob/features/games/domain/usecases/detect_simon_move.dart';
import 'package:la3bob/features/games/domain/repositories/freeze_repository.dart';
import 'package:la3bob/features/games/data/services/freeze_detector_service.dart';
import 'package:la3bob/features/games/domain/usecases/detect_movement.dart';

final getIt = GetIt.instance;

void setupGames() {
  // Register Repository
  if (!getIt.isRegistered<WaveRepository>()) {
    getIt.registerLazySingleton<WaveRepository>(() => WaveDetectorService());
  }

  // Register Use Case
  if (!getIt.isRegistered<DetectWave>()) {
    getIt.registerFactory(() => DetectWave(getIt<WaveRepository>()));
  }

  // --- Squat Game Dependencies ---
  if (!getIt.isRegistered<SquatRepository>()) {
    getIt.registerLazySingleton<SquatRepository>(() => SquatDetectorService());
  }

  if (!getIt.isRegistered<DetectSquat>()) {
    getIt.registerFactory(() => DetectSquat(getIt<SquatRepository>()));
  }

  // --- Jump Game Dependencies ---
  if (!getIt.isRegistered<JumpRepository>()) {
    getIt.registerLazySingleton<JumpRepository>(() => JumpDetectorService());
  }

  if (!getIt.isRegistered<DetectJump>()) {
    getIt.registerFactory(() => DetectJump(getIt<JumpRepository>()));
  }

  // --- Simon Says Game Dependencies ---
  if (!getIt.isRegistered<SimonSaysRepository>()) {
    getIt.registerLazySingleton<SimonSaysRepository>(
      () => SimonSaysDetectorService(),
    );
  }

  if (!getIt.isRegistered<DetectSimonMove>()) {
    getIt.registerFactory(() => DetectSimonMove(getIt<SimonSaysRepository>()));
  }

  // --- Freeze Dance Game Dependencies ---
  if (!getIt.isRegistered<FreezeRepository>()) {
    getIt.registerLazySingleton<FreezeRepository>(
      () => FreezeDetectorService(),
    );
  }

  if (!getIt.isRegistered<DetectMovement>()) {
    getIt.registerFactory(() => DetectMovement(getIt<FreezeRepository>()));
  }
}
