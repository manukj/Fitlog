import 'package:audioplayers/audioplayers.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';

class AudioPlayerHelper {
  AudioPlayer _player = AudioPlayer();

  AudioPlayerHelper() {
    _player.setSource(AssetSource(AssetsPath.repCountAudio));
  }

  Future<void> play() async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
    }

    await _player.play(AssetSource(AssetsPath.repCountAudio));
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
