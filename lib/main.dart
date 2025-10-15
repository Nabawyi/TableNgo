// ignore_for_file: unused_import

import 'package:TableNgo/Screens/booking_history.dart';
import 'package:TableNgo/Screens/splash_screen.dart';
import 'package:TableNgo/Subapase/test1.dart';
import 'package:TableNgo/Subapase/testsuba.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  
  String anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhaHRwcHZpY2hmdXR6c3Z5ZHllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA0NDAwMjAsImV4cCI6MjA3NjAxNjAyMH0.4h3zolshVbylzwWw46CgrCi1yzZqQVZA6nRLRvzlQ0E";
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Supabase.initialize(
    url: 'https://hahtppvichfutzsvydye.supabase.co',
    anonKey: anonKey
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // optional
      title: 'My Flutter App',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: SplashScreen(),
    );
  }
}
