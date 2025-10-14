import 'package:flutter/material.dart';
import 'package:TableNgo/Screens/Home_page.dart';
import 'package:TableNgo/Screens/booking_history.dart';
import 'package:TableNgo/Screens/profile_page.dart';
import 'package:TableNgo/data/resturant_data.dart';
import 'package:TableNgo/data/booking_item.dart';

class BottomNavExample extends StatefulWidget {
  const BottomNavExample({super.key});

  @override
  State<BottomNavExample> createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavExample> {
  int _currentIndex = 0;
  List<BookingItem> bookedRestaurants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Tab 0: Nested Navigator to keep bottom bar visible when pushing BookingPage
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => SearchPage(
                  onBooking: (restaurant, selectedSeatIndex, bookingDate) {
                    setState(() {
                      bookedRestaurants.add(
                        BookingItem(
                          restaurant: restaurant,
                          selectedSeatIndex: selectedSeatIndex,
                          bookingDate: bookingDate,
                        ),
                      );
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking added to history')),
                    );
                  },
                ),
              );
            },
          ),
          // Tab 1: Booking history uses the shared state list
          MyBookingHistoy(
            bookedRestaurants: bookedRestaurants,
            restaurant: ResturantData(
              name: '',
              image: '',
              seatData: const [],
              location: '',
              time: '',
              rating: 0.0,
              refundAmount: 80,
            ),
            index: 0,
            selectedSeatIndex: 0,
          ),
          // Tab 2: Profile
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
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
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
