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
    final current = audio.state.currentStation;

    if (current == null) return const SizedBox.shrink();

    // 🔥 Controlar animación según play/pause
    if (audio.state.playing) {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }

    return Container(
      height: 85,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF7D348),
            Color(0xFFD4A224),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🎵 Imagen girando como disco
          RotationTransition(
            turns: _rotationController,
            child: ClipOval(
              child: Image.asset(
                current.imageAsset,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // ✔ Información
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  current.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  current.slogan,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ▶ Botón play/pause
          IconButton(
            iconSize: 40,
            icon: Icon(
              audio.state.playing
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
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
