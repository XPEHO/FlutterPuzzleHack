import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:puzzle/services/shared.dart';
import 'package:volume_controller/volume_controller.dart';

/// Class AudioService for audio player in the app
/// Cache management
/// Volume management
/// Audio player management
class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache();
  double volume = 1.0;

  void play(
    String url, {
    bool isLocal = false,
    bool shouldLoop = false,
  }) async {
    if (isMobile()) {
      volume = await VolumeController().getVolume();
    }

    if (kIsWeb) {
      final String updatedUrl =
          kDebugMode ? "assets/$url" : "assets/assets/$url";
      await _audioPlayer.play(updatedUrl, isLocal: isLocal, volume: volume);
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
    if (isMobile()) {
      VolumeController().setVolume(volume);
    }
    await _audioPlayer.setVolume(volume);
  }

  void dispose() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
  }
}
