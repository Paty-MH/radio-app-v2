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

    final bool isCurrent = app.currentStationIndex != null &&
        stations[app.currentStationIndex!].name == station.name;

    final bool isPlaying = isCurrent && audio.status == AudioStatus.playing;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: () async {
        // 🔥 SOLO AGREGO ESTA PARTE PARA QUE PAUSE / REANUDE
        if (isCurrent) {
          if (audio.status == AudioStatus.playing) {
            await audio.pause();
          } else {
            await audio.resume();
          }
          return;
        }

        // Si es otra estación → comportamiento ORIGINAL
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isPlaying ? const Color(0xFFFFE6E6) : Colors.white,
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
            // IMAGEN
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

            // NOMBRE Y SLOGAN
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

            // PLAY / PAUSE / LOADING
            Builder(builder: (_) {
              if (isCurrent) {
                switch (audio.status) {
                  case AudioStatus.loading:
                    return const SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.red,
                      ),
                    );

                  case AudioStatus.error:
                    return const Icon(
                      Icons.error,
                      size: 34,
                      color: Colors.red,
                    );

                  case AudioStatus.playing:
                    return const Icon(
                      Icons.pause_circle_filled,
                      size: 34,
                      color: Colors.red,
                    );

                  case AudioStatus.paused:
                  case AudioStatus.stopped:
                  default:
                    return const Icon(
                      Icons.play_circle_fill,
                      size: 34,
                      color: Colors.black87,
                    );
                }
              } else {
                return const Icon(
                  Icons.play_circle_fill,
                  size: 34,
                  color: Colors.black87,
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
