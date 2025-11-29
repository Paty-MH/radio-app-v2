import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String url) async {
  final uri = Uri.parse(url);
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok) {
    throw 'No se pudo abrir el enlace: $url';
  }
}
