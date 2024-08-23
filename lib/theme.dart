import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.teal,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
  primaryColor: Colors.teal[700],
  primaryColorLight: Colors.tealAccent[400],
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white,

  textTheme: GoogleFonts.poppinsTextTheme(
    TextTheme(
      headlineLarge: TextStyle(
          color: HexColor('#4D47C3'), fontWeight: FontWeight.bold, fontSize: 24),
      headlineMedium: TextStyle(
          color: HexColor('#4D47C3'), fontWeight: FontWeight.bold, fontSize: 20),
      bodyLarge: const TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: const TextStyle(color: Colors.black54, fontSize: 14),
    ),
  ).copyWith(
    bodyMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(color: Colors.black54, fontSize: 14),
    ),
  ),
  
  iconTheme: IconThemeData(color: Colors.teal[700]),
  appBarTheme: AppBarTheme(
    color: Colors.teal[700],
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.teal[700],
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.teal,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.dark,
  primaryColor: Colors.teal[900],
  primaryColorDark: Colors.tealAccent[700],
  scaffoldBackgroundColor: Colors.grey[900],
  cardColor: Colors.grey[800],

  textTheme: GoogleFonts.poppinsTextTheme(
    TextTheme(
      headlineLarge: TextStyle(
          color: Colors.tealAccent[200],
          fontWeight: FontWeight.bold,
          fontSize: 24),
      headlineMedium: TextStyle(
          color: Colors.tealAccent[100],
          fontWeight: FontWeight.bold,
          fontSize: 20),
      bodyLarge: const TextStyle(color: Colors.blue, fontSize: 16),
      bodyMedium: const TextStyle(color: Colors.blue, fontSize: 14),
    ),
  ),
  
  iconTheme: IconThemeData(color: Colors.tealAccent[200]),
  appBarTheme: AppBarTheme(
    color: Colors.teal[900],
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.grey[800],
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.teal[900],
    textTheme: ButtonTextTheme.primary,
  ),
);
