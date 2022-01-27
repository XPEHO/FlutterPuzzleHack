import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double volume = 1.0;

  /*AudioService() {
    play("https://www.youtube.com/watch?v=5LyjpuAGaF4&t=2s");
  }*/

  void play(
    String url, {
    bool isLocal = false,
  }) async {
    await _audioPlayer.play(url, isLocal: isLocal, volume: volume);
    await _audioPlayer.setReleaseMode(ReleaseMode.LOOP);
  }

  void stop() async {
    await _audioPlayer.stop();
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
