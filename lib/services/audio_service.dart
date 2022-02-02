import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPaused = false;
  bool hasStarted = false;
  double volume = 1.0;

  void play(
    String url, {
    bool isLocal = false,
  }) async {
    await _audioPlayer.play(url, isLocal: isLocal, volume: volume);
    await _audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    hasStarted = true;
  }

  void stop() async {
    await _audioPlayer.stop();
    isPaused = false;
    hasStarted = false;
  }

  void pause() async {
    await _audioPlayer.pause();
    isPaused = true;
  }

  void resume() async {
    await _audioPlayer.resume();
    isPaused = false;
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
