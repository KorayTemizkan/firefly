import 'package:flutter/material.dart';

ThemeData theme() {
  // Renkleri burada tek bir kez tanımlıyoruz:
  const Color primaryOrange = Color(0xFFFFA000);
  const Color customError = Color(0xFFE30613);

  return ThemeData(
    // Genel ayarlamalar
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,

    // ! Genel Renk Şeması
    colorScheme: const ColorScheme.light(
      primary: primaryOrange,
      secondary: primaryOrange,
      tertiary: Colors.white,
      error: customError,
      onSurface: Colors.black87,
      primaryContainer: primaryOrange,
      onPrimaryContainer: Colors.white,
    ),

    // ! OutlinedButton Teması
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryOrange, width: 1),
        foregroundColor: primaryOrange,
      ),
    ),

    // ! TextButton Teması
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryOrange),
    ),

    // ! AppBar Teması
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      backgroundColor: primaryOrange,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
    ),

    // ! BottomNavigationBar Teması
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: primaryOrange,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),

    // ! İkon Teması
    iconTheme: const IconThemeData(color: primaryOrange, size: 24),
  );
}
