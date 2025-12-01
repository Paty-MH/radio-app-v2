import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/providers/audio_provider.dart';

class PlayerScreen extends StatefulWidget {
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
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ⭐ FONDO BORROSO
          Positioned.fill(
            child: Image.asset(
              widget.artUrl,
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withOpacity(0.40),
              ),
            ),
          ),

          // ⭐ CONTENIDO
          Column(
            children: [
              const SizedBox(height: 30),

              // ⭐ DISCO GIRATORIO
              StreamBuilder<bool>(
                stream: audio.playingStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;

                  if (isPlaying) {
                    _rotationController.repeat();
                  } else {
                    _rotationController.stop();
                  }

                  return Center(
                    child: RotationTransition(
                      turns: _rotationController,
                      child: CircleAvatar(
                        radius: 120,
                        backgroundImage: AssetImage(widget.artUrl),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              // ⭐ NOMBRE DE LA ESTACIÓN
              Text(
                widget.stationName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // ⭐ ICY METADATA
              StreamBuilder<String>(
                stream: audio.icyStream,
                builder: (context, snapshot) {
                  final icy = snapshot.data ?? "Cargando...";

                  return Text(
                    icy.isNotEmpty ? icy : "Sin información",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),

              const Spacer(),

              // ⭐ BOTONES PLAY / PAUSE
              StreamBuilder<bool>(
                stream: audio.playingStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data ?? false;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // PLAY / PAUSE BUTTON
                      IconButton(
                        onPressed: () {
                          if (playing) {
                            audio.pause();
                          } else {
                            audio.playStation(
                              url: widget.streamUrl,
                              title: widget.stationName,
                              artist: widget.stationName,
                              artUrl: widget.artUrl,
                            );
                          }
                        },
                        icon: Icon(
                          playing
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
