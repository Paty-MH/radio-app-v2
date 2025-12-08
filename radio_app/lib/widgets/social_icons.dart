import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIconsSection extends StatelessWidget {
  const SocialIconsSection({super.key});
//FUNCTION TO OPEN EXTERNAL LINKS
  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("No se pudo abrir $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TITLE "Follow us here too
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              children: const [
                TextSpan(text: "Síguenos por aquí "),
                TextSpan(
                  text: "también",
                  style: TextStyle(color: Color(0xFFFFC400)), // Amarillo
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),
        // MAIN CONTAINER
        Center(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // PRIMERA FILA
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon(
                      asset: "assets/icons/instagram_icon.png",
                      color: const Color(0xFFDD2A7B),
                      onTap: () =>
                          _open("https://www.instagram.com/radioactivatx/"),
                    ),
                    const SizedBox(width: 14),
                    _socialIcon(
                      asset: "assets/icons/facebook.png",
                      color: const Color(0xFF3B5998),
                      onTap: () => _open(
                          "https://www.facebook.com/radioactivatx89.9/?utm_source=chatgpt.com"),
                    ),
                    const SizedBox(width: 14),
                    _socialIcon(
                      asset: "assets/icons/x.webp",
                      color: Colors.black,
                      onTap: () => _open(
                          "https://x.com/RadioactivaTx?utm_source=chatgpt.com"),
                    ),
                    const SizedBox(width: 14),
                    _socialIcon(
                      asset: "assets/icons/youtube_icono.png",
                      color: Colors.red,
                      onTap: () =>
                          _open("https://www.youtube.com/@RadioactivaTX"),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // SECOND ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon(
                      asset: "assets/icons/tiktok.png",
                      color: Colors.black,
                      onTap: () =>
                          _open("https://www.tiktok.com/@radioactiva.tx"),
                    ),
                    const SizedBox(width: 14),
                    _socialIcon(
                      asset: "assets/icons/Telefono.png",
                      color: const Color.fromARGB(255, 71, 76, 217),
                      onTap: () => _open("https://wa.me/+524141199003"),
                    ),
                    const SizedBox(width: 14),
                    _socialIcon(
                      asset: "assets/icons/web_icono.png",
                      color: Colors.black,
                      onTap: () => _open(
                          "https://www.radioactivatx.org/?utm_source=chatgpt.com"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ────────── WIDGET DE CADA ICONO ──────────
  Widget _socialIcon({
    required String asset,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
