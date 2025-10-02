import 'package:flutter/material.dart';
import 'package:tablengo/Screens/Home_page.dart';

class BottomNavExample extends StatefulWidget {
  const BottomNavExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavExampleState createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavExample> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    SearchPage(),
    Center(child: Text("Search ", style: TextStyle(fontSize: 24))),
    Center(child: Text("Settings ", style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Show selected page
      bottomNavigationBar: BottomNavigationBar(
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
            label: "Booking",
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
