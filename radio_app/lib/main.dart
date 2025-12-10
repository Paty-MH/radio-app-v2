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
  // Ensures Flutter bindings are initialized before running async code
  WidgetsFlutterBinding.ensureInitialized();

  // Required to enable background audio playback
  await JustAudioBackground.init(
    androidNotificationChannelId: 'radio.tx.channel', // Notification channel ID
    androidNotificationChannelName: 'Radioactiva Tx', // Name shown in Android notifications
    androidNotificationOngoing: true, // Keeps notification active while playing
  );

  // Run the app and inject providers
  runApp(
    MultiProvider(
      providers: [
        // Provider that manages all audio playback logic
        ChangeNotifierProvider(create: (_) => AudioProvider()),

        // Provider that manages app state (current station, UI mode, etc.)
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
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: AppTheme.light, // App theme configuration

      // First screen shown when the app opens
      initialRoute: '/splash',

      // All registered routes of the app
      routes: {
        '/splash': (_) => const SplashScreen(), // Splash screen
        '/onboarding': (_) => OnboardingScreen(), // Onboarding
        '/home': (_) => const HomeScreen(), // Main home screen
        '/programs': (_) => const ProgramsScreen(), // Programs screen

        // 🔥 Player screen with dynamic station data
        '/player': (context) {
          // Access the app provider (no rebuild on changes)
          final app = Provider.of<AppProvider>(context, listen: false);

          // Get the selected station based on current index
          final s = stations[app.currentStationIndex];

          // Pass station data to PlayerScreen
          return PlayerScreen(
            streamUrl: s.url,          // Streaming URL
            artUrl: s.imageAsset,      // Station artwork
            stationName: s.name,       // Station name
          );
        },
      },
    );
  }
}
