// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tablengo/Screens/Home_page.dart';
import 'package:tablengo/Screens/Welcome_screen.dart';
import 'package:tablengo/Screens/booking_page.dart';
import 'package:tablengo/Screens/bottom_Nav.dart';
import 'package:tablengo/Screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // optional
      title: 'My Flutter App',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}
