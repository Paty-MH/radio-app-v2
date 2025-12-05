import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/providers/audio_provider.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({super.key});

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer>
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

    // ⛔ Si no hay estación cargada, no mostrar nada
    if (audio.currentTitle == null || audio.currentUrl == null) {
      return const SizedBox.shrink();
    }

    // 🔥 Control de animación según esté sonando o pausado
    if (audio.isPlaying) {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }

    return Material(
      elevation: 12,
      child: Container(
        height: 70,
        color: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // 🎵 IMAGEN GIRANDO
            RotationTransition(
              turns: _rotationController,
              child: ClipOval(
                child: audio.currentArt != null &&
                        audio.currentArt!.startsWith("http")
                    ? Image.network(
                        audio.currentArt!,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        audio.currentArt ?? '',
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // 📻 TÍTULO Y ARTISTA
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audio.currentTitle ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    audio.currentArtist ?? '',
                    style: const TextStyle(color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ▶ BOTÓN PLAY/PAUSE
            IconButton(
              iconSize: 38,
              icon: Icon(
                audio.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                color: Colors.white,
              ),
              onPressed: () {
                if (audio.isPlaying) {
                  audio.pause();
                } else {
                  audio.resume(); // 🎯 Reanuda sin reiniciar
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
