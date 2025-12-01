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
      duration: const Duration(seconds: 10),
    );

    // ❗ EL CONTROLADOR NO INICIA AUTOMÁTICAMENTE
    // Solo gira cuando haya "playing = true"
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
          // ⭐ IMAGEN DE FONDO BORROSA
          Positioned.fill(
            child: Image.asset(
              widget.artUrl,
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),

          // ⭐ CONTENIDO PRINCIPAL
          Column(
            children: [
              const SizedBox(height: 30),

              // ⭐ DISCO QUE GIRA SOLO SI ESTÁ REPRODUCIENDO
              StreamBuilder<bool>(
                stream: audio.playingStream,
                builder: (context, snap) {
                  final playing = snap.data ?? false;

                  if (playing) {
                    _rotationController.repeat();
                  } else {
                    _rotationController.stop();
                  }

                  return Center(
                    child: RotationTransition(
                      turns: _rotationController,
                      child: CircleAvatar(
                        radius: 120,
                        backgroundColor: Colors.black,
                        backgroundImage: AssetImage(widget.artUrl),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              Text(
                widget.stationName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              StreamBuilder<String>(
                stream: audio.icyStream,
                builder: (context, snap) {
                  final title = snap.data ?? "En vivo";
                  return Text(
                    title.isNotEmpty ? title : "En vivo",
                    style: const TextStyle(color: Colors.white70),
                  );
                },
              ),

              const SizedBox(height: 40),

              // ⭐ BOTÓN PLAY/PAUSE
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
                          url: widget.streamUrl,
                          title: widget.stationName,
                          artist: "",
                          artUrl: widget.artUrl,
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
