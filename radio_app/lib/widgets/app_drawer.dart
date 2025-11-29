import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String version = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        version = info.version;
      });
    } catch (_) {
      version = "1.0.0";
    }
  }

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo abrir el enlace")),
      );
    }
  }

  void _showListenDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Escúchanos",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                const Text("en estas plataformas",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 20),
                Image.asset("assets/images/listen2.png", height: 80),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Apple
                    GestureDetector(
                      onTap: () => _openLink("https://apple.com"),
                      child: Container(
                        width: 110,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Column(
                          children: [
                            Text("Apple",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 6),
                            Icon(Icons.apple, size: 30, color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    // Android
                    GestureDetector(
                      onTap: () => _openLink("https://play.google.com/store"),
                      child: Container(
                        width: 110,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Color(0xFF88C042),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Column(
                          children: [
                            Text("Android",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 6),
                            Icon(Icons.android, size: 30, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDrawerTile(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFD95E3D), size: 28),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
      minLeadingWidth: 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ✔ Header amarillo con logo como en tu imagen
          Container(
            width: double.infinity,
            color: const Color(0xFFFFD600),
            padding: const EdgeInsets.symmetric(vertical: 35),
            child: Center(
              child: Image.asset(
                "assets/images/logo.png",
                height: 75,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              children: [
                buildDrawerTile(Icons.share, "Comparte con un amigo", () {
                  Share.share(
                      "🎧 ¡Escucha Radioactiva Tx! https://radioactivatx.org");
                }),
                buildDrawerTile(Icons.star, "¡Califica nuestra app!", () {
                  _openLink("https://www.radioactivatx.org/acerca-de/");
                }),
                buildDrawerTile(Icons.people, "Nuestra Misión", () {
                  showAboutDialog(
                    context: context,
                    applicationName: "Radioactiva Tx",
                    applicationVersion: version,
                    children: const [
                      Text(
                          "Somos una estación dedicada a ofrecer una experiencia musical alternativa y cultural.")
                    ],
                  );
                }),
                buildDrawerTile(Icons.article, "Política de Privacidad", () {
                  _openLink(
                      "https://www.radioactivatx.org/politica-privacidad/");
                }),
                buildDrawerTile(Icons.radio, "Escúchanos en", () {
                  _showListenDialog();
                }),
                const SizedBox(height: 20),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                buildDrawerTile(Icons.info_outline, "Versión $version", () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
