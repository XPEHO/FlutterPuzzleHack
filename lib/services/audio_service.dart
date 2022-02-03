import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache();
  double volume = 1.0;

  void play(
    String url, {
    bool isLocal = false,
    bool shouldLoop = false,
  }) async {
    if (kIsWeb) {
      await _audioPlayer.play("assets/$url", isLocal: isLocal, volume: volume);
      if (shouldLoop) {
        await _audioPlayer.setReleaseMode(ReleaseMode.LOOP);
      }
    } else {
      await _audioCache.play(url, volume: volume);
    }
  }

  void stop() async {
    await _audioPlayer.stop();
  }

  void pause() async {
    await _audioPlayer.pause();
  }

  void resume() async {
    await _audioPlayer.resume();
  }

  void updateVolume(double value) async {
    volume = value;
    await _audioPlayer.setVolume(volume);
  }

  void dispose() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
  }
}
