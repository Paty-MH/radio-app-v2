import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Static light theme used across the app
  static ThemeData light = ThemeData(
    // Generates a color scheme using a seed color
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFC400)),

    // Default background color for all screens
    scaffoldBackgroundColor: Colors.white,

    // Global text theme using Montserrat font from Google Fonts
    textTheme: GoogleFonts.montserratTextTheme(),

    // Default styling applied to every AppBar in the app
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // Transparent AppBar
      foregroundColor: Colors.black,       // Text and icon color
      elevation: 0,                         // Removes shadow
      centerTitle: false,                   // Title aligned to the left
    ),
  );
}
