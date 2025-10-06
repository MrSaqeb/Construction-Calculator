import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final _player = AudioPlayer();

  static Future<void> playBeep() async {
    await _player.play(AssetSource('sounds/preview.mp3'));
  }
}
