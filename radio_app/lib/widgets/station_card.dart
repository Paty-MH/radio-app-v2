import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/station_model.dart';

class StationCard extends StatelessWidget {
  final Station station;
  final VoidCallback onTap;
  final VoidCallback? onMore;
  final VoidCallback? onLongPress;

  const StationCard({
    super.key,
    required this.station,
    required this.onTap,
    this.onMore,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 105, // 🔥 estilo más alto como la app real
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          // 🔥 sombra suave estilo premium
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            // 🔥 Imagen más redondeada como la referencia real
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                station.imageAsset,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 14),

            // 🔥 Textos con Poppins como la app real
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    station.slogan,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 Icono play moderno como en la app real
            IconButton(
              icon: const Icon(
                Icons.play_circle_fill,
                size: 40,
                color: Colors.black87,
              ),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
