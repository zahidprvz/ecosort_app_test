import 'package:ecosort_app_test/screens/splash_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green[700],
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.green[900],
          background: Colors.green[200], // Lighter green background
        ),
      ),
      home: const SplashScreen(),
    );
  }
}


