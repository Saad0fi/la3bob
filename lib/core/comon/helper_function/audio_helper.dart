import 'package:audioplayers/audioplayers.dart';

class AudioHelper {
  static final AudioPlayer _player = AudioPlayer();
  static final AudioPlayer _simonPlayer = AudioPlayer();

  static Future<void> playWordAudio(String word) async {
    await _player.stop();
    await _player.play(AssetSource('audio/letters/$word.m4a'));
  }

  static Future<void> playSentenceAudio() async {
    await _player.stop();
    await _player.play(AssetSource('audio/letters/choose_letter.m4a'));
  }

  static Future<void> playQuestionSequence(String word) async {
    await playWordAudio(word);

    await _player.onPlayerComplete.first;
    await playSentenceAudio();
    await _player.onPlayerComplete.first;
    await playWordAudio(word);
  }

  static Future<void> playSimonCommand(String command) async {
    await _simonPlayer.stop();
    await _simonPlayer.play(AssetSource('audio/simons_say/$command.ogg'));
  }

  static Future<void> playSimonCorrect() async {
    await _simonPlayer.stop();
    await _simonPlayer.play(AssetSource('audio/simons_say/صحيح.ogg'));
  }

  static Future<void> playSimonTimeUp() async {
    await _simonPlayer.stop();
    await _simonPlayer.play(AssetSource('audio/simons_say/انتهى الوقت.ogg'));
  }

  static Future<void> stopAudio() async {
    await _player.stop();
    await _simonPlayer.stop();
  }

  static void dispose() {
    _player.dispose();
    _simonPlayer.dispose();
  }
}
