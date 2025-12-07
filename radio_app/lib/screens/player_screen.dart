import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

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

  bool showSocialBar = false;

  final List<Map<String, dynamic>> linkItems = [
    {
      'type': 'share',
      'icon': Icons.share,
    },
    {
      'label': 'Facebook',
      'asset': 'assets/icons/facebook.png',
      'url': 'https://www.facebook.com/radioactivatx89.9'
    },
    {
      'label': 'Web',
      'asset': 'assets/icons/web.png',
      'url': 'https://www.radioactivatx.org/'
    },
    {
      'label': 'WhatsApp',
      'asset': 'assets/icons/Telefono.png',
      'url': 'tel:+524141199003'
    },
    {
      'label': 'Instagram',
      'asset': 'assets/icons/instagram_1.jpg',
      'url': 'https://www.instagram.com/radioactiva.tx'
    },
    {
      'label': 'Twitter',
      'asset': 'assets/icons/x_1.png',
      'url': 'https://twitter.com/RadioactivaTx'
    },
    {
      'label': 'TikTok',
      'asset': 'assets/icons/tiktok.png',
      'url': 'https://www.tiktok.com/@radioactiva.tx'
    },
    {
      'label': 'YouTube',
      'asset': 'assets/icons/youtube.png',
      'url': 'https://youtube.com/@radioactivatx'
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

  // ---------------------------------------------------
  // BARRA SOCIAL (AHORA ICONOS CUADRADOS REDONDEADOS)
  // ---------------------------------------------------
  Widget buildSocialBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      right: showSocialBar ? 15 : -200,
      top: 260,
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ...linkItems.map((item) {
              final bool isShare = item['type'] == 'share';

              return GestureDetector(
                onTap: () async {
                  if (isShare) {
                    await Share.share(
                      "🎧 Escucha ${widget.stationName}\n${widget.streamUrl}",
                    );
                  } else {
                    final uri = Uri.parse(item['url']);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12), // ⬅ CUADRADO
                    ),
                    child: Center(
                      child: isShare
                          ? const Icon(Icons.share,
                              color: Colors.black87, size: 28)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item['asset'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 8),

            // BOTÓN CERRAR — AHORA CUADRADO
            GestureDetector(
              onTap: () => setState(() => showSocialBar = false),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.close, size: 24, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context);

    final art = widget.artUrl;
    final title = widget.stationName;

    if (audio.status == AudioStatus.playing &&
        !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (audio.status != AudioStatus.playing &&
        _rotationController.isAnimating) {
      _rotationController.stop();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(art, fit: BoxFit.cover)),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withOpacity(0.55)),
            ),
          ),
          buildSocialBar(),
          Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/icons/down.png',
                      width: 45,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: RotationTransition(
                  turns: _rotationController,
                  child: ClipOval(
                    child: Container(
                      width: 230,
                      height: 230,
                      child: Image.asset(art, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<String>(
                stream: audio.icyStream,
                builder: (context, snapshot) {
                  final icy = snapshot.data ?? "";
                  return Text(
                    icy.isNotEmpty
                        ? icy
                        : (audio.currentArtist ?? "Escuchando estación"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              const Spacer(),
              Builder(builder: (context) {
                if (audio.status == AudioStatus.loading) {
                  return const CircularProgressIndicator(
                    color: Colors.yellow,
                    strokeWidth: 4,
                  );
                } else if (audio.status == AudioStatus.error) {
                  return Column(
                    children: const [
                      Icon(Icons.error, color: Colors.red, size: 60),
                      SizedBox(height: 12),
                      Text(
                        "No se pudo reproducir la estación",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                } else {
                  final isPlaying = audio.isPlaying;
                  return IconButton(
                    onPressed: () {
                      if (isPlaying) {
                        audio.pause();
                      } else {
                        audio.playStation(
                          url: widget.streamUrl,
                          title: widget.stationName,
                          artist: audio.currentArtist ?? "",
                          artUrl: widget.artUrl,
                        );
                      }
                    },
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      size: 95,
                      color: Colors.yellow,
                    ),
                  );
                }
              }),
              const SizedBox(height: 50),
            ],
          ),
          Positioned(
            top: 45,
            right: 20,
            child: GestureDetector(
              onTap: () => setState(() => showSocialBar = true),
              child: const Icon(
                Icons.more_vert,
                color: Colors.yellow,
                size: 34,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
