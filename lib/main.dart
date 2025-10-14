// ignore_for_file: unused_import

import 'package:TableNgo/Screens/booking_history.dart';
import 'package:TableNgo/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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
