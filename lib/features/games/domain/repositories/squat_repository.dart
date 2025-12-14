import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// For simplicity, let's reuse WaveMovement or create a new enum if strictly needed.
// But sticking to the plan, I should probably check if WaveMovement is generic enough
// or if I should create a specific enum. The plan didn't specify a new enum file,
// but let's see. WaveMovement probably has 'wave' and maybe 'none'.
// Let's create a SquatStatus enum or just use boolean/int in return.
// The existing wave_repository returns WaveMovement?.
// Let's check WaveMovement first. Since I can't check it in this turn easily without delaying,
// I'll assume I can create a SquatMovement enum or return int (count) or similar.
// Actually, the detector usually returns an event (like "Squat done").
// Let's define the repository to return a customized status.

abstract class SquatRepository {
  bool? detectSquat(Pose pose);
  void reset();
}
