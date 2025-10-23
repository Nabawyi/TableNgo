import 'dart:async';
import 'package:tablengo/Screens/Welcome_screen.dart';
import 'package:tablengo/Screens/bottom_nav.dart';
import 'package:tablengo/utils/logger.dart';
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
    Logger.log('Splash screen initialized', tag: 'SPLASH');

    Timer(const Duration(seconds: 2), () async {
      try {
        await Future.delayed(const Duration(seconds: 2));

        Logger.log('Checking authentication status...', tag: 'SPLASH');
        final session = supabase.auth.currentSession;

        if (session != null) {
          Logger.log('User logged in: ${session.user.email}', tag: 'SPLASH');
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BottomNavExample()),
            );
          }
        } else {
          Logger.log(
            'No session found. Redirecting to WelcomeScreen...',
            tag: 'SPLASH',
          );
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            );
          }
        }
      } catch (e, stackTrace) {
        Logger.error(
          'Error in splash screen navigation',
          tag: 'SPLASH',
          error: e,
          stackTrace: stackTrace,
        );
        if (mounted) {
          // Fallback to welcome screen on error
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          );
        }
      }
    });
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
