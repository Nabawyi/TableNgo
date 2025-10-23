// ignore_for_file: deprecated_member_use

import 'package:tablengo/data/booking_item.dart';
import 'package:tablengo/data/resturant_data.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/WedgetsC/booking_card.dart';

class MyBookingHistoy extends StatefulWidget {
  const MyBookingHistoy({
    super.key,
    required int index,
    required int selectedSeatIndex,
    required List<BookingItem> bookings,
    required ResturantData restaurant,
  });

  @override
  State<MyBookingHistoy> createState() => _MyBookingHistoyState();
}

class _MyBookingHistoyState extends State<MyBookingHistoy> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  /// ✅ Fetch bookings from Supabase
  Future<void> fetchBookings() async {
      final user = supabase.auth.currentUser;

    try {
      final response = await supabase
          .from('booking_history')
          .select()
          .eq('user_id', user!.id)
          .order('id', ascending: false);
      setState(() {
        bookings = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching bookings: $e');
      setState(() {
        isLoading = false;
      });
    }
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
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            )
          : bookings.isEmpty
          ? const Center(
              child: Text(
                "No bookings yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
            color: Colors.deepOrange,
            onRefresh: fetchBookings,
            child: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return BookingCard(bookings[index], index);
                  },
                ),
              ),
          ),
    );
  }
}
