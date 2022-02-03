import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double volume = 1.0;

  void play(
    String url, {
    bool isLocal = false,
    bool shouldLoop = false,
  }) async {
    await _audioPlayer.play(url, isLocal: isLocal, volume: volume);
    if (shouldLoop) {
      await _audioPlayer.setReleaseMode(ReleaseMode.LOOP);
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

  String getPlatformSound() {
    if (kIsWeb) {
      return "assets/musics/Error.mp3";
    }

    switch (Platform.operatingSystem) {
      case "android":
        return "assets/musics/Error.mp3";
      case "fuchsia":
        return "assets/musics/Error.mp3";
      case "linux":
        return "assets/musics/Error.mp3";
      case "macos":
        return "assets/musics/Error.mp3";
      case "windows":
        return "assets/musics/Error.mp3";
      case "ios":
        return "assets/musics/Error.mp3";
      default:
        return "assets/musics/Error.mp3";
    }
  }
}
