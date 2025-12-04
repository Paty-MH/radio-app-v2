import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class RadioAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  RadioAudioHandler() {
    _player.playbackEventStream.listen(_broadcastState);
  }

  Future<void> playUrl(
      String url, String title, String artist, String artUrl) async {
    // Evita errores si cambias rápido de estación
    await _player.stop();

    // Manejo de carátula (URL o asset)
    final Uri artUri = artUrl.startsWith("http")
        ? Uri.parse(artUrl)
        : Uri.parse("asset:///$artUrl");

    // Enviar MediaItem (para que funcione la notificación)
    mediaItem.add(
      MediaItem(
        id: url,
        title: title,
        artist: artist,
        album: artist,
        artUri: artUri,
      ),
    );

    // Configurar fuente y reproducir
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> _broadcastState(PlaybackEvent event) async {
    final playing = _player.playing;

    playbackState.add(
      playbackState.value.copyWith(
        playing: playing,
        controls: playing ? [MediaControl.pause] : [MediaControl.play],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
      ),
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();
}
