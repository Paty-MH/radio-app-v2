import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:just_audio_background/just_audio_background.dart';

import 'helpers/providers/audio_provider.dart';
import 'helpers/providers/app_provider.dart';

import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/player_screen.dart';
import 'screens/programs_screen.dart';

import 'helpers/constants.dart';
import 'app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 NECESARIO PARA SONIDO EN SEGUNDO PLANO
  await JustAudioBackground.init(
    androidNotificationChannelId: 'radio.tx.channel',
    androidNotificationChannelName: 'Radioactiva Tx',
    androidNotificationOngoing: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radioactiva Tx',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/onboarding': (_) => OnboardingScreen(),
        '/home': (_) => const HomeScreen(),
        '/programs': (_) => const ProgramsScreen(),

        // 🔥 PLAYER CON DATOS DINÁMICOS DE LA ESTACIÓN
        '/player': (context) {
          final app = Provider.of<AppProvider>(context, listen: false);
          final s = stations[app.currentStationIndex];

          return PlayerScreen(
            streamUrl: s.url,
            artUrl: s.imageAsset,
            stationName: s.name,
          );
        },
      },
    );
  }
}
