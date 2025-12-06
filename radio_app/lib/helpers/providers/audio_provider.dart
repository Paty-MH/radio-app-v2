import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';

enum AudioStatus { stopped, loading, playing, paused, error }

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final BehaviorSubject<String> _icyTitleSubject =
      BehaviorSubject<String>.seeded('');

  // STREAMS
  Stream<String> get icyStream => _icyTitleSubject.stream;
  Stream<PlayerState> get stateStream => _player.playerStateStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<Duration> get positionStream => _player.positionStream;

  PlayerState get state => _player.playerState;
  bool get isPlaying => _player.playing;

  // Estado de carga
  AudioStatus _status = AudioStatus.stopped;
  AudioStatus get status => _status;

  // Datos de estación actual
  String? _currentTitle;
  String? _currentArtist;
  String? _currentArt;
  String? _currentUrl;

  String? get currentTitle => _currentTitle;
  String? get currentArtist => _currentArtist;
  String? get currentArt => _currentArt;
  String? get currentUrl => _currentUrl;

  int _retryCount = 0;
  final int _maxRetries = 3;

  AudioProvider() {
    _init();

    // ICY METADATA
    _player.icyMetadataStream.listen((metadata) {
      final icy = metadata?.info?.title ?? "";
      _icyTitleSubject.add(icy);
      notifyListeners();
    });

    // Reconexión automática
    _player.playerStateStream.listen((state) async {
      if (!state.playing &&
          state.processingState == ProcessingState.idle &&
          _retryCount < _maxRetries &&
          _currentUrl != null) {
        _retryCount++;
        debugPrint("Intentando reconectar... $_retryCount");
        await Future.delayed(const Duration(seconds: 2));
        try {
          await playStation(
            url: _currentUrl!,
            title: _currentTitle ?? '',
            artist: _currentArtist ?? '',
            artUrl: _currentArt ?? '',
            isReconnect: true,
          );
        } catch (_) {
          _status = AudioStatus.error;
          notifyListeners();
        }
      }
    });
  }

  Future<void> _init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      await _player.setAudioSource(
        AudioSource.uri(Uri.parse("https://fake-init.com/empty.mp3")),
      );
      await _player.stop();
      debugPrint("Background inicializado correctamente.");
    } catch (e) {
      debugPrint("Error inicializando audio: $e");
    }
  }

  // Reproducir estación
  Future<void> playStation({
    required String url,
    required String title,
    required String artist,
    required String artUrl,
    bool isReconnect = false,
  }) async {
    try {
      // Permitir recarga si no está realmente reproduciendo
      if (_currentUrl == url && _status == AudioStatus.playing) return;

      _retryCount = 0;
      _currentTitle = title;
      _currentArtist = artist;
      _currentArt = artUrl;
      _currentUrl = url;

      _status = isReconnect ? _status : AudioStatus.loading;
      notifyListeners();

      final mediaItem = MediaItem(
        id: url,
        album: artist,
        title: title,
        artist: artist,
        artUri: artUrl.startsWith("http")
            ? Uri.parse(artUrl)
            : Uri.parse("asset:///$artUrl"),
      );

      await _player.stop();

      try {
        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(url), tag: mediaItem),
        );
      } catch (e) {
        debugPrint("❌ Error cargando audio: $e");
        _status = AudioStatus.error;
        notifyListeners();
        return;
      }

      _status = AudioStatus.playing;
      notifyListeners();
      _player.play();
    } catch (e) {
      debugPrint("❌ Error reproduciendo estación: $e");
      _status = AudioStatus.error;
      notifyListeners();
    }
  }

  // CONTROLES
  Future<void> pause() async {
    await _player.pause();
    _status = AudioStatus.paused;
    notifyListeners();
  }

  Future<void> resume() async {
    await _player.play();
    _status = AudioStatus.playing;
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    _status = AudioStatus.stopped;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    _icyTitleSubject.close();
    super.dispose();
  }
}
