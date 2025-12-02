import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  Future<void> playStream(String url, String title, String artUrl) async {
    final mediaItem = MediaItem(
      id: url,
      title: title,
      artUri: Uri.parse('asset:///$artUrl'),
    );

    mediaItem.add(mediaItem);
    await _player.setUrl(url);
    await _player.play();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playerStateStream.listen((state) {
      final playing = state.playing;

      playbackState.add(
        playbackState.value.copyWith(
          playing: playing,
          controls: [
            MediaControl.pause,
            MediaControl.stop,
            MediaControl.play,
          ],
        ),
      );
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();
}

extension on MediaItem {
  void add(MediaItem mediaItem) {}
}
