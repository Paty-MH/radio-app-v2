import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
// Custom handler that controls background audio playback.
// Inherits from BaseAudioHandler and allows handling actions such as play, pause, and stop.
class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  // Main player using just_audio.
  final _player = AudioPlayer();
// Constructor: upon initialization, it begins to notify of state changes.
  MyAudioHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
  }
// Receives the stream URL, title, and program image.
  Future<void> playStream(String url, String title, String artUrl) async {
   // the audio information that is sent to system notifications
    final mediaItem = MediaItem(
      id: url,
      title: title,
      artUri: Uri.parse('asset:///$artUrl'),
    );

    mediaItem.add(mediaItem);
    await _player.setUrl(url);
    await _player.play();
  }
//Listen for player changes and update status for notifications,

// external widgets and the operating system.
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
