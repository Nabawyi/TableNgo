import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tablengo/Screens/splash_screen.dart';
import 'package:tablengo/config/supabase_config.dart';
import 'package:tablengo/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Logger.log('Initializing Supabase...', tag: 'SUPABASE');

    // Initialize Supabase with configuration
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );

    Logger.log('Supabase initialized successfully', tag: 'SUPABASE');

    // Global auth state listener with enhanced logging
    final supabase = Supabase.instance.client;
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      Logger.log(
        'Auth change: $event | Session: ${session?.user.email}',
        tag: 'AUTH',
      );
    });

    Logger.log('Auth state listener configured', tag: 'SUPABASE');
  } catch (e, stackTrace) {
    Logger.error(
      'Failed to initialize Supabase',
      tag: 'SUPABASE',
      error: e,
      stackTrace: stackTrace,
    );
    // Continue app initialization even if Supabase fails
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'tablengo',
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
