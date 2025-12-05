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

  final List<Map<String, dynamic>> linkItems = const [
    {
      'label': 'Facebook',
      'asset': 'assets/icons/facebook_1.png',
      'url':
          'https://www.facebook.com/radioactivatx89.9?wtsid=rdr_01btUDnQhVaGthwGL&from_intent_redirect=1',
    },
    {
      'label': 'Web',
      'asset': 'assets/icons/web.jpg',
      'url': 'https://www.radioactivatx.org/',
    },
    {
      'label': 'Instagram',
      'asset': 'assets/icons/instagram_1.jpg',
      'url': 'https://www.instagram.com/radioactiva.tx?igsh=M2piYzc1eGNiY29v',
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

    // Reproducir la estación al abrir el PlayerScreen
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

  void _showSocialPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Redes Sociales",
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: linkItems.map((item) {
                  return GestureDetector(
                    onTap: () async {
                      if (item['label'] == 'Compartir') {
                        Share.share(
                          "📻 Escucha *${widget.stationName}* en vivo:\n${widget.streamUrl}",
                          subject: "Radio en Vivo",
                        );
                      } else {
                        final uri = Uri.parse(item['url']);
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.black,
                          child: ClipOval(
                            child: Image.asset(
                              item['asset'],
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(item['label'],
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context);

    final art = widget.artUrl;
    final title = widget.stationName;

    // Controla animación de disco
    if (audio.status == AudioStatus.playing &&
        !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (audio.status != AudioStatus.playing &&
        _rotationController.isAnimating) {
      _rotationController.stop();
    }

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
              'assets/icons/down.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.yellow, size: 32),
            onPressed: _showSocialPanel,
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
              Center(
                child: RotationTransition(
                  turns: _rotationController,
                  child: ClipOval(
                    child: Container(
                      width: 240,
                      height: 240,
                      child: Image.asset(art, fit: BoxFit.cover),
                    ),
                  ),
                ),
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
                    icy.isNotEmpty
                        ? icy
                        : (audio.currentArtist ?? "Escuchando estación"),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              const Spacer(),
              // Botón Play / Pause / Loading / Error
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
                      size: 90,
                      color: Colors.yellow,
                    ),
                  );
                }
              }),
              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }
}
