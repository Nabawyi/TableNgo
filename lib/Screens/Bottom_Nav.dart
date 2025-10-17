// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:TableNgo/Screens/Home_page.dart';
import 'package:TableNgo/Screens/booking_history.dart';
import 'package:TableNgo/Screens/profile_page.dart';
import 'package:TableNgo/Screens/booking_page.dart';
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

  // Global navigator key to access the main navigator from anywhere
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (context) => _buildCurrentPage(),
                );
              case '/booking':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => BookingPage(
                    restaurant: args['restaurant'] as ResturantData,
                    onBookNow:
                        args['onBookNow']
                            as Function(ResturantData, int, DateTime),
                  ),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => _buildCurrentPage(),
                );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.deepOrange,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Navigate to the new page
            _navigatorKey.currentState?.pushReplacementNamed('/');
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
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return SearchPage(
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
          onNavigateToBooking: (restaurant) {
            _navigatorKey.currentState?.pushNamed(
              '/booking',
              arguments: {
                'restaurant': restaurant,
                'onBookNow': (ResturantData r, int seatIndex, DateTime date) {
                  setState(() {
                    bookedRestaurants.add(
                      BookingItem(
                        restaurant: r,
                        selectedSeatIndex: seatIndex,
                        bookingDate: date,
                      ),
                    );
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking added to history')),
                  );
                },
              },
            );
          },
        );
      case 1:
        return MyBookingHistoy(
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
        );
      case 2:
        return const ProfileScreen();
      default:
        return SearchPage(
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
          onNavigateToBooking: (restaurant) {
            _navigatorKey.currentState?.pushNamed(
              '/booking',
              arguments: {
                'restaurant': restaurant,
                'onBookNow': (ResturantData r, int seatIndex, DateTime date) {
                  setState(() {
                    bookedRestaurants.add(
                      BookingItem(
                        restaurant: r,
                        selectedSeatIndex: seatIndex,
                        bookingDate: date,
                      ),
                    );
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking added to history')),
                  );
                },
              },
            );
          },
        );
    }
  }

  Future<bool> _onWillPop() async {
    // If we're not on the main page (i.e., we're on BookingPage), pop back to main page
    if (_navigatorKey.currentState?.canPop() == true) {
      _navigatorKey.currentState?.pop();
      return false; // Don't exit the app
    }

    // If we're on the main page, show exit confirmation
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Application?'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay in app
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Exit app
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; // Return false if dialog is dismissed
  }
}
