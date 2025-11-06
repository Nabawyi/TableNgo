import 'package:tablengo/Screens/booking_history.dart';
import 'package:tablengo/WedgetsC/booking_form.dart';
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
  final SupabaseClient supabase = Supabase.instance.client;
  static List<ResturantData> bookedRestaurantsGlobal = [];

  // Form state (passed from BookingForm)
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int numberOfSites = 1;
  double depositPerPerson = 0.0;
  double refundPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final userName = user?.userMetadata?['User_Name'] ?? '';
    final userPhone = user?.userMetadata?['phone'] ?? '';

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
              widget.restaurant.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              widget.restaurant.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Booking Form
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BookingForm(
                restaurantId: widget.restaurant.id!,
                onFormChanged: (date, time, sites, deposit, refund) {
                  setState(() {
                    selectedDate = date;
                    selectedTime = time;
                    numberOfSites = sites;
                    depositPerPerson = deposit;
                    refundPercent = refund;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // Book Now Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedDate == null || selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select date and time"),
                        ),
                      );
                      return;
                    }

                    final String bookedTime =
                        '${selectedTime!.hour.toString().padLeft(2, '0')}:'
                        '${selectedTime!.minute.toString().padLeft(2, '0')}:00';

                    final double deposit = depositPerPerson * numberOfSites;
                    final double refund = deposit * (refundPercent / 100);
                    final double totalPayable = deposit - refund;

                    final Map<String, dynamic> bookingData = {
                      'restaurant_name':widget.restaurant.name,
                      'restaurant_id': widget.restaurant.id,
                      'booked_date': selectedDate!
                          .toIso8601String()
                          .split('T')
                          .first,
                      'booked_time': bookedTime,
                      'number_of_seats': numberOfSites,
                      'deposit': deposit,
                      'refund': refund,
                      'total_payable': totalPayable,
                      'status': 'pending',
                      'user_name': userName,
                      'user_phone': userPhone,
                    };

                    try {
                      await supabase.from('bookings').insert(bookingData);

                      if (!bookedRestaurantsGlobal.contains(
                        widget.restaurant,
                      )) {
                        bookedRestaurantsGlobal.add(widget.restaurant);
                      }

                      widget.onBookNow(widget.restaurant, -1, selectedDate!);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyBookingHistoy(
                            index: 0,
                            bookings: [],
                            restaurant: widget.restaurant,
                          ),
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Booking confirmed!")),
                      );
                    } catch (e) {
                      print('Booking error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to book. Try again."),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
