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

    return Scaffold(
      backgroundColor: const Color(0xFF161607),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.black,
              backgroundImage: AssetImage(artUrl),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            stationName,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          StreamBuilder<String>(
            stream: audio.icyStream,
            builder: (context, snap) {
              final title = snap.data ?? '';
              return Text(
                title.isNotEmpty ? title : 'En vivo',
                style: const TextStyle(color: Colors.white70),
              );
            },
          ),
          const SizedBox(height: 40),
          StreamBuilder<bool>(
            stream: audio.playingStream,
            builder: (context, snap) {
              final playing = snap.data ?? false;

              return IconButton(
                iconSize: 84,
                icon: Icon(
                  playing ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (playing) {
                    await audio.pause();
                  } else {
                    await audio.playStation(
                      url: streamUrl,
                      title: stationName,
                      artist: "Radio en vivo",
                      artUrl: artUrl,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
