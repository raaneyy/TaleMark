import 'dart:async';
import 'package:flutter/material.dart';
import 'app_theme.dart'; // Import tema yang baru dibuat
import 'login_screen.dart'; // Halaman login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Konstruktor gaya baru

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaleMark',
      theme: AppTheme.light, // Menggunakan tema dari app_theme.dart
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}