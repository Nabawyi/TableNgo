// ignore_for_file: file_names, deprecated_member_use
import 'package:tablengo/WedgetsC/booking_details_card.dart';
import 'package:tablengo/WedgetsC/seat_card.dart';
import 'package:tablengo/data/resturant_data.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      appBar: AppBar(
        title: Image.asset('assets/images/Logo_orange.png', height: 50),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                    onPressed: () async {
                      if (selectedSeatIndex == null) return;
                      // ✅ 1. Prepare booking data
                      final int seatIndex = selectedSeatIndex!;
                      final DateTime bookingDate = DateTime.now();
                      final restaurant = widget.restaurant;
                      final Map<String, dynamic> bookingData = {
                        'restaurant_name': restaurant.name,
                        'location': restaurant.location,
                        'seat_index': seatIndex,
                        'booking_date': bookingDate.toIso8601String(),
                        'time': restaurant.seatData[seatIndex]['time'],
                        'seats': restaurant.seatData[seatIndex]['seats'],
                        'deposit': double.tryParse(
                          restaurant.seatData[seatIndex]['Deposit']
                              .toString()
                              .replaceAll(RegExp(r'[^0-9.]'), ''),
                        ),
                        'refund':
                            (double.tryParse(
                                  restaurant.seatData[seatIndex]['Deposit']
                                      .toString()
                                      .replaceAll(RegExp(r'[^0-9.]'), ''),
                                ) ??
                                0.0) *
                            (restaurant.refundAmount / 100),
                        'status': 'pending',
                      };

                      // ✅ 2. Insert booking data into Supabase
                      try {
                        final supabase = Supabase.instance.client;
                        await supabase
                            .from('booking_history')
                            .insert(bookingData);

                        // ✅ 3. Update local UI after successful booking
                        if (!bookedRestaurantsGlobal.contains(restaurant)) {
                          bookedRestaurantsGlobal.add(restaurant);
                        }

                        widget.onBookNow(restaurant, seatIndex, bookingDate);

                        // ✅ 4. Navigate back to booking history
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Booking added successfully ✅"),
                          ),
                        );
                      } catch (e) {
                        print('❌ Error inserting booking: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to add booking ❌"),
                          ),
                        );
                      }
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
