import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/providers/app_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final didOnboard = context.read<AppProvider>().didOnboard;
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          didOnboard ? '/home' : '/onboarding',
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.radio,
                color: Color.fromARGB(62, 255, 235, 59), size: 72),
            SizedBox(height: 16),
            Text(
              'Radioactiva Tx',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '¡La Radio Alternativa!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
