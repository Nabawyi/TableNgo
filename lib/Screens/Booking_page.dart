// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tablengo/data/resturant_data.dart';

class BookingPage extends StatefulWidget {
  final ResturantData restaurant;

  const BookingPage({super.key, required this.restaurant});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int? selectedSeatIndex; // keep track of which seat is selected

  @override
  Widget build(BuildContext context) {
    final resturant = widget.restaurant;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Restaurant image
            Image.asset(
              resturant.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 20),

            // Restaurant name
            Text(
              resturant.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            const Text(
              "Available Seats",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 15),

            // Seat Cards
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(resturant.seatData.length, (index) {
                final seat = resturant.seatData[index];
                return SeatCard(
                  seats: seat['seats'] ?? '',
                  time: seat['time'] ?? '',
                  deposit: seat['Deposit'] ?? '',
                  isSelected: selectedSeatIndex == index,
                  onSelect: () {
                    setState(() {
                      // Toggle selection
                      selectedSeatIndex = selectedSeatIndex == index
                          ? null
                          : index;
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 20),

            // Booking details and button
            if (selectedSeatIndex != null) ...[
              bookingDetailsCard(
                resturant.seatData[selectedSeatIndex!]['seats'] ?? '',
                resturant.seatData[selectedSeatIndex!]['time'] ?? '',
                resturant.seatData[selectedSeatIndex!]['Deposit'] ?? '',
                resturant.refundAmount,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your booking logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Book Now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class SeatCard extends StatelessWidget {
  final String seats;
  final String time;
  final String deposit;
  final bool isSelected;
  final VoidCallback onSelect;

  const SeatCard({
    super.key,
    required this.seats,
    required this.time,
    required this.deposit,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 110,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.deepOrange.withOpacity(0.15)
              : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_alt_outlined,
              color: isSelected ? Colors.deepOrange : Colors.grey,
              size: 30,
            ),
            const SizedBox(height: 6),
            Text(
              seats,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? Colors.deepOrange : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}

Widget bookingDetailsCard(
  String seats,
  String time,
  String deposit,
  double refundAmount,
) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300, width: 1),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selected: $seats - $time",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("Deposit: $deposit"),
        Text(
          "Refund on arrival: EGP $refundAmount",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          "Total Payable:  $deposit",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
      ],
    ),
  );
}
