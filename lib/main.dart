import 'package:flutter/material.dart';
import 'nosatu.dart';

void main() {
  runApp(const MyApp());
}

// Buat MaterialColor dari warna custom
MaterialColor customSwatch = const MaterialColor(
  0xFF3AB7AF,
  <int, Color>{
    50: Color(0xFFE0F7F5),
    100: Color(0xFFB3ECE7),
    200: Color(0xFF80DFD9),
    300: Color(0xFF4DD2CB),
    400: Color(0xFF26C8C0),
    500: Color(0xFF3AB7AF), // Warna utama
    600: Color(0xFF32AFA7),
    700: Color(0xFF28A59D),
    800: Color(0xFF1E9C94),
    900: Color(0xFF0D8C85),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chosen Music',
      theme: ThemeData(
        primarySwatch: customSwatch,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3AB7AF),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
