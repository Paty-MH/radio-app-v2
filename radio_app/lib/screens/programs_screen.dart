import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/constants.dart';
import '../widgets/program_card.dart';
import '../models/program_model.dart';
import '../screens/home_screen.dart';

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

      //two-column programs
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: GridView.builder(
          itemCount: programs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (_, i) {
            final Program p = programs[i];

            return ProgramCard(
              program: p,
              onTap: () {
                //OPEN THE SAME MODAL AS ON THE HOME
                HomeScreen().showProgramDialog(context, p);
              },
            );
          },
        ),
      ),
    );
  }
}
