import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../models/program_model.dart';

class ProgramCarousel extends StatelessWidget {
  //List of programs that will be shown in the carousel
  final List<Program> programs;
  //Callback function that executes when you touch a card
  final Function(Program) onTap;

  const ProgramCarousel({
    super.key,
    required this.programs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      //Total number of cards
      itemCount: programs.length,
      //Constructor that draws each card in the carousel
      itemBuilder: (context, index, _) {
        final p = programs[index];

        return GestureDetector(
          //Execute the onTap function by sending the selected program.
          onTap: () => onTap(p),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            //Card aesthetics
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
            width: double.infinity, //Take up all available width
          ),
        );
      },
      //Carousel behavior settings
      options: CarouselOptions(
        height: 320,
        enlargeCenterPage: true,
        enlargeFactor: 0.32,
        viewportFraction: 0.99,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }
}
