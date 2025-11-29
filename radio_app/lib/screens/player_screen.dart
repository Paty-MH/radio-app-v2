import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/providers/audio_provider.dart';

class PlayerScreen extends StatelessWidget {
  final String streamUrl;
  final String artUrl;
  final String stationName;

  const PlayerScreen({
    super.key,
    required this.streamUrl,
    required this.artUrl,
    required this.stationName,
  });

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context);
    final bool playing = audio.isPlaying;

    return Scaffold(
      backgroundColor: const Color(0xFF161607),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.yellow),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          /// 📻 Imagen circular
          Center(
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.black,
              backgroundImage: AssetImage(artUrl),
            ),
          ),

          const SizedBox(height: 24),

          /// 📌 Nombre estación
          Text(
            stationName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          /// Subtítulo
          const Text(
            'Radioactiva Tx',
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 40),

          /// ▶️ / ⏸ Botón principal
          IconButton(
            iconSize: 84,
            icon: Icon(
              playing ? Icons.pause_circle : Icons.play_circle,
              color: Colors.white,
            ),
            onPressed: () {
              if (playing) {
                audio.pause();
              } else {
                audio.play(streamUrl: streamUrl, artUrl: artUrl);
              }
            },
          ),
        ],
      ),
    );
  }
}
