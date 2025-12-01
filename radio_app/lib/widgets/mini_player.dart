import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioProvider>();
    final current = audio.state.currentStation;

    if (current == null) return const SizedBox.shrink();

    // 🔥 Si está reproduciendo, gira — si no, pausa
    if (audio.state.playing) {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }

    return Container(
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -3),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🔥 Imagen girando como disco
          RotationTransition(
            turns: _rotationController,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                current.imageAsset,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Nombre y slogan
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  current.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  current.slogan,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Botón Play/Pause
          IconButton(
            icon: Icon(
              audio.state.playing
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
              size: 40,
              color: Colors.black,
            ),
            onPressed: () {
              if (audio.state.playing) {
                audio.pause();
              } else {
                audio.playStation(
                  url: current.url,
                  title: current.name,
                  artist: current.slogan,
                  artUrl: current.imageAsset,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

extension on PlayerState {
   get currentStation => null;
}
