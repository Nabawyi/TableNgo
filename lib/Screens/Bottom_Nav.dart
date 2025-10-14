// ignore_for_file: file_names

import 'package:TableNgo/Screens/Home_page.dart';
import 'package:TableNgo/Screens/booking_history.dart';
import 'package:TableNgo/Screens/profile_page.dart';
import 'package:TableNgo/data/resturant_data.dart';
import 'package:flutter/material.dart';


class BottomNavExample extends StatefulWidget {
  const BottomNavExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavExampleState createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavExample> {
  int _currentIndex = 0;

  // Pages in your navigation bar
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const SearchPage(),
      const Center(child: Text("Bookings Histry")), // Placeholder for Bookings
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Show selected page
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrange[800]),
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_time_outlined),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
