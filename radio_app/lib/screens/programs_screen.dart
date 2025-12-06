import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/constants.dart';
import '../widgets/program_card.dart';
import '../models/program_model.dart';
import '../screens/home_screen.dart'; // 👈 NECESARIO para usar showProgramDialog

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFFC400)),
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            children: [
              const TextSpan(text: "Nuestros "),
              TextSpan(
                text: "Programas",
                style: GoogleFonts.poppins(
                  color: Color(0xFFFFC400),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),

      // ───────────────────────────────────────────────
      // GRID DE PROGRAMAS (2 COLUMNAS)
      // ───────────────────────────────────────────────
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: GridView.builder(
          itemCount: programs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 por fila
            crossAxisSpacing: 12, // espacio horizontal
            mainAxisSpacing: 12, // espacio vertical
            childAspectRatio: 0.78, // proporción como las imágenes
          ),
          itemBuilder: (_, i) {
            final Program p = programs[i];

            return ProgramCard(
              program: p,
              onTap: () {
                // 🔥 ABRIR EL MISMO MODAL QUE EN EL HOME 🔥
                HomeScreen().showProgramDialog(context, p);
              },
            );
          },
        ),
      ),
    );
  }
}
