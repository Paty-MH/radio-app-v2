import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BottomPlayer extends StatefulWidget {
  final AudioPlayer player;
  final String title;
  final String subtitle;
  final String image; // 🔥 Agregamos imagen del disco

  const BottomPlayer({
    super.key,
    required this.player,
    required this.title,
    required this.subtitle,
    required this.image,
  });

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

    // 🔥 Escucha cambios del player para mover o detener la animación
    widget.player.playerStateStream.listen((state) {
      if (state.playing) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        color: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // 🎵 DISCO GIRANDO
            RotationTransition(
              turns: _rotationController,
              child: ClipOval(
                child: Image.asset(
                  widget.image,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ▶ BOTÓN PLAY / PAUSE
            StreamBuilder<PlayerState>(
              stream: widget.player.playerStateStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data?.playing ?? false;

                return IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () =>
                      isPlaying ? widget.player.pause() : widget.player.play(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
