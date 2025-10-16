import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:TableNgo/Screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  const String supabaseUrl = 'https://hahtppvichfutzsvydye.supabase.co';
  const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhaHRwcHZpY2hmdXR6c3Z5ZHllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA0NDAwMjAsImV4cCI6MjA3NjAxNjAyMH0.4h3zolshVbylzwWw46CgrCi1yzZqQVZA6nRLRvzlQ0E';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // Global auth state listener
  final supabase = Supabase.instance.client;
  supabase.auth.onAuthStateChange.listen((data) {
    final event = data.event;
    final session = data.session;
    print('🔁 Auth change: $event | Session: ${session?.user.email}');
  });
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TableNgo',
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
