// lib/screens/player_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool showMenu = false;

  final List<Map<String, dynamic>> linkItems = const [
    {
      'label': 'Facebook',
      'asset': 'assets/icons/facebook_1.png',
      'url':
          'https://www.facebook.com/radioactivatx89.9?wtsid=rdr_01btUDnQhVaGthwGL&from_intent_redirect=1',
    },
    {
      'label': 'web',
      'asset': 'assets/icons/web.jpg',
      'url': 'https://www.radioactivatx.org/',
    },
    {
      'label': 'Instagram',
      'asset': 'assets/icons/instagram_1.jpg',
      'url': 'https://www.instagram.com/radioactivatx?igsh=M2piYzc1eGNiY29v',
    },
    {
      'label': 'Twitter (X)',
      'asset': 'assets/icons/x.png',
      'url': 'https://twitter.com/RadioactivaTx',
    },
    {
      'label': 'TikTok',
      'asset': 'assets/icons/tiktok.png',
      'url': 'https://www.tiktok.com/@radioactiva.tx?_r=1&_t=ZS-91jAkaMrlyP',
    },
    {
      'label': 'YouTube',
      'asset': 'assets/icons/youtube.png',
      'url': 'https://youtube.com/@radioactivatx?si=AZwNbDJzsPoLlxDB',
    },
    {
      'label': 'Llamar',
      'asset': 'assets/icons/Telefono.png',
      'url': 'tel:+524141199003',
    },
  ];

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    final audio = Provider.of<AudioProvider>(context, listen: false);
    audio.playStation(
      url: widget.streamUrl,
      title: widget.stationName,
      artist: "",
      artUrl: widget.artUrl,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  // 🌟 PANEL SOCIAL CON BOTÓN X ABAJO
  Widget _socialPanel() {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        border: Border.all(color: Colors.white, width: 1.3),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Share.share(
                "📻 Escucha *${widget.stationName}* en vivo:\n${widget.streamUrl}",
                subject: "Radio en Vivo",
              );
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
              child: Icon(Icons.share, color: Colors.yellow, size: 26),
            ),
          ),
          const SizedBox(height: 12),
          ...linkItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(item['url']);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: ClipOval(
                    child: Image.asset(
                      item['asset'],
                      fit: BoxFit.cover,
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 15),
          // 🔥 BOTÓN X ABAJO
          GestureDetector(
            onTap: () {
              setState(() {
                showMenu = false;
              });
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
              child: Icon(Icons.close, color: Colors.red, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context);

    final art = widget.artUrl;
    final title = widget.stationName;
    final url = widget.streamUrl;
    final artist = audio.currentArtist;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/icons/down.png', // tu flecha hacia abajo
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.yellow, size: 32),
            onPressed: () {
              setState(() {
                showMenu = !showMenu;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(art, fit: BoxFit.cover)),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              StreamBuilder<bool>(
                stream: audio.playingStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;

                  if (isPlaying && !_rotationController.isAnimating) {
                    _rotationController.repeat();
                  } else if (!isPlaying) {
                    _rotationController.stop();
                  }

                  return Center(
                    child: RotationTransition(
                      turns: _rotationController,
                      child: ClipOval(
                        child: Container(
                          width: 240,
                          height: 240,
                          child: Image.asset(
                            art,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<String>(
                stream: audio.icyStream,
                builder: (context, snapshot) {
                  final icy = snapshot.data ?? "";
                  return Text(
                    icy.isNotEmpty ? icy : (artist ?? ""),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              const Spacer(),
              StreamBuilder<bool>(
                stream: audio.playingStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data ?? false;

                  return IconButton(
                    onPressed: () {
                      if (playing) {
                        audio.pause();
                      } else {
                        audio.playStation(
                          url: url,
                          title: title,
                          artist: artist ?? "",
                          artUrl: art,
                        );
                      }
                    },
                    icon: Icon(
                      playing
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      size: 90,
                      color: Colors.yellow,
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: showMenu ? 10 : -200,
            top: 120,
            child: _socialPanel(),
          ),
        ],
      ),
    );
  }
}
