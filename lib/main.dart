// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:tablengo/Screens/Home_page.dart';
import 'package:tablengo/Screens/Welcome_screen.dart';
import 'package:tablengo/Screens/Bottom_Nav.dart';

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
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: BottomNavExample(),
    );
  }
}
