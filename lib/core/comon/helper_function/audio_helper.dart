import 'package:audioplayers/audioplayers.dart';

class AudioHelper {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playWordAudio(String word) async {
    await _player.stop();
    await _player.play(AssetSource('audio/$word.m4a'));
  }

  static Future<void> playSentenceAudio() async {
    await _player.stop();
    await _player.play(AssetSource('audio/choose_letter.m4a'));
  }

  static Future<void> playQuestionSequence(String word) async {
    await playWordAudio(word);

    await _player.onPlayerComplete.first;
    await playSentenceAudio();
    await _player.onPlayerComplete.first;
    await playWordAudio(word);
  }

  static Future<void> stopAudio() async {
    await _player.stop();
  }

  static void dispose() {
    _player.dispose();
  }
}
