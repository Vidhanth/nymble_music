import 'package:audioplayers/audioplayers.dart';

class AudioHelper {
  static final instance = AudioHelper();

  late final AudioPlayer _player;

  Function(double)? _onProgressChanged;

  Duration? _songDuration;

  void setOnProgressListener(Function(double) onProgressChanged) {
    _onProgressChanged = onProgressChanged;
  }

  void resetOnProgressListener() {
    _onProgressChanged = null;
  }

  void initialize() {
    _player = AudioPlayer();
    _player.onPositionChanged.listen((position) {
      if (_songDuration == null) return;
      final progress = position.inSeconds / _songDuration!.inSeconds;
      _onProgressChanged?.call(progress);
    });
  }

  void setSource(String url) async {
    await _player.setSourceUrl(url);
    _songDuration = await _player.getDuration();
  }

  void play() {
    _player.resume();
  }

  void pause() {
    _player.pause();
  }
}
