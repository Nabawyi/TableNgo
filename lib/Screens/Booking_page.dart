// ignore_for_file: file_names, deprecated_member_use
import 'package:TableNgo/WedgetsC/booking_details_card.dart';
import 'package:TableNgo/WedgetsC/seat_card.dart';
import 'package:TableNgo/data/resturant_data.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final ResturantData restaurant;
  final Function(ResturantData, int, DateTime) onBookNow;

  const BookingPage({
    super.key,
    required this.restaurant,
    required this.onBookNow,
  });
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  static List<ResturantData> bookedRestaurantsGlobal = [];
  int? selectedSeatIndex;
  @override
  Widget build(BuildContext context) {
    final resturant = widget.restaurant;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Image.network(
              resturant.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 20),
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
                      selectedSeatIndex = selectedSeatIndex == index
                          ? null
                          : index;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
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
                      if (!bookedRestaurantsGlobal.contains(
                        widget.restaurant,
                      )) {
                        bookedRestaurantsGlobal.add(widget.restaurant);
                      }
                      final int seatIndex = selectedSeatIndex!;
                      final DateTime bookingDate = DateTime.now();
                      widget.onBookNow(
                        widget.restaurant,
                        seatIndex,
                        bookingDate,
                      );
                      Navigator.pop(context);
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
