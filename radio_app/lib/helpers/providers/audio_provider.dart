import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final BehaviorSubject<String> _icyTitleSubject =
      BehaviorSubject<String>.seeded('');

  Stream<String> get icyStream => _icyTitleSubject.stream;
  String get currentIcyTitle => _icyTitleSubject.value;

  Stream<PlayerState> get stateStream => _player.playerStateStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<Duration> get positionStream => _player.positionStream;

  PlayerState get state => _player.playerState;
  bool get isPlaying => _player.playing;

  int _retryCount = 0;
  final int _maxRetries = 3;

  AudioProvider() {
    _init();

    // METADATA ICY (título dinámico)
    _player.icyMetadataStream.listen((metadata) {
      final icy = metadata?.info?.title ?? "";
      _icyTitleSubject.add(icy);
      notifyListeners();
    });

    // Cambios del Player
    _player.playerStateStream.listen((_) => notifyListeners());

    // Reconexión automática
    _player.playerStateStream.listen((state) async {
      if (!state.playing &&
          state.processingState == ProcessingState.idle &&
          _retryCount < _maxRetries) {
        _retryCount++;
        debugPrint("Intentando reconectar... $_retryCount");
        await Future.delayed(const Duration(seconds: 2));
      }
    });
  }

  Future<void> _init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
    } catch (e) {
      debugPrint("Error inicializando audio session: $e");
    }
  }

  // 🔊 Reproducir estación
  Future<void> playStation({
    required String url,
    required String title,
    required String artist,
    required String artUrl,
  }) async {
    try {
      _retryCount = 0;

      // Este MediaItem activa la notificación del background
      final mediaItem = MediaItem(
        id: url,
        album: artist,
        title: title,
        artist: artist,
        artUri: Uri.parse("asset:///$artUrl"),
      );

      debugPrint("⏳ Cargando stream: $url");

      await _player.stop();
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(url), tag: mediaItem),
      );

      debugPrint("🎧 Reproduciendo...");
      await _player.play();

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error reproduciendo estación: $e");
      notifyListeners();
    }
  }

  // Pausar
  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  // Continuar
  Future<void> resume() async {
    await _player.play();
    notifyListeners();
  }

  // Detener
  Future<void> stop() async {
    await _player.stop();
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    _icyTitleSubject.close();
    super.dispose();
  }
}
