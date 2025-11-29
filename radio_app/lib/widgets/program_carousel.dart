import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../models/program_model.dart';

class ProgramCarousel extends StatelessWidget {
  final List<Program> programs;
  final Function(Program) onTap;

  const ProgramCarousel({
    super.key,
    required this.programs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: programs.length,
      itemBuilder: (context, index, _) {
        final p = programs[index];

        return GestureDetector(
          onTap: () => onTap(p),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(p.imageAsset),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            width: double.infinity,
          ),
        );
      },
      options: CarouselOptions(
        height: 320,
        enlargeCenterPage: true,
        enlargeFactor: 0.32, // 🔥 QUE CREZCAN AÚN MÁS
        viewportFraction: 0.99, // 🔥 Tarjeta más ancha
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }
}
