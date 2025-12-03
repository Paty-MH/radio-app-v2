import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/helpers/constants.dart';

import '../helpers/providers/audio_provider.dart';
import '../helpers/providers/app_provider.dart';
import '../models/station_model.dart';

class StationCard extends StatelessWidget {
  final Station station;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const StationCard({
    super.key,
    required this.station,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioProvider>();
    final app = context.watch<AppProvider>();

    // ⭐ Saber si esta estación es la estación actual
    final bool isCurrent = app.currentStationIndex != null &&
        stations[app.currentStationIndex!].name == station.name;

    // ⭐ Saber si la estación actual está sonando
    final bool isPlaying = isCurrent && audio.isPlaying;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: () async {
        if (!isCurrent) {
          // Si el usuario cambia de estación
          app.setCurrentStation(stations.indexOf(station));

          audio.playStation(
            url: station.url,
            title: station.name,
            artist: station.slogan,
            artUrl: station.imageAsset,
          );
        } else {
          // Si toca la misma estación
          isPlaying ? audio.pause() : audio.resume();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isPlaying
              ? const Color(0xFFFFE6E6) // Fondo suave rojo si está sonando
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            // ⭐ LOGO
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                station.imageAsset,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 16),

            // ⭐ NOMBRE Y SLOGAN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    station.slogan,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // ⭐ ICONO PLAY / PAUSE
            Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              size: 34,
              color: isPlaying ? Colors.red : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
