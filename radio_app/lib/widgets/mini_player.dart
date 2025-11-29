import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/providers/audio_provider.dart';
import '../helpers/constants.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioProvider>();
    final current = audio.state.currentStation;

    // Si no hay estación activa, no mostrar nada
    if (current == null) return const SizedBox.shrink();

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
          // Imagen de la estación
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              current.imageAsset,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
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

          // Botón Play / Pause (corregido)
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
