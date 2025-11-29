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

  // Exponer streams útiles para la UI
  Stream<PlayerState> get stateStream => _player.playerStateStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<Duration> get positionStream => _player.positionStream;
  PlayerState get state => _player.playerState;
  bool get isPlaying => _player.playing;

  // Reintentos básicos en caso de fallo
  int _retryCount = 0;
  final int _maxRetries = 3;

  AudioProvider() {
    _init();

    // ICY metadata
    _player.icyMetadataStream.listen((metadata) {
      final icy = metadata?.info?.title ?? "";
      _icyTitleSubject.add(icy);
      notifyListeners();
    });

    // Notificar cambios generales
    _player.playerStateStream.listen((_) => notifyListeners());

    // Manejo de errores: intentar reconectar si es streaming
    _player.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.idle ||
          state.processingState == ProcessingState.completed) {
        // no hacemos nada especial aquí
      }
      if (state.processingState == ProcessingState.ready && !_player.playing) {
        // listo pero en pausa
      }
      if (state.playing == false &&
          state.processingState == ProcessingState.idle &&
          _retryCount < _maxRetries) {
        _retryCount++;
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

  /// Reproduce una estación con metadata para notificación / background
  Future<void> playStation({
    required String url,
    required String title,
    required String artist,
    required String artUrl, // ruta asset: assets/images/...
  }) async {
    try {
      _retryCount = 0;
      final mediaItem = MediaItem(
        id: url,
        album: artist,
        title: title,
        artist: artist,
        artUri: Uri.parse('asset:///$artUrl'),
      );

      // Liberar fuente previa para asegurar set correcto
      await _player.stop();
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: mediaItem,
        ),
        preload: true,
      );

      // reproducir
      await _player.play();
      notifyListeners();
    } catch (e, st) {
      debugPrint("ERROR playStation: $e");
      debugPrint("$st");
      // si falla, intentar una reconexión limitada
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(milliseconds: 700));
        await playStation(
            url: url, title: title, artist: artist, artUrl: artUrl);
      }
    }
  }

  /// Play simple (cuando solo tienes streamUrl)
  Future<void> play({
    required String streamUrl,
    required String artUrl,
  }) async {
    try {
      _retryCount = 0;
      final item = MediaItem(
        id: streamUrl,
        album: '',
        title: streamUrl.split('/').last,
        artUri: Uri.parse('asset:///$artUrl'),
      );

      await _player.stop();
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: item,
        ),
        preload: true,
      );

      await _player.play();
      notifyListeners();
    } catch (e, st) {
      debugPrint("ERROR play: $e");
      debugPrint("$st");
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(milliseconds: 700));
        await play(streamUrl: streamUrl, artUrl: artUrl);
      }
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
      notifyListeners();
    } catch (e) {
      debugPrint("ERROR pause: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      notifyListeners();
    } catch (e) {
      debugPrint("ERROR stop: $e");
    }
  }

  /// Alterna entre play y pause (útil para botones)
  Future<void> togglePlayPause({
    String? url,
    String? title,
    String? artist,
    String? artUrl,
    String? streamUrl,
  }) async {
    // Si está reproduciendo -> pausar
    if (_player.playing) {
      await pause();
      return;
    }

    // Si NO está reproduciendo y ya hay una source cargada -> play
    if (_player.playing == false && _player.audioSource != null) {
      try {
        await _player.play();
        notifyListeners();
        return;
      } catch (e) {
        debugPrint("ERROR al reanudar: $e");
      }
    }

    // Si no hay source cargada, intentar reproducir la URL proporcionada
    if (url != null && title != null && artist != null && artUrl != null) {
      await playStation(url: url, title: title, artist: artist, artUrl: artUrl);
      return;
    }

    if (streamUrl != null && artUrl != null) {
      await play(streamUrl: streamUrl, artUrl: artUrl);
      return;
    }

    debugPrint('togglePlayPause: no hay fuente disponible para reproducir.');
  }

  @override
  void dispose() {
    _icyTitleSubject.close();
    _player.dispose();
    super.dispose();
  }
}
