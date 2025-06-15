import 'package:flutter/material.dart';

// ثيم فاتح
final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 241, 241, 241),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
    ),
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: Color(0xFF042D46)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Agbalumo',
      fontSize: 16,
      color: Color(0xFF042D46),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Agbalumo',
      fontSize: 14,
      color: Color(0xFF042D46),
    ),
    titleLarge: TextStyle(
      fontFamily: 'Agbalumo',
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Color(0xFFA0D1EF),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFE0F2F7),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF042D46),
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  ),
);

// ثيم داكن
final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF042D46),
  scaffoldBackgroundColor: const Color.fromARGB(255, 10, 10, 10),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF042D46),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
    ),
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Agbalumo',
      fontSize: 16,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Agbalumo',
      fontSize: 14,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Agbalumo',
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF042D46),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF042D46),
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  ),
);
