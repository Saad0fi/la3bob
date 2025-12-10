import 'package:audioplayers/audioplayers.dart';

class AudioHelper {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playWordAudio(String word) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$word.m4a'));
    } catch (e) {
      print('Error playing audio for word $word: $e');
    }
  }

  static Future<void> playSentenceAudio() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/choose_letter.m4a'));
    } catch (e) {
      print('Error playing sentence audio: $e');
    }
  }

  static Future<void> playQuestionSequence(String word) async {
    try {
      await playWordAudio(word);

      await _player.onPlayerComplete.first;
      await playSentenceAudio();
      await _player.onPlayerComplete.first;
      await playWordAudio(word);
    } catch (e) {
      print('Error playing question sequence: $e');
    }
  }

  static Future<void> stopAudio() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  static void dispose() {
    _player.dispose();
  }
}
