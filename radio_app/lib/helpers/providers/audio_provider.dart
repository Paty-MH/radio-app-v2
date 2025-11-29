import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  // Streams útiles para la UI
  Stream<PlayerState> get stateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<bool> get playingStream => _player.playingStream;

  // Título recibido mediante icy metadata (o vacío)
  final BehaviorSubject<String> _icyTitleSubject =
      BehaviorSubject<String>.seeded('');
  Stream<String> get icyStream => _icyTitleSubject.stream;
  String get currentIcyTitle => _icyTitleSubject.value;

  AudioProvider() {
    _initAudioSession();
    // escucha icy metadata si está disponible
    _player.icyMetadataStream.listen((metadata) {
      final icy = metadata?.info?.title ?? "";
      _icyTitleSubject.add(icy);
      notifyListeners();
    });
    // cuando cambie estado notify
    _player.playerStateStream.listen((_) => notifyListeners());
  }

  Future<void> _initAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
    } catch (e) {
      debugPrint("Error inicializando audio session: $e");
    }
  }

  PlayerState get state => _player.playerState;
  bool get isPlaying => _player.playing;
  String get icy => _icyTitleSubject.value;

  /// Reproduce una estación (URL). También publica metadata para la notificación.
  Future<void> playStation({
    required String url,
    required String title,
    required String artist,
    required String artUrl, // ruta de asset p.ej. assets/images/station1.png
  }) async {
    try {
      // Usamos MediaItem para que just_audio_background muestre notificación con arte
      final item = MediaItem(
        id: url,
        album: artist,
        title: title,
        artist: artist,
        artUri: Uri.parse('asset:///$artUrl'),
      );

      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: item,
        ),
      );

      await _player.play();
      notifyListeners();
    } catch (e) {
      debugPrint("ERROR playStation: $e");
    }
  }

  /// Método para reproducir un stream directo (sin tag)
  Future<void> play({required String streamUrl, required String artUrl}) async {
    try {
      final item = MediaItem(
        id: streamUrl,
        album: '',
        title: streamUrl.split('/').last,
        artUri: Uri.parse('asset:///$artUrl'),
      );

      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: item,
        ),
      );
      await _player.play();
      notifyListeners();
    } catch (e) {
      debugPrint("ERROR play: $e");
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

  /// Opcional: detener y liberar
  Future<void> stop() async {
    try {
      await _player.stop();
      notifyListeners();
    } catch (e) {
      debugPrint("ERROR stop: $e");
    }
  }

  @override
  void dispose() {
    _icyTitleSubject.close();
    _player.dispose();
    super.dispose();
  }
}
