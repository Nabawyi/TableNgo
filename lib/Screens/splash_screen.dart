import 'dart:async';
import 'package:TableNgo/Screens/Welcome_screen.dart';
import 'package:TableNgo/Screens/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),()async {
      await Future.delayed(const Duration(seconds: 2)); // 👈 splash delay

    final session = supabase.auth.currentSession;

    if (session != null) {
      // ✅ Already logged in
      print("✅ User logged in: ${session.user.email}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavExample()),
      );
    } else {
      // 🚪 Not logged in
      print("🚪 No session found. Redirecting to WelcomeScreen...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
      
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Image.asset(
            "assets/images/Logo1.png",
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
