// ignore_for_file: deprecated_member_use

import 'package:TableNgo/WedgetsC/booking_card.dart';
import 'package:TableNgo/data/resturant_data.dart';
import 'package:flutter/material.dart';

class MyBookingHistoy extends StatefulWidget {
  final List<ResturantData> bookedRestaurants;
  final ResturantData restaurant;
  final int index;
  final int selectedSeatIndex;

  const MyBookingHistoy({
    super.key,
    required this.restaurant,
    required this.index,
    required this.selectedSeatIndex,
    required this.bookedRestaurants,
  });

  @override
  State<MyBookingHistoy> createState() => _MyBookingHistoyState();
}

class _MyBookingHistoyState extends State<MyBookingHistoy> {
  late List<ResturantData> bookedRestaurants;

  @override
  void initState() {
    super.initState();
    bookedRestaurants = widget.bookedRestaurants; // ✅ now holds the actual list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 20,
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      //bottomNavigationBar: BottomNavExample(),
      body: bookedRestaurants.isEmpty
          ? const Center(
              child: Text(
                "No bookings yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: ListView.builder(
                itemCount: bookedRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = bookedRestaurants[index];
                  return BookingCard(
                    restaurant,
                    index,
                    widget.selectedSeatIndex,
                  );
                },
              ),
            ),
    );
  }
}
