import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BottomPlayer extends StatelessWidget {
  final AudioPlayer player;
  final String title;
  final String subtitle;

  const BottomPlayer({
    super.key,
    required this.player,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: Container(
        color: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.yellow, radius: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                  icon: Icon(
                      playing
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.white,
                      size: 32),
                  onPressed: () => playing ? player.pause() : player.play(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
