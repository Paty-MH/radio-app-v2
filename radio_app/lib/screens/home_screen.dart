// lib/screens/home_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/constants.dart';
import '../helpers/providers/audio_provider.dart';
import '../helpers/providers/app_provider.dart';

import '../widgets/station_card.dart';
import '../widgets/program_carousel.dart';
import '../models/program_model.dart';

import '../widgets/app_drawer.dart';
import '../widgets/social_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 130),
            children: [
              _bannerHeader(context),

              const SizedBox(height: 18),

              _titleSection('Nuestras', 'Estaciones'),
              const SizedBox(height: 10),

              // LISTA DE ESTACIONES
              ...List.generate(stations.length, (i) {
                final s = stations[i];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: StationCard(
                    station: s,
                    onTap: () {
                      // Guardar estación actual y reproducir
                      context.read<AppProvider>().setCurrentStation(i);
                      context.read<AudioProvider>().playStation(
                            url: s.url,
                            title: s.name,
                            artist: s.slogan,
                            artUrl: s.imageAsset,
                          );
                    },
                    onLongPress: () {},
                  ),
                );
              }),

              const SizedBox(height: 20),

              // PROGRAMAS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _titleSection('Nuestros', 'Programas'),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/programs'),
                      child: Text(
                        'Ver Todos',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              ProgramCarousel(
                programs: programs,
                onTap: (p) => showProgramModal(context, p),
              ),

              const SizedBox(height: 40),

              // ICONOS DE REDES SOCIALES
              const SocialIconsSection(),
              const SizedBox(height: 25),
              const SizedBox(height: 430),
            ],
          ),

          // MINI PLAYER
          const Align(
            alignment: Alignment.bottomCenter,
            child: _MiniPlayer(),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  // ENCABEZADO
  // ───────────────────────────────────────────
  Widget _bannerHeader(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFFFFE76A),
        image: DecorationImage(
          image: AssetImage('assets/images/header_music.png'),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Builder(
                builder: (ctx) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  );
                },
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  // TITULOS
  // ───────────────────────────────────────────
  Widget _titleSection(String t1, String t2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          children: [
            TextSpan(text: '$t1 '),
            TextSpan(
              text: t2,
              style: GoogleFonts.poppins(
                color: Color(0xFFFFC400),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  // MODAL DE PROGRAMAS
  // ───────────────────────────────────────────
  void showProgramModal(BuildContext context, Program p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.78,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (ctx, ctl) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: ctl,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Image.asset(
                          p.imageAsset,
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.description,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Horarios de emisión',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: p.schedules.map((s) {
                            return Container(
                              width: 150,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    s.day,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${s.start} - ${s.end}',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ───────────────────────────────────────────
// MINI PLAYER (estado + animación del disco)
// ───────────────────────────────────────────
class _MiniPlayer extends StatefulWidget {
  const _MiniPlayer();

  @override
  State<_MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<_MiniPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    // No repetir automáticamente: controlamos según el stream
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  // Helper para arrancar/pausar animación de forma segura
  void _updateRotation(bool playing) {
    if (playing) {
      if (!_rotationController.isAnimating) {
        _rotationController.repeat();
      }
    } else {
      if (_rotationController.isAnimating) {
        _rotationController.stop(canceled: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioProvider>();
    final app = context.watch<AppProvider>();

    // Si no hay estación seleccionada, no mostramos mini player
    final int idx = app.currentStationIndex;
    if (idx < 0 || idx >= stations.length) return const SizedBox.shrink();
    final s = stations[idx];

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/player'),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 78,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE437), Color(0xFFB89A00)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            // DISCO CIRCULAR (gira cuando reproduce)
            StreamBuilder<bool>(
              stream: audio.playingStream,
              builder: (context, snap) {
                final playing = snap.data ?? false;

                // actualizar animación
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _updateRotation(playing);
                });

                return RotationTransition(
                  turns: _rotationController,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      // carátula dentro del círculo
                      image: DecorationImage(
                        image: AssetImage(s.imageAsset),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 12),

            // TITULOS
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Mostrar ICY (título) si existe, sino slogan
                  StreamBuilder<String>(
                    stream: audio.icyStream,
                    builder: (context, snap) {
                      final t = snap.data ?? '';
                      final subtitle = t.isNotEmpty ? t : s.slogan;
                      return Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),

            // BOTÓN PLAY/PAUSE
            StreamBuilder<bool>(
              stream: audio.playingStream,
              builder: (context, snap) {
                final playing = snap.data ?? false;

                return IconButton(
                  icon: Icon(
                    playing ? Icons.pause_circle_filled : Icons.play_circle,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // evitar que el gesto del padre se active (tap abre player)
                    if (playing) {
                      audio.pause();
                    } else {
                      // si ya hay una fuente cargada, reanudar
                      if (audio.state.playing == false &&
                          audio.stateStream != null) {
                        // si no había fuente cargada, reproducir esta estación
                        audio.playStation(
                          url: s.url,
                          title: s.name,
                          artist: s.slogan,
                          artUrl: s.imageAsset,
                        );
                      } else {
                        audio.resume();
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
