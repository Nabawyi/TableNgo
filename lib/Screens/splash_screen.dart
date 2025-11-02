import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/OWNER/owner_home.dart';
import 'package:tablengo/Screens/Welcome_screen.dart';
import 'package:tablengo/Screens/bottom_nav.dart';
import 'package:tablengo/utils/logger.dart';

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
        await Future.delayed(const Duration(seconds: 1));

        final session = supabase.auth.currentSession;
        Logger.log('Checking authentication status...', tag: 'SPLASH');

        if (session != null) {
          final user = session.user;
          final userId = user.id;
          final userEmail = user.email ?? '';

          Logger.log('User logged in: $userEmail (ID: $userId)', tag: 'SPLASH');

          // Check if this user is an owner using user_id (more reliable than email)
          final response = await supabase
              .from('restaurant_owners')
              .select('restaurant_id')
              .eq('user_id', userId)
              .maybeSingle();

          Logger.log('Owner query response: $response', tag: 'SPLASH');

          if (response != null && response['restaurant_id'] != null) {
            final restaurantId = response['restaurant_id'] as int;
            Logger.log(
              'Restaurant owner detected. Restaurant ID: $restaurantId',
              tag: 'SPLASH',
            );

            _goTo(OwnerHome(restaurantId: restaurantId));
          } else {
            Logger.log(
              'Normal user detected. Redirecting to BottomNav.',
              tag: 'SPLASH',
            );
            _goTo(const BottomNavExample());
          }
        } else {
          Logger.log(
            'No session found. Redirecting to WelcomeScreen...',
            tag: 'SPLASH',
          );
          _goTo(const WelcomeScreen());
        }
      } catch (e, stackTrace) {
        Logger.error(
          'Error in splash screen navigation',
          tag: 'SPLASH',
          error: e,
          stackTrace: stackTrace,
        );
        _goTo(const WelcomeScreen());
      }
    });
  }

  void _goTo(Widget page) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }
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
