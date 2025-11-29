import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/providers/app_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ Después de 3 segundos → Home
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<AppProvider>().completeOnboarding();
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 📸 Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding.png',
              fit: BoxFit.cover,
            ),
          ),

          // 🔅 Capa amarilla suave
          Container(
            color: const Color(0xFFFFE76A).withOpacity(0.35),
          ),

          // ⭐ LOGO centrado
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // LOGO
                Image.asset(
                  'assets/images/logoRT.png',
                  height: 120,
                ),

                const SizedBox(height: 20),

                // TEXTO DE BIENVENIDA
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Cargando...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
