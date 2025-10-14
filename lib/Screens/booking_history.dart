// ignore_for_file: deprecated_member_use

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

// ignore: non_constant_identifier_names
Widget BookingCard(
  ResturantData restaurant,
  int index,
  dynamic selectedSeatIndex,
) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    width: double.infinity,
    height: 250,
    margin: const EdgeInsets.only(bottom: 16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              restaurant.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Colors.grey.shade400,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              restaurant.location,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Booking ID:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '#${index + 1000}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_month, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '12 Aug, 2023',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '7:30 PM',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        selectedSeatIndex == 0
                            ? '2 Seats'
                            : selectedSeatIndex == 1
                            ? '4 Seats'
                            : '6 Seats',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Deposit Paid: \$20',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Refunded: \$15',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
