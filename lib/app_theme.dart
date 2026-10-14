import 'package:flutter/material.dart';

class AppTheme {
    static const Color muted = Color(0xFF6B6B68);
    static const Color fieldColor = Color(0xFFF1F1EF);
  // Gaya serif (Newsreader) untuk judul dan link "Masuk"
      static TextStyle serif({double size = 32}) => TextStyle(
          fontFamily: 'Newsreader',
          fontSize: size,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        );

  static ThemeData get light => ThemeData(
        // Inter menjadi font dasar seluruh aplikasi
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF9F9F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F1EF),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF8E8E8C)),
          prefixIconColor: const Color(0xFF5F5F5C),
          suffixIconColor: const Color(0xFF5F5F5C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0, // menghilangkan bayangan, sesuai Figma
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}