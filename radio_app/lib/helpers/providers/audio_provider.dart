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

  // STREAMS
  Stream<String> get icyStream => _icyTitleSubject.stream;
  String get currentIcyTitle => _icyTitleSubject.value;

  Stream<PlayerState> get stateStream => _player.playerStateStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<Duration> get positionStream => _player.positionStream;

  PlayerState get state => _player.playerState;
  bool get isPlaying => _player.playing;

  int _retryCount = 0;
  final int _maxRetries = 3;

  // 🔥 Datos de estación actual
  String? _currentTitle;
  String? _currentArtist;
  String? _currentArt;
  String? _currentUrl;

  String? get currentTitle => _currentTitle;
  String? get currentArtist => _currentArtist;
  String? get currentArt => _currentArt;
  String? get currentUrl => _currentUrl;

  AudioProvider() {
    _init();

    // METADATA ICY SEGURO
    _player.icyMetadataStream.listen((metadata) {
      final rawIcy = metadata?.info?.title;

      // Convertir, limpiar y evitar nulls
      final icy = (rawIcy ?? "").toString().trim();

      _icyTitleSubject.add(icy);
      notifyListeners();
    });

    // Notificar cambios de estado
    _player.playerStateStream.listen((_) => notifyListeners());

    // Reconexión automática
    _player.playerStateStream.listen((ps) async {
      if (!ps.playing &&
          ps.processingState == ProcessingState.idle &&
          _retryCount < _maxRetries) {
        _retryCount++;
        debugPrint("Intentando reconectar... ($_retryCount)");
        await Future.delayed(const Duration(seconds: 2));
      }
    });
  }

  Future<void> _init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
    } catch (e) {
      debugPrint("Error en audio session: $e");
    }
  }

  // ───────────────────────────────────────────────
  // 🔊 REPRODUCIR ESTACIÓN
  // ───────────────────────────────────────────────
  Future<void> playStation({
    required String url,
    required String title,
    required String artist,
    required String artUrl,
  }) async {
    try {
      _retryCount = 0;

      // Guardar datos actuales
      _currentTitle = title;
      _currentArtist = artist;
      _currentArt = artUrl;
      _currentUrl = url;

      notifyListeners();

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
        AudioSource.uri(
          Uri.parse(url),
          tag: mediaItem,
        ),
      );

      debugPrint("🎧 Reproduciendo...");
      await _player.play();

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error reproduciendo: $e");
      notifyListeners();
    }
  }

  // ───────────────────────────────────────────────
  // CONTROLES
  // ───────────────────────────────────────────────
  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> resume() async {
    await _player.play();
    notifyListeners();
  }

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
