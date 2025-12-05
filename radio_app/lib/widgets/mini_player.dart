import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/providers/audio_provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioProvider>();

    // Si no hay estación cargada
    if (audio.currentUrl == null) return const SizedBox.shrink();

    // Animación del disco según status
    if (audio.status == AudioStatus.playing) {
      if (!_rotationController.isAnimating) _rotationController.repeat();
    } else {
      if (_rotationController.isAnimating) _rotationController.stop();
    }

    // Detectar si la imagen es URL o asset
    final bool isNetworkImage =
        (audio.currentArt != null && audio.currentArt!.startsWith("http"));

    final Widget stationImage = ClipOval(
      child: isNetworkImage
          ? Image.network(
              audio.currentArt!,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            )
          : Image.asset(
              audio.currentArt ?? '',
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
    );

    // Mostrar botón según estado
    Widget playPauseButton;
    switch (audio.status) {
      case AudioStatus.loading:
        playPauseButton = const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
        );
        break;
      case AudioStatus.playing:
        playPauseButton = IconButton(
          iconSize: 40,
          icon: const Icon(Icons.pause_circle_filled, color: Colors.black),
          onPressed: () => audio.pause(),
        );
        break;
      case AudioStatus.paused:
      case AudioStatus.stopped:
        playPauseButton = IconButton(
          iconSize: 40,
          icon: const Icon(Icons.play_circle_fill, color: Colors.black),
          onPressed: () => audio.resume(),
        );
        break;
      case AudioStatus.error:
      default:
        playPauseButton = IconButton(
          iconSize: 40,
          icon: const Icon(Icons.error, color: Colors.red),
          onPressed: () => audio.playStation(
            url: audio.currentUrl!,
            title: audio.currentTitle ?? '',
            artist: audio.currentArtist ?? '',
            artUrl: audio.currentArt ?? '',
          ),
        );
    }

    return Container(
      height: 85,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7D348), Color(0xFFD4A224)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          RotationTransition(turns: _rotationController, child: stationImage),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  audio.currentTitle ?? '',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  audio.currentArtist ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          playPauseButton,
        ],
      ),
    );
  }
}
